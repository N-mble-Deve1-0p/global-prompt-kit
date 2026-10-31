# 安装本项目的 Skills 和全局准则 —— Windows（PowerShell 5.1 起；也可用 PowerShell 7 在 macOS/Linux 运行）。
# 推荐直接双击项目根目录的 install-windows.bat，它会调用本脚本并显示菜单。
#
# 用法：
#   .\scripts\install.ps1                                  交互菜单
#   .\scripts\install.ps1 -Target "claude,agents,kiro"     直接指定一个或多个目标：
#       claude     %USERPROFILE%\.claude\skills     Claude Code、Cherry Studio Agent        全局准则 → .claude\CLAUDE.md
#       agents     %USERPROFILE%\.agents\skills     GitHub Copilot（VS Code 等）、Kimi Code  全局准则 → .copilot\copilot-instructions.md、.kimi-code\AGENTS.md
#       kiro       %USERPROFILE%\.kiro\skills       Kiro                                    全局准则 → .kiro\steering\global-prompt-kit.md
#       workbuddy  %USERPROFILE%\.workbuddy-ai\skills（新版）或 .workbuddy\skills（旧版）  腾讯 WorkBuddy，全局准则需在界面里粘贴
#       all        以上全部
#       zip        重新打包 claude.ai 用的 ZIP（dist\skill-zips 已有现成的，一般不需要）
#   -Update      已安装的旧版本先备份，再换成新版本（默认跳过已安装的）
#   -NoRules     只装 Skills，不写全局准则文件
#   -Dest D:\x   把 Skills 装到自定义目录（只对单个目标有意义）
#
# 全局准则文件的写入规则：文件不存在就创建；是本项目以前生成的就更新（需 -Update）；
# 是你自己写的内容就不碰，只提示你手动合并。
#
# 如果提示"禁止运行脚本"，先在当前窗口执行：Set-ExecutionPolicy -Scope Process Bypass
param(
  [string]$Target = "menu",
  [switch]$Update,
  [switch]$NoRules,
  [string]$Dest = ""
)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Dist = Join-Path $Root "dist"
$SkillDirs = Get-ChildItem -Directory (Join-Path $Root "skills")
$UserHome = [Environment]::GetFolderPath("UserProfile")
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$script:ManualNotes = @()
$Valid = @("menu", "claude", "agents", "kiro", "workbuddy", "all", "zip")
$Targets = @($Target -split "[\s,，]+" | Where-Object { $_ } | ForEach-Object { $_.ToLower() })
foreach ($t in $Targets) {
  if ($Valid -notcontains $t) {
    Write-Host "未知选项：$t（可选 claude / agents / kiro / workbuddy / all / zip，多个用逗号分开，可加 -Update、-NoRules）"
    exit 1
  }
}
if ($Targets.Count -eq 0) { $Targets = @("menu") }

function P([string[]]$Parts) {
  # 逐段拼接路径，兼容 Windows 和 macOS/Linux 上的 PowerShell 7
  $p = $Parts[0]
  foreach ($x in $Parts[1..($Parts.Length - 1)]) { $p = Join-Path $p $x }
  return $p
}

function Make-Zips {
  Add-Type -AssemblyName System.IO.Compression
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $Out = Join-Path $Dist "skill-zips"
  New-Item -ItemType Directory -Force -Path $Out | Out-Null
  foreach ($d in $SkillDirs) {
    $zipPath = Join-Path $Out "$($d.Name).zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath }
    # 手动写入条目，确保压缩包内路径用 / 分隔（Windows 自带的 Compress-Archive 会写成 \，其他系统和网站可能无法识别）
    $zip = [System.IO.Compression.ZipFile]::Open($zipPath, "Create")
    try {
      foreach ($f in Get-ChildItem -Recurse -File $d.FullName) {
        if ($f.Name.StartsWith(".")) { continue }
        $rel = $f.FullName.Substring($d.FullName.Length).TrimStart("\", "/").Replace("\", "/")
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $f.FullName, "$($d.Name)/$rel") | Out-Null
      }
    } finally { $zip.Dispose() }
    Write-Host "已打包 $($d.Name).zip"
  }
  Write-Host "完成。claude.ai：Customize → Skills → + → Create skill → Upload a skill，逐个上传 dist\skill-zips 里的文件。"
}

function Install-Skills([string]$To, [string]$Label) {
  New-Item -ItemType Directory -Force -Path $To | Out-Null
  # 备份放在 skills 目录的旁边，而不是里面，避免旧版本被当成重复的 Skill 加载
  $backupRoot = Join-Path (Split-Path -Parent $To) "skills-backup"
  $backup = Join-Path $backupRoot $Stamp
  $n = 1
  while (Test-Path $backup) { $n++; $backup = Join-Path $backupRoot "$Stamp-$n" }
  $installed = 0; $updated = 0; $skipped = 0
  foreach ($d in $SkillDirs) {
    $t = Join-Path $To $d.Name
    if (Test-Path $t) {
      if ($Update) {
        New-Item -ItemType Directory -Force -Path $backup | Out-Null
        Move-Item $t (Join-Path $backup $d.Name)
        Copy-Item -Recurse $d.FullName $t
        $updated++
      } else { $skipped++ }
    } else {
      Copy-Item -Recurse $d.FullName $t
      $installed++
    }
  }
  Write-Host ""
  Write-Host "[$Label] Skills → $To"
  Write-Host "  新安装 $installed 个，更新 $updated 个，跳过 $skipped 个（已存在）"
  if ($updated -gt 0) { Write-Host "  旧版本已备份到：$backup" }
  if ($skipped -gt 0) { Write-Host "  想把已存在的换成新版本，请加 -Update 重新运行（或在菜单里选更新）。" }
}

function Write-Rules([string]$Src, [string]$To, [bool]$AddMarker) {
  if ($NoRules) { return }
  $marker = [IO.File]::ReadAllText((Join-Path $Dist "MARKER.txt")).Trim()
  if (Test-Path $To) {
    $existing = [IO.File]::ReadAllText($To)
    if (-not $existing.Contains("global-prompt-kit:")) {
      Write-Host "  全局准则：$To 已有你自己的内容，没有覆盖。"
      $script:ManualNotes += "把 dist\$(Split-Path -Leaf $Src) 的内容手动合并进 $To"
      return
    }
    if (-not $Update) {
      Write-Host "  全局准则：$To 已存在（本项目生成），跳过。加 -Update 可更新。"
      return
    }
    Copy-Item $To "$To.bak-$Stamp"
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $To) | Out-Null
  $content = [IO.File]::ReadAllText($Src)
  if ($AddMarker) { $content = "$marker`n`n$content" }
  # 以无 BOM 的 UTF-8 写入，各工具都能正确读取
  [IO.File]::WriteAllText($To, $content, $Utf8NoBom)
  if (Test-Path "$To.bak-$Stamp") {
    Write-Host "  全局准则 → $To（已更新，旧版备份为 $(Split-Path -Leaf $To).bak-$Stamp）"
  } else {
    Write-Host "  全局准则 → $To"
  }
}

function Do-Claude {
  $to = if ($Dest) { $Dest } else { P @($UserHome, ".claude", "skills") }
  Install-Skills $to "Claude Code / Cherry Studio Agent"
  Write-Rules (Join-Path $Dist "claude.md") (P @($UserHome, ".claude", "CLAUDE.md")) $true
  $script:ManualNotes += "Cherry Studio 聊天助手不读这些文件：把 dist\ 里对应模型的版本粘贴到助手的提示词里"
}
function Do-Agents {
  $to = if ($Dest) { $Dest } else { P @($UserHome, ".agents", "skills") }
  Install-Skills $to "GitHub Copilot / Kimi Code"
  Write-Rules (Join-Path $Dist "coding-agents.md") (P @($UserHome, ".copilot", "copilot-instructions.md")) $true
  if (Test-Path (Join-Path $UserHome ".kimi-code")) {
    Write-Rules (Join-Path $Dist "coding-agents.md") (P @($UserHome, ".kimi-code", "AGENTS.md")) $true
  }
}
function Do-Kiro {
  $to = if ($Dest) { $Dest } else { P @($UserHome, ".kiro", "skills") }
  Install-Skills $to "Kiro"
  Write-Rules (Join-Path $Dist "kiro-steering.md") (P @($UserHome, ".kiro", "steering", "global-prompt-kit.md")) $false
}
function Do-WorkBuddy {
  # 新版 WorkBuddy AI（5.x 起）使用 .workbuddy-ai\skills，旧版使用 .workbuddy\skills
  $wb = if (Test-Path (Join-Path $UserHome ".workbuddy-ai")) { P @($UserHome, ".workbuddy-ai", "skills") } else { P @($UserHome, ".workbuddy", "skills") }
  $to = if ($Dest) { $Dest } else { $wb }
  Install-Skills $to "WorkBuddy"
  $script:ManualNotes += "WorkBuddy：头像 → 设置 → 功能 → 个性化 → 自定义指令，粘贴 dist\lite-router.md；并在技能列表里确认本项目的技能都是「启用」状态"
  $script:ManualNotes += "如果 WorkBuddy 里看不到这些技能：完全退出 WorkBuddy 再打开；仍然没有，就在技能页面用「上传技能」导入"
}

if ($Targets -contains "menu") {
  Write-Host "======================================"
  Write-Host " Global Prompt Kit - 安装（Windows）"
  Write-Host "======================================"
  Write-Host "要装到哪些工具？可以多选，用空格分开，例如：1 3"
  Write-Host "  1) Claude Code（命令行或桌面版的 Code）、Cherry Studio Agent"
  Write-Host "  2) GitHub Copilot（VS Code、JetBrains 等）、Kimi Code"
  Write-Host "  3) Kiro"
  Write-Host "  4) 腾讯 WorkBuddy"
  Write-Host "  5) 以上全部"
  Write-Host "  z) 重新打包 claude.ai 用的 ZIP（一般不需要，dist\skill-zips 里已有）"
  Write-Host "  q) 退出"
  Write-Host ""
  Write-Host "  Claude 网页版/桌面聊天、Gemini、Kimi 网页版不需要运行本脚本，见 docs\install.md。"
  $choice = Read-Host "请输入编号后按回车"
  $Targets = @()
  foreach ($c in ($choice -split "[\s,，]+" | Where-Object { $_ })) {
    switch ($c) {
      "1" { $Targets += "claude" }
      "2" { $Targets += "agents" }
      "3" { $Targets += "kiro" }
      "4" { $Targets += "workbuddy" }
      "5" { $Targets += "all" }
      { $_ -in @("z", "Z") } { $Targets += "zip" }
      default { Write-Host "已退出。"; exit 0 }
    }
  }
  if ($Targets.Count -eq 0) { Write-Host "已退出。"; exit 0 }
  if (-not ($Targets -contains "zip")) {
    $yn = Read-Host "如果以前装过，要更新成新版本吗？旧版本会先备份。(y/N)"
    if ($yn -match "^(y|yes)$") { $Update = $true }
    $yn = Read-Host "同时安装全局准则吗？只会创建新文件或更新本项目生成的文件，不会覆盖你自己写的。(Y/n)"
    if ($yn -match "^(n|no)$") { $NoRules = $true }
  }
}

if ($Targets -contains "all") { $Targets = @("claude", "agents", "kiro", "workbuddy") }

foreach ($t in $Targets) {
  switch ($t) {
    "claude"    { Do-Claude }
    "agents"    { Do-Agents }
    "kiro"      { Do-Kiro }
    "workbuddy" { Do-WorkBuddy }
    "zip"       { Make-Zips }
  }
}

if ($script:ManualNotes.Count -gt 0) {
  Write-Host ""
  Write-Host "还需要你手动做的："
  foreach ($m in ($script:ManualNotes | Select-Object -Unique)) { Write-Host "  - $m" }
}
Write-Host ""
Write-Host "完成。重启对应的应用后生效。"
