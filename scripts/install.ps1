# 安装本项目的 Skills 和全局准则 —— Windows（PowerShell 5.1 起；也可用 PowerShell 7 在 macOS/Linux 运行）。
# 推荐直接双击项目根目录的 install-windows.bat，它会调用本脚本并显示菜单。
#
# 用法：
#   .\scripts\install.ps1                                  交互菜单
#   .\scripts\install.ps1 -Target "claude,agents,kiro"     直接指定一个或多个目标：
#       claude     %USERPROFILE%\.claude\skills     Claude Code、Z Code、Cherry Studio Agent  全局准则 → .claude\CLAUDE.md、.zcode\AGENTS.md
#       agents     %USERPROFILE%\.agents\skills     Kilo Code、GitHub Copilot、Kimi Code      全局准则 → .copilot\copilot-instructions.md、.kimi-code\AGENTS.md（Kilo Code 需手动设置）
#       cline      %USERPROFILE%\.cline\skills      Cline（VS Code 插件）                     全局准则 → .cline\rules\global-prompt-kit.md
#       kiro       %USERPROFILE%\.kiro\skills       Kiro                                    全局准则 → .kiro\steering\global-prompt-kit.md
#       workbuddy  %USERPROFILE%\.workbuddy-ai\skills（新版）或 .workbuddy\skills（旧版）  腾讯 WorkBuddy，全局准则需在界面里粘贴
#       all        以上全部
#       check      只检查各工具的安装情况（技能是否齐全、是否最新；全局准则是否存在、是否最新），不安装
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
$Valid = @("menu", "claude", "agents", "cline", "kiro", "workbuddy", "all", "zip", "check")
$Targets = @($Target -split "[\s,，]+" | Where-Object { $_ } | ForEach-Object { $_.ToLower() })
foreach ($t in $Targets) {
  if ($Valid -notcontains $t) {
    Write-Host "未知选项：$t（可选 claude / agents / cline / kiro / workbuddy / all / check / zip，多个用逗号分开，可加 -Update、-NoRules）"
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
  Install-Skills $to "Claude Code / Z Code / Cherry Studio Agent"
  Write-Rules (Join-Path $Dist "claude.md") (P @($UserHome, ".claude", "CLAUDE.md")) $true
  if (Test-Path (Join-Path $UserHome ".zcode")) {
    Write-Rules (Join-Path $Dist "coding-agents.md") (P @($UserHome, ".zcode", "AGENTS.md")) $true
  }
  $script:ManualNotes += "Cherry Studio 聊天助手不读这些文件：把 dist\ 里对应模型的版本粘贴到助手的提示词里"
}
function Do-Agents {
  $to = if ($Dest) { $Dest } else { P @($UserHome, ".agents", "skills") }
  Install-Skills $to "Kilo Code / GitHub Copilot / Kimi Code"
  Write-Rules (Join-Path $Dist "coding-agents.md") (P @($UserHome, ".copilot", "copilot-instructions.md")) $true
  if (Test-Path (Join-Path $UserHome ".kimi-code")) {
    Write-Rules (Join-Path $Dist "coding-agents.md") (P @($UserHome, ".kimi-code", "AGENTS.md")) $true
  }
  $script:ManualNotes += "Kilo Code 的全局准则需要手动设置，方法见 adapters\kilo-code.md"
}
function Do-Cline {
  $to = if ($Dest) { $Dest } else { P @($UserHome, ".cline", "skills") }
  Install-Skills $to "Cline"
  Write-Rules (Join-Path $Dist "coding-agents.md") (P @($UserHome, ".cline", "rules", "global-prompt-kit.md")) $true
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

function Same-Dir([string]$A, [string]$B) {
  foreach ($f in Get-ChildItem -Recurse -File $A) {
    if ($f.Name.StartsWith(".")) { continue }
    $rel = $f.FullName.Substring($A.Length).TrimStart("\", "/")
    $other = Join-Path $B $rel
    if (-not (Test-Path $other)) { return $false }
    if ((Get-FileHash $f.FullName).Hash -ne (Get-FileHash $other).Hash) { return $false }
  }
  return $true
}

function Check-Skills([string]$Dir) {
  if (-not (Test-Path $Dir)) { Write-Host "  技能：[未安装] 没有找到 $Dir"; return }
  $present = 0; $missing = @(); $differ = @()
  foreach ($d in $SkillDirs) {
    $t = Join-Path $Dir $d.Name
    if (Test-Path (Join-Path $t "SKILL.md")) {
      $present++
      if (-not (Same-Dir $d.FullName $t)) { $differ += $d.Name }
    } else { $missing += $d.Name }
  }
  $total = $SkillDirs.Count
  if ($present -eq $total -and $differ.Count -eq 0) {
    Write-Host "  技能：[正常] $present/$total 个，均为最新版（$Dir）"
  } else {
    Write-Host "  技能：[需处理] 已安装 $present/$total 个（$Dir）"
    if ($missing.Count -gt 0) { Write-Host "    缺少：$($missing -join ' ')" }
    if ($differ.Count -gt 0) { Write-Host "    不是最新版：$($differ -join ' ')（重新运行安装器，更新选 y）" }
  }
}

function Check-Rules([string]$File, [string]$Src, [bool]$AddMarker) {
  $srcName = Split-Path -Leaf $Src
  if (-not (Test-Path $File)) { Write-Host "  全局准则：[未安装] 没有找到 $File"; return }
  $actual = [IO.File]::ReadAllText($File)
  if ($actual.Contains("global-prompt-kit:")) {
    $expected = [IO.File]::ReadAllText($Src)
    if ($AddMarker) {
      $marker = [IO.File]::ReadAllText((Join-Path $Dist "MARKER.txt")).Trim()
      $expected = "$marker`n`n$expected"
    }
    if ($actual -eq $expected) { Write-Host "  全局准则：[正常] 最新版（$File）" }
    else { Write-Host "  全局准则：[需处理] 已安装但不是最新版（$File）。重新运行安装器，更新选 y" }
  } elseif ($actual.Contains("全局工作准则")) {
    Write-Host "  全局准则：[正常] 已手动合并进 $File（无法自动判断是否最新，可对照 dist\$srcName）"
  } else {
    Write-Host "  全局准则：[需处理] $File 是你自己的内容，里面没有本项目的全局准则。请手动合并 dist\$srcName"
  }
}

function Do-Check {
  $wb = if (Test-Path (Join-Path $UserHome ".workbuddy-ai")) { P @($UserHome, ".workbuddy-ai", "skills") } else { P @($UserHome, ".workbuddy", "skills") }
  Write-Host ""
  Write-Host "======================================"
  Write-Host " 安装情况检查（对照本项目当前版本）"
  Write-Host "======================================"
  Write-Host "[1] Claude Code / Z Code / Cherry Studio Agent（共用技能文件夹）"
  Check-Skills (P @($UserHome, ".claude", "skills"))
  Write-Host "  Claude Code："
  Check-Rules (P @($UserHome, ".claude", "CLAUDE.md")) (Join-Path $Dist "claude.md") $true
  if (Test-Path (Join-Path $UserHome ".zcode")) {
    Write-Host "  Z Code："
    Check-Rules (P @($UserHome, ".zcode", "AGENTS.md")) (Join-Path $Dist "coding-agents.md") $true
  }
  Write-Host "[2] Kilo Code / GitHub Copilot / Kimi Code（共用技能文件夹）"
  Check-Skills (P @($UserHome, ".agents", "skills"))
  Write-Host "  GitHub Copilot："
  Check-Rules (P @($UserHome, ".copilot", "copilot-instructions.md")) (Join-Path $Dist "coding-agents.md") $true
  if (Test-Path (Join-Path $UserHome ".kimi-code")) {
    Write-Host "  Kimi Code："
    Check-Rules (P @($UserHome, ".kimi-code", "AGENTS.md")) (Join-Path $Dist "coding-agents.md") $true
  }
  Write-Host "  Kilo Code：全局准则需要在 Kilo Code 的配置里查看（见 adapters\kilo-code.md）"
  Write-Host "[3] Cline"
  Check-Skills (P @($UserHome, ".cline", "skills"))
  Check-Rules (P @($UserHome, ".cline", "rules", "global-prompt-kit.md")) (Join-Path $Dist "coding-agents.md") $true
  Write-Host "[4] Kiro"
  Check-Skills (P @($UserHome, ".kiro", "skills"))
  Check-Rules (P @($UserHome, ".kiro", "steering", "global-prompt-kit.md")) (Join-Path $Dist "kiro-steering.md") $false
  Write-Host "[5] WorkBuddy"
  Check-Skills $wb
  Write-Host "  全局准则：需要在 WorkBuddy 里查看（头像 → 设置 → 功能 → 个性化 → 自定义指令）"
  Write-Host ""
  Write-Host "没用的工具显示[未安装]是正常的。"
  Write-Host "Claude 网页版/桌面聊天、Gemini、Kimi（网页版和桌面版）、Cherry Studio 聊天助手无法从电脑上检查，"
  Write-Host "验证方法见 docs\install.md 的「验证安装」一节。"
}

if ($Targets -contains "menu") {
  Write-Host "======================================"
  Write-Host " Global Prompt Kit - 安装（Windows）"
  Write-Host "======================================"
  Write-Host "要装到哪些工具？可以多选，用空格分开，例如：1 3"
  Write-Host "  1) Claude Code、Z Code、Cherry Studio Agent"
  Write-Host "  2) Kilo Code（VS Code 插件）、GitHub Copilot、Kimi Code"
  Write-Host "  3) Cline（VS Code 插件）"
  Write-Host "  4) Kiro"
  Write-Host "  5) 腾讯 WorkBuddy"
  Write-Host "  6) 以上全部"
  Write-Host "  c) 只检查各工具的安装情况，不安装"
  Write-Host "  z) 重新打包 claude.ai 用的 ZIP（一般不需要，dist\skill-zips 里已有）"
  Write-Host "  q) 退出"
  Write-Host ""
  Write-Host "  Claude 网页版/桌面聊天、Gemini、Kimi（网页版和桌面版）不需要运行本脚本，见 docs\install.md。"
  $choice = Read-Host "请输入编号后按回车"
  $Targets = @()
  foreach ($c in ($choice -split "[\s,，]+" | Where-Object { $_ })) {
    switch ($c) {
      "1" { $Targets += "claude" }
      "2" { $Targets += "agents" }
      "3" { $Targets += "cline" }
      "4" { $Targets += "kiro" }
      "5" { $Targets += "workbuddy" }
      "6" { $Targets += "all" }
      { $_ -in @("z", "Z") } { $Targets += "zip" }
      { $_ -in @("c", "C") } { $Targets += "check" }
      default { Write-Host "已退出。"; exit 0 }
    }
  }
  if ($Targets.Count -eq 0) { Write-Host "已退出。"; exit 0 }
  if (-not ($Targets -contains "zip") -and -not ($Targets -contains "check")) {
    $yn = Read-Host "如果以前装过，要更新成新版本吗？旧版本会先备份。(y/N)"
    if ($yn -match "^(y|yes)$") { $Update = $true }
    $yn = Read-Host "同时安装全局准则吗？只会创建新文件或更新本项目生成的文件，不会覆盖你自己写的。(Y/n)"
    if ($yn -match "^(n|no)$") { $NoRules = $true }
  }
}

if ($Targets -contains "all") { $Targets = @("claude", "agents", "cline", "kiro", "workbuddy") }

foreach ($t in $Targets) {
  switch ($t) {
    "claude"    { Do-Claude }
    "agents"    { Do-Agents }
    "cline"     { Do-Cline }
    "kiro"      { Do-Kiro }
    "workbuddy" { Do-WorkBuddy }
    "zip"       { Make-Zips }
    "check"     { Do-Check; exit 0 }
  }
}

if ($script:ManualNotes.Count -gt 0) {
  Write-Host ""
  Write-Host "还需要你手动做的："
  foreach ($m in ($script:ManualNotes | Select-Object -Unique)) { Write-Host "  - $m" }
}
Write-Host ""
Write-Host "完成。重启对应的应用后生效。"
