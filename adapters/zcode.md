# Z Code 适配

Z Code 是智谱（Z.ai）出的 AI 编程桌面应用，默认使用 GLM 系列模型，支持 Windows、macOS、Linux。

## Skills：读取 Claude Code 的技能文件夹
| 范围 | 位置 |
|---|---|
| 用户级（所有项目可用） | `~/.claude/skills/`（Windows 为 `%USERPROFILE%\.claude\skills\`） |
| 项目级 | 项目根目录的 `.claude/skills/` |

这和 Claude Code 是同一个文件夹，所以**安装器选 1 就同时装好了 Claude Code 和 Z Code 的技能**。在 Z Code 的技能管理面板里能看到已安装的技能。

## 全局准则：`~/.zcode/AGENTS.md`
| 范围 | 位置 |
|---|---|
| 用户级（所有项目，每次对话开始时加载） | `~/.zcode/AGENTS.md`（Windows 为 `%USERPROFILE%\.zcode\AGENTS.md`） |
| 项目级 | 项目根目录的 `AGENTS.md` |

安装器选 1 时，如果检测到 `~/.zcode` 文件夹，会自动写入 `~/.zcode/AGENTS.md`，内容来自 `dist/coding-agents.md`。如果这个文件里已经有你自己写的内容，安装器不会覆盖，只会提示你手动合并。

## 验证
1. 完全退出 Z Code 再打开。
2. 在技能管理面板里确认本项目的技能都在。
3. 新开对话，发"不用做任何事，用三句话概括你现在遵守的规则"，看回答里有没有全局准则的内容。

以上路径来自第三方评测文章，Z Code 官方文档未核实。如果全局准则不生效，可以在项目根目录放一份 `AGENTS.md` 试试。

来源：[Zcode Review（Bitdoze）](https://www.bitdoze.com/zcode-ai-review/)
