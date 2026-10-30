#!/usr/bin/env bash
# 安装本项目的 Skills —— macOS / Linux（也可在 Windows 的 Git Bash 中运行）。
# Windows 用户推荐双击项目根目录的 install-windows.bat。
#
# 用法：
#   bash scripts/install.sh                交互菜单（双击 install-macos.command / install-linux.sh 时也是这个）
#   bash scripts/install.sh claude         安装到 ~/.claude/skills      Claude Code、Cherry Studio Agent
#   bash scripts/install.sh workbuddy      安装到 ~/.workbuddy/skills   腾讯 WorkBuddy（仅 Windows、macOS）
#   bash scripts/install.sh both           两处都装
#   bash scripts/install.sh zip            重新打包 claude.ai 用的 ZIP（dist/skill-zips 已有现成的，一般不需要）
#   加 --update                            已安装的旧版本先备份，再换成新版本（默认跳过已安装的）
#   SKILLS_DIR=/任意/目录 bash scripts/install.sh claude    安装到自定义目录
#
# 只用 bash 3.2 自带功能，macOS 自带的 bash 即可运行，无需额外安装任何东西。
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET=""
UPDATE=0
for arg in "$@"; do
  case "$arg" in
    --update|-u) UPDATE=1 ;;
    *) TARGET="$arg" ;;
  esac
done

# ---------- 识别系统 ----------
OS="$(uname -s 2>/dev/null || echo unknown)"
IS_WSL=0
if [ "$OS" = "Linux" ] && grep -qi microsoft /proc/version 2>/dev/null; then IS_WSL=1; fi
case "$OS" in
  Darwin) OS_NAME="macOS" ;;
  Linux)  OS_NAME="Linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS_NAME="Windows (Git Bash)" ;;
  *) OS_NAME="$OS" ;;
esac

say() { printf '%s\n' "$*"; }

if [ "$IS_WSL" = 1 ]; then
  say "提示：你在 WSL（Windows 里的 Linux 子系统）中运行。"
  say "      这里装的 Skill 只对 WSL 里的程序生效。Windows 上的 Claude Code、Cherry Studio、WorkBuddy"
  say "      请改为在 Windows 里双击 install-windows.bat。"
  say ""
fi

# ---------- 打包 ZIP ----------
make_zips() {
  OUT="$ROOT/dist/skill-zips"
  mkdir -p "$OUT"
  if command -v zip >/dev/null 2>&1; then
    for dir in "$ROOT"/skills/*/; do
      name="$(basename "$dir")"
      rm -f "$OUT/$name.zip"
      (cd "$ROOT/skills" && zip -qr -X "$OUT/$name.zip" "$name" -x '*/.DS_Store' '*/.*')
      say "已打包 $name.zip"
    done
  elif command -v python3 >/dev/null 2>&1; then
    python3 "$ROOT/scripts/build.py"
  else
    say "没找到 zip 或 python3。dist/skill-zips/ 里已经有打包好的 ZIP，可以直接上传。"
    say "Linux 可以用包管理器安装 zip，例如：sudo apt install zip"
    return 1
  fi
  say "完成。claude.ai：Customize → Skills → + → Create skill → Upload a skill，逐个上传 dist/skill-zips/ 里的文件。"
}

# ---------- 安装到某个目录 ----------
install_to() {
  dest="$1"
  label="$2"
  mkdir -p "$dest"
  stamp="$(date +%Y%m%d-%H%M%S)"
  # 备份放在 skills 目录的旁边，而不是里面，避免旧版本被当成重复的 Skill 加载
  backup="$(dirname "$dest")/skills-backup/$stamp"
  n=1
  while [ -e "$backup" ]; do n=$((n + 1)); backup="$(dirname "$dest")/skills-backup/$stamp-$n"; done
  installed=0; skipped=0; updated=0
  for dir in "$ROOT"/skills/*/; do
    src="${dir%/}"
    name="$(basename "$src")"
    if [ -e "$dest/$name" ]; then
      if [ "$UPDATE" = 1 ]; then
        mkdir -p "$backup"
        mv "$dest/$name" "$backup/$name"
        cp -R "$src" "$dest/$name"
        updated=$((updated + 1))
      else
        skipped=$((skipped + 1))
      fi
    else
      cp -R "$src" "$dest/$name"
      installed=$((installed + 1))
    fi
  done
  say ""
  say "[$label] $dest"
  say "  新安装 $installed 个，更新 $updated 个，跳过 $skipped 个（已存在）"
  if [ "$updated" -gt 0 ]; then say "  旧版本已备份到：$backup"; fi
  if [ "$skipped" -gt 0 ]; then say "  想把已存在的换成新版本，请加 --update 重新运行（或在菜单里选更新）。"; fi
}

install_claude()    { install_to "${SKILLS_DIR:-$HOME/.claude/skills}" "Claude Code / Cherry Studio Agent"; }
install_workbuddy() {
  if [ "$OS_NAME" = "Linux" ] && [ "$IS_WSL" = 0 ]; then
    say "注意：WorkBuddy 目前只有 Windows 和 macOS 版本，Linux 上装了也用不上。"
  fi
  install_to "${SKILLS_DIR:-$HOME/.workbuddy/skills}" "WorkBuddy"
}

# ---------- 交互菜单 ----------
menu() {
  say "======================================"
  say " Global Prompt Kit - Skills 安装"
  say " 当前系统：$OS_NAME"
  say "======================================"
  say "要装到哪里？"
  say "  1) Claude Code（命令行或桌面版的 Code）、Cherry Studio Agent"
  say "  2) 腾讯 WorkBuddy"
  say "  3) 以上两个都装"
  say "  4) 重新打包 claude.ai 用的 ZIP（一般不需要，dist/skill-zips 里已有）"
  say "  q) 退出"
  say ""
  say "  Claude 网页版/桌面聊天、Gemini 不需要运行本脚本，见 docs/install.md。"
  printf '请输入编号后按回车：'
  read -r choice || choice=q
  case "$choice" in
    1) TARGET=claude ;;
    2) TARGET=workbuddy ;;
    3) TARGET=both ;;
    4) TARGET=zip ;;
    *) say "已退出。"; exit 0 ;;
  esac
  if [ "$TARGET" != "zip" ]; then
    printf '如果以前装过，要更新成新版本吗？旧版本会先备份。(y/N)：'
    read -r yn || yn=n
    case "$yn" in y|Y|yes|YES) UPDATE=1 ;; esac
  fi
}

if [ -z "$TARGET" ] || [ "$TARGET" = "menu" ]; then menu; fi

case "$TARGET" in
  claude)    install_claude ;;
  workbuddy) install_workbuddy ;;
  both)      install_claude; install_workbuddy ;;
  zip|--zip) make_zips ;;
  *) say "未知选项：$TARGET（可选 claude / workbuddy / both / zip，可加 --update）"; exit 1 ;;
esac

say ""
say "完成。重启对应的应用后生效。"
