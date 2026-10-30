#!/bin/bash
# macOS：双击运行，打开安装菜单。
# 如果提示"无法打开"或"无法验证开发者"：系统设置 → 隐私与安全性 → 仍要打开；
# 或者打开"终端"，输入 bash 加一个空格，把本文件拖进窗口后按回车。
cd "$(dirname "$0")" || exit 1
bash scripts/install.sh "$@"
echo
read -r -p "按回车键关闭窗口……" _
