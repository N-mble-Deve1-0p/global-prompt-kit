#!/usr/bin/env bash
# 安装本项目的 Skills 和全局准则 —— macOS / Linux（也可在 Windows 的 Git Bash 中运行）。
# Windows 用户推荐双击项目根目录的 install-windows.bat。
#
# 用法：
#   bash scripts/install.sh                          交互菜单
#   bash scripts/install.sh claude agents kiro       直接指定一个或多个目标：
#       claude     ~/.claude/skills      Claude Code、Z Code、Cherry Studio Agent  全局准则 → ~/.claude/CLAUDE.md、~/.zcode/AGENTS.md
#       agents     ~/.agents/skills      Kilo Code、GitHub Copilot、Kimi Code      全局准则 → ~/.copilot/copilot-instructions.md、~/.kimi-code/AGENTS.md（Kilo Code 需手动设置）
#       cline      ~/.cline/skills       Cline（VS Code 插件）                     全局准则 → ~/.cline/rules/global-prompt-kit.md
#       kiro       ~/.kiro/skills        Kiro                                    全局准则 → ~/.kiro/steering/global-prompt-kit.md
#       workbuddy  ~/.workbuddy-ai/skills（新版 WorkBuddy AI）或 ~/.workbuddy/skills（旧版）  全局准则需在界面里粘贴
#       all        以上全部
#       check      只检查各工具的安装情况（技能是否齐全、是否最新；全局准则是否存在、是否最新），不安装
#       zip        重新打包 claude.ai 用的 ZIP（dist/skill-zips 已有现成的，一般不需要）
#   --update     已安装的旧版本先备份，再换成新版本（默认跳过已安装的）
#   --no-rules   只装 Skills，不写全局准则文件
#   SKILLS_DIR=/任意/目录 bash scripts/install.sh claude   把 Skills 装到自定义目录（只对单个目标有意义）
#
# 全局准则文件的写入规则：文件不存在就创建；是本项目以前生成的就更新（需 --update）；
# 是你自己写的内容就不碰，只提示你手动合并。
#
# 只用 bash 3.2 自带功能，macOS 自带的 bash 即可运行，无需额外安装任何东西。
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGETS=""
UPDATE=0
RULES=1
for arg in "$@"; do
  case "$arg" in
    --update|-u) UPDATE=1 ;;
    --no-rules) RULES=0 ;;
    *) TARGETS="$TARGETS $arg" ;;
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
STAMP="$(date +%Y%m%d-%H%M%S)"
MANUAL_NOTES=""
note() { MANUAL_NOTES="$MANUAL_NOTES
  - $*"; }

if [ "$IS_WSL" = 1 ]; then
  say "提示：你在 WSL（Windows 里的 Linux 子系统）中运行。"
  say "      这里装的内容只对 WSL 里的程序生效。Windows 上的应用请改为双击 install-windows.bat。"
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
      (cd "$ROOT/skills" && zip -qr -X "$OUT/$name.zip" "$name" -x '*/.*')
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

# ---------- 安装 Skills 到某个目录 ----------
install_skills() {
  dest="$1"
  label="$2"
  mkdir -p "$dest"
  # 备份放在 skills 目录的旁边，而不是里面，避免旧版本被当成重复的 Skill 加载
  backup="$(dirname "$dest")/skills-backup/$STAMP"
  n=1
  while [ -e "$backup" ]; do n=$((n + 1)); backup="$(dirname "$dest")/skills-backup/$STAMP-$n"; done
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
  say "[$label] Skills → $dest"
  say "  新安装 $installed 个，更新 $updated 个，跳过 $skipped 个（已存在）"
  if [ "$updated" -gt 0 ]; then say "  旧版本已备份到：$backup"; fi
  if [ "$skipped" -gt 0 ]; then say "  想把已存在的换成新版本，请加 --update 重新运行（或在菜单里选更新）。"; fi
}

# ---------- 写入全局准则文件 ----------
# write_rules <源文件> <目标文件> <是否需要加标记 1/0>
write_rules() {
  src="$1"; dest="$2"; add_marker="$3"
  [ "$RULES" = 1 ] || return 0
  marker="$(cat "$ROOT/dist/MARKER.txt")"
  if [ -e "$dest" ] && ! grep -q "global-prompt-kit:" "$dest" 2>/dev/null; then
    say "  全局准则：$dest 已有你自己的内容，没有覆盖。"
    note "把 dist/$(basename "$src") 的内容手动合并进 $dest"
    return 0
  fi
  if [ -e "$dest" ] && [ "$UPDATE" != 1 ]; then
    say "  全局准则：$dest 已存在（本项目生成），跳过。加 --update 可更新。"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ]; then cp "$dest" "$dest.bak-$STAMP"; fi
  if [ "$add_marker" = 1 ]; then
    { printf '%s\n\n' "$marker"; cat "$src"; } > "$dest"
  else
    cp "$src" "$dest"
  fi
  if [ -e "$dest.bak-$STAMP" ]; then
    say "  全局准则 → $dest（已更新，旧版备份为 $(basename "$dest").bak-$STAMP）"
  else
    say "  全局准则 → $dest"
  fi
}

# ---------- 各目标 ----------
do_claude() {
  install_skills "${SKILLS_DIR:-$HOME/.claude/skills}" "Claude Code / Z Code / Cherry Studio Agent"
  write_rules "$ROOT/dist/claude.md" "$HOME/.claude/CLAUDE.md" 1
  if [ -d "$HOME/.zcode" ]; then
    write_rules "$ROOT/dist/coding-agents.md" "$HOME/.zcode/AGENTS.md" 1
  fi
  note "Cherry Studio 聊天助手不读这些文件：把 dist/ 里对应模型的版本粘贴到助手的提示词里"
}
do_agents() {
  install_skills "${SKILLS_DIR:-$HOME/.agents/skills}" "Kilo Code / GitHub Copilot / Kimi Code"
  write_rules "$ROOT/dist/coding-agents.md" "$HOME/.copilot/copilot-instructions.md" 1
  if [ -d "$HOME/.kimi-code" ]; then
    write_rules "$ROOT/dist/coding-agents.md" "$HOME/.kimi-code/AGENTS.md" 1
  fi
  note "Kilo Code 的全局准则需要手动设置，方法见 adapters/kilo-code.md"
}
do_cline() {
  install_skills "${SKILLS_DIR:-$HOME/.cline/skills}" "Cline"
  write_rules "$ROOT/dist/coding-agents.md" "$HOME/.cline/rules/global-prompt-kit.md" 1
}
do_kiro() {
  install_skills "${SKILLS_DIR:-$HOME/.kiro/skills}" "Kiro"
  write_rules "$ROOT/dist/kiro-steering.md" "$HOME/.kiro/steering/global-prompt-kit.md" 0
}
do_workbuddy() {
  if [ "$OS_NAME" = "Linux" ] && [ "$IS_WSL" = 0 ]; then
    say "注意：WorkBuddy 目前只有 Windows 和 macOS 版本，Linux 上装了也用不上。"
  fi
  # 新版 WorkBuddy AI（5.x 起）使用 ~/.workbuddy-ai/skills，旧版使用 ~/.workbuddy/skills
  wb_dir="$HOME/.workbuddy/skills"
  if [ -d "$HOME/.workbuddy-ai" ]; then wb_dir="$HOME/.workbuddy-ai/skills"; fi
  install_skills "${SKILLS_DIR:-$wb_dir}" "WorkBuddy"
  note "WorkBuddy：头像 → 设置 → 功能 → 个性化 → 自定义指令，粘贴 dist/lite-router.md；并在技能列表里确认本项目的技能都是「启用」状态"
}

# ---------- 检查安装情况 ----------
check_skills() {
  dir="$1"
  if [ ! -d "$dir" ]; then say "  技能：[未安装] 没有找到 $dir"; return 0; fi
  total=0; present=0; missing=""; differ=""
  for d in "$ROOT"/skills/*/; do
    src="${d%/}"; n="$(basename "$src")"; total=$((total + 1))
    if [ -f "$dir/$n/SKILL.md" ]; then
      present=$((present + 1))
      if ! diff -rq "$src" "$dir/$n" >/dev/null 2>&1; then differ="$differ $n"; fi
    else
      missing="$missing $n"
    fi
  done
  if [ "$present" = "$total" ] && [ -z "$differ" ]; then
    say "  技能：[正常] $present/$total 个，均为最新版（$dir）"
  else
    say "  技能：[需处理] 已安装 $present/$total 个（$dir）"
    if [ -n "$missing" ]; then say "    缺少：$missing"; fi
    if [ -n "$differ" ]; then say "    不是最新版：$differ（重新运行安装器，更新选 y）"; fi
  fi
}
check_rules() {
  file="$1"; src="$2"; add_marker="$3"
  if [ ! -f "$file" ]; then say "  全局准则：[未安装] 没有找到 $file"; return 0; fi
  if grep -q "global-prompt-kit:" "$file"; then
    same=0
    if [ "$add_marker" = 1 ]; then
      if { printf '%s\n\n' "$(cat "$ROOT/dist/MARKER.txt")"; cat "$src"; } | cmp -s - "$file"; then same=1; fi
    else
      if cmp -s "$src" "$file"; then same=1; fi
    fi
    if [ "$same" = 1 ]; then
      say "  全局准则：[正常] 最新版（$file）"
    else
      say "  全局准则：[需处理] 已安装但不是最新版（$file）。重新运行安装器，更新选 y"
    fi
  elif grep -q "全局工作准则" "$file"; then
    say "  全局准则：[正常] 已手动合并进 $file（无法自动判断是否最新，可对照 dist/$(basename "$src")）"
  else
    say "  全局准则：[需处理] $file 是你自己的内容，里面没有本项目的全局准则。请手动合并 dist/$(basename "$src")"
  fi
}
do_check() {
  wb_dir="$HOME/.workbuddy/skills"
  if [ -d "$HOME/.workbuddy-ai" ]; then wb_dir="$HOME/.workbuddy-ai/skills"; fi
  say ""
  say "======================================"
  say " 安装情况检查（对照本项目当前版本）"
  say "======================================"
  say "[1] Claude Code / Z Code / Cherry Studio Agent（共用技能文件夹）"
  check_skills "$HOME/.claude/skills"
  say "  Claude Code："
  check_rules "$HOME/.claude/CLAUDE.md" "$ROOT/dist/claude.md" 1
  if [ -d "$HOME/.zcode" ]; then
    say "  Z Code："
    check_rules "$HOME/.zcode/AGENTS.md" "$ROOT/dist/coding-agents.md" 1
  fi
  say "[2] Kilo Code / GitHub Copilot / Kimi Code（共用技能文件夹）"
  check_skills "$HOME/.agents/skills"
  say "  GitHub Copilot："
  check_rules "$HOME/.copilot/copilot-instructions.md" "$ROOT/dist/coding-agents.md" 1
  if [ -d "$HOME/.kimi-code" ]; then
    say "  Kimi Code："
    check_rules "$HOME/.kimi-code/AGENTS.md" "$ROOT/dist/coding-agents.md" 1
  fi
  say "  Kilo Code：全局准则需要在 Kilo Code 的配置里查看（见 adapters/kilo-code.md）"
  say "[3] Cline"
  check_skills "$HOME/.cline/skills"
  check_rules "$HOME/.cline/rules/global-prompt-kit.md" "$ROOT/dist/coding-agents.md" 1
  say "[4] Kiro"
  check_skills "$HOME/.kiro/skills"
  check_rules "$HOME/.kiro/steering/global-prompt-kit.md" "$ROOT/dist/kiro-steering.md" 0
  say "[5] WorkBuddy"
  check_skills "$wb_dir"
  say "  全局准则：需要在 WorkBuddy 里查看（头像 → 设置 → 功能 → 个性化 → 自定义指令）"
  say ""
  say "没用的工具显示[未安装]是正常的。"
  say "Claude 网页版/桌面聊天、Gemini、Kimi（网页版和桌面版）、Cherry Studio 聊天助手无法从电脑上检查，"
  say "验证方法见 docs/install.md 的「验证安装」一节。"
}

# ---------- 交互菜单 ----------
menu() {
  say "======================================"
  say " Global Prompt Kit - 安装"
  say " 当前系统：$OS_NAME"
  say "======================================"
  say "要装到哪些工具？可以多选，用空格分开，例如：1 3"
  say "  1) Claude Code、Z Code、Cherry Studio Agent"
  say "  2) Kilo Code（VS Code 插件）、GitHub Copilot、Kimi Code"
  say "  3) Cline（VS Code 插件）"
  say "  4) Kiro"
  say "  5) 腾讯 WorkBuddy"
  say "  6) 以上全部"
  say "  c) 只检查各工具的安装情况，不安装"
  say "  z) 重新打包 claude.ai 用的 ZIP（一般不需要，dist/skill-zips 里已有）"
  say "  q) 退出"
  say ""
  say "  Claude 网页版/桌面聊天、Gemini、Kimi（网页版和桌面版）不需要运行本脚本，见 docs/install.md。"
  printf '请输入编号后按回车：'
  read -r choice || choice=q
  choice="${choice//,/ }"
  choice="${choice//，/ }"
  for c in $choice; do
    case "$c" in
      1) TARGETS="$TARGETS claude" ;;
      2) TARGETS="$TARGETS agents" ;;
      3) TARGETS="$TARGETS cline" ;;
      4) TARGETS="$TARGETS kiro" ;;
      5) TARGETS="$TARGETS workbuddy" ;;
      6) TARGETS="$TARGETS all" ;;
      z|Z) TARGETS="$TARGETS zip" ;;
      c|C) TARGETS="$TARGETS check" ;;
      *) say "已退出。"; exit 0 ;;
    esac
  done
  if [ -z "$TARGETS" ]; then say "已退出。"; exit 0; fi
  case "$TARGETS" in *zip*|*check*) return 0 ;; esac
  printf '如果以前装过，要更新成新版本吗？旧版本会先备份。(y/N)：'
  read -r yn || yn=n
  case "$yn" in y|Y|yes|YES) UPDATE=1 ;; esac
  printf '同时安装全局准则吗？只会创建新文件或更新本项目生成的文件，不会覆盖你自己写的。(Y/n)：'
  read -r yn || yn=y
  case "$yn" in n|N|no|NO) RULES=0 ;; esac
}

TARGETS="$(printf '%s' "$TARGETS" | sed 's/^ *//')"
if [ -z "$TARGETS" ] || [ "$TARGETS" = "menu" ]; then TARGETS=""; menu; fi

for t in $TARGETS; do
  case "$t" in
    all) TARGETS="claude agents cline kiro workbuddy"; break ;;
    claude|agents|cline|kiro|workbuddy|zip|--zip|check) ;;
    *) say "未知选项：$t（可选 claude / agents / cline / kiro / workbuddy / all / check / zip，可加 --update、--no-rules）"; exit 1 ;;
  esac
done

for t in $TARGETS; do
  case "$t" in
    claude)    do_claude ;;
    agents)    do_agents ;;
    cline)     do_cline ;;
    kiro)      do_kiro ;;
    workbuddy) do_workbuddy ;;
    zip|--zip) make_zips ;;
    check)     do_check; exit 0 ;;
  esac
done

if [ -n "$MANUAL_NOTES" ]; then
  say ""
  say "还需要你手动做的："
  say "$MANUAL_NOTES" | sed '/^$/d'
fi
say ""
say "完成。重启对应的应用后生效。"
