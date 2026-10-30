# 安装本项目的 Skills —— Windows（PowerShell 5.1 起；也可用 PowerShell 7 在 macOS/Linux 运行）。
# 推荐直接双击项目根目录的 install-windows.bat，它会调用本脚本并显示菜单。
#
# 用法：
#   .\scripts\install.ps1                        交互菜单
#   .\scripts\install.ps1 -Target claude         安装到 %USERPROFILE%\.claude\skills     Claude Code、Cherry Studio Agent
#   .\scripts\install.ps1 -Target workbuddy      安装到 %USERPROFILE%\.workbuddy\skills  腾讯 WorkBuddy
#   .\scripts\install.ps1 -Target both           两处都装
#   .\scripts\install.ps1 -Target zip            重新打包 claude.ai 用的 ZIP（dist\skill-zips 已有现成的，一般不需要）
#   加 -Update                                   已安装的旧版本先备份，再换成新版本（默认跳过已安装的）
#   加 -Dest D:\my\skills                        安装到自定义目录
#
# 如果提示"禁止运行脚本"，先在当前窗口执行：Set-ExecutionPolicy -Scope Process Bypass
param(
  [ValidateSet("menu", "claude", "workbuddy", "both", "zip")]
  [string]$Target = "menu",
  [switch]$Update,
  [string]$Dest = ""
)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$SkillDirs = Get-ChildItem -Directory (Join-Path $Root "skills")
$UserHome = [Environment]::GetFolderPath("UserProfile")

function Make-Zips {
  Add-Type -AssemblyName System.IO.Compression
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $Out = Join-Path (Join-Path $Root "dist") "skill-zips"
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

function Install-To([string]$To, [string]$Label) {
  New-Item -ItemType Directory -Force -Path $To | Out-Null
  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  # 备份放在 skills 目录的旁边，而不是里面，避免旧版本被当成重复的 Skill 加载
  $backupRoot = Join-Path (Split-Path -Parent $To) "skills-backup"
  $backup = Join-Path $backupRoot $stamp
  $n = 1
  while (Test-Path $backup) { $n++; $backup = Join-Path $backupRoot "$stamp-$n" }
  $installed = 0; $updated = 0; $skipped = 0
  foreach ($d in $SkillDirs) {
    $target = Join-Path $To $d.Name
    if (Test-Path $target) {
      if ($Update) {
        New-Item -ItemType Directory -Force -Path $backup | Out-Null
        Move-Item $target (Join-Path $backup $d.Name)
        Copy-Item -Recurse $d.FullName $target
        $updated++
      } else { $skipped++ }
    } else {
      Copy-Item -Recurse $d.FullName $target
      $installed++
    }
  }
  Write-Host ""
  Write-Host "[$Label] $To"
  Write-Host "  新安装 $installed 个，更新 $updated 个，跳过 $skipped 个（已存在）"
  if ($updated -gt 0) { Write-Host "  旧版本已备份到：$backup" }
  if ($skipped -gt 0) { Write-Host "  想把已存在的换成新版本，请加 -Update 重新运行（或在菜单里选更新）。" }
}

function Install-Claude {
  $to = if ($Dest) { $Dest } else { Join-Path (Join-Path $UserHome ".claude") "skills" }
  Install-To $to "Claude Code / Cherry Studio Agent"
}

function Install-WorkBuddy {
  $to = if ($Dest) { $Dest } else { Join-Path (Join-Path $UserHome ".workbuddy") "skills" }
  Install-To $to "WorkBuddy"
  if ($env:APPDATA) {
    Write-Host "  如果 WorkBuddy 里看不到这些 Skill：在它的 Skills 管理界面导入，或用 -Dest 指定 $env:APPDATA\WorkBuddy\skills 再试。"
  }
}

if ($Target -eq "menu") {
  Write-Host "======================================"
  Write-Host " Global Prompt Kit - Skills 安装（Windows）"
  Write-Host "======================================"
  Write-Host "要装到哪里？"
  Write-Host "  1) Claude Code（命令行或桌面版的 Code）、Cherry Studio Agent"
  Write-Host "  2) 腾讯 WorkBuddy"
  Write-Host "  3) 以上两个都装"
  Write-Host "  4) 重新打包 claude.ai 用的 ZIP（一般不需要，dist\skill-zips 里已有）"
  Write-Host "  q) 退出"
  Write-Host ""
  Write-Host "  Claude 网页版/桌面聊天、Gemini 不需要运行本脚本，见 docs\install.md。"
  $choice = Read-Host "请输入编号后按回车"
  switch ($choice) {
    "1" { $Target = "claude" }
    "2" { $Target = "workbuddy" }
    "3" { $Target = "both" }
    "4" { $Target = "zip" }
    default { Write-Host "已退出。"; exit 0 }
  }
  if ($Target -ne "zip") {
    $yn = Read-Host "如果以前装过，要更新成新版本吗？旧版本会先备份。(y/N)"
    if ($yn -match "^(y|yes)$") { $Update = $true }
  }
}

switch ($Target) {
  "claude"    { Install-Claude }
  "workbuddy" { Install-WorkBuddy }
  "both"      { Install-Claude; Install-WorkBuddy }
  "zip"       { Make-Zips }
}
Write-Host ""
Write-Host "完成。重启对应的应用后生效。"
