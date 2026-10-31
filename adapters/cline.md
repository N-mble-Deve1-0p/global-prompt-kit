# Cline 适配（VS Code 插件）

VS Code 本身只是编辑器，里面的 AI 能力来自你装的插件。用 Cline 的话，按本文件设置。

## Skills：支持，默认启用，会自动调用
| 范围 | 位置 |
|---|---|
| 全局（所有项目可用） | `~/.cline/skills/`（Windows 为 `%USERPROFILE%\.cline\skills\`） |
| 项目 | `.cline/skills/`、`.clinerules/skills/` 或 `.claude/skills/` |

- **安装**：运行安装器，选 3（Cline）。
- **调用**：请求和技能的 description 匹配时，Cline 会自动调用；也可以在聊天框输入 `/` 手动选择。
- **开关**：每个技能在 Cline 的 Skills 菜单里有单独的开关，发现后默认是打开的。

## 全局准则：放在全局规则文件夹
| 范围 | 位置 |
|---|---|
| 全局 | `~/.cline/rules/`（兼容旧位置 `~/Documents/Cline/Rules/`） |
| 项目 | 项目根目录的 `.clinerules/` 或 `AGENTS.md` |

安装器会创建 `~/.cline/rules/global-prompt-kit.md`，内容来自 `dist/coding-agents.md`。

Cline 还会读取 `~/.agents/AGENTS.md`。本项目没有往这个位置写内容，避免和上面的规则文件重复加载。

## 关于 Cline 中文版
你的 VS Code 里如果装的是社区汉化版（例如 "Cline Chinese"），它是基于 Cline 改的，大概率使用同样的文件夹，但没有核实。装完后在它的 Skills 菜单里确认能看到这些技能；看不到的话，告诉我它界面里显示的技能路径。

## 验证
1. 重新加载 VS Code 窗口（命令面板 → Developer: Reload Window）。
2. 在 Cline 的 Skills 菜单里确认本项目的技能都在，开关是打开的。
3. 新开任务，发"不用做任何事，用三句话概括你现在遵守的规则"。

来源：[Cline Skills](https://docs.cline.bot/customization/skills)、[Cline Customization Overview](https://docs.cline.bot/customization/overview)
