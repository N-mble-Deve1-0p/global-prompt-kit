# Kilo Code 适配（VS Code 插件）

## Skills：支持，会自动调用
| 范围 | 位置 |
|---|---|
| 全局（所有项目可用） | `~/.kilo/skills/`，以及通用位置 `~/.agents/skills/`（默认读取） |
| 项目 | `.kilo/skills/` 或 `.agents/skills/` |

- **安装**：运行安装器，选 2。它装到 `~/.agents/skills/`，Kilo Code 默认会读取这个位置，GitHub Copilot 和 Kimi Code 也会读。
- **调用**：模型根据 description 自动判断；也可以直接说"用 decision-lab 技能"，或在 `/` 菜单的 Skills 分组里选择。
- **刷新**：Kilo Code 在会话开始时扫描技能，装完后新开会话，或输入 `/reload`。
- Kilo Code 也能读取 `~/.claude/skills/`，但需要在设置里打开 Claude Code 兼容模式。用默认的 `~/.agents/skills/` 就够了。

## 全局准则：需要手动设置
Kilo Code 的全局规则写在全局配置文件里，通常是 `~/.config/kilo/kilo.jsonc` 的 `instructions` 项，可以在里面引用规则文件。

推荐做法：
1. 把 `dist/coding-agents.md` 复制到一个固定位置，例如 `~/.kilo/global-prompt-kit.md`。
2. 在 `kilo.jsonc` 的 `instructions` 里加上这个文件的路径。

具体写法以你安装的 Kilo Code 版本的文档为准。安装器不会自动修改这个配置文件，因为它还存着你的其他设置，改错了会影响 Kilo Code 正常使用。

如果你的 Kilo Code 设置界面里有"自定义指令"（Custom Instructions）输入框，直接把 `dist/coding-agents.md` 粘贴进去也可以。

## 验证
1. 新开会话，在 `/` 菜单的 Skills 分组里确认本项目的技能都在。
2. 发"不用做任何事，用三句话概括你现在遵守的规则"。

来源：[Kilo Code Skills](https://kilo.ai/docs/customize/skills)、[Kilo Code Custom Rules](https://kilo.ai/docs/customize/custom-rules)
