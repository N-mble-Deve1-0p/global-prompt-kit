#!/usr/bin/env bash
# Linux：在终端里运行 bash install-linux.sh，打开安装菜单。
cd "$(dirname "$0")" || exit 1
exec bash scripts/install.sh "$@"
