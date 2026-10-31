# GitHub Copilot / VS Code 适配

VS Code 本身只是编辑器，AI 能力来自你用的插件。先确认你在 VS Code 里用的是哪个 AI：
- **GitHub Copilot**：需要登录 GitHub 账号并开通 Copilot。按本文件设置。
- **Cline**：见 `cline.md`。
- **Kilo Code**：见 `kilo-code.md`。
- **Claude Code、Kimi Code 插件**：见 `claude.md`、`kimi.md`。

如果你在 VS Code 里从没登录过 Copilot、平时用的是别的插件，就不用管本文件。

## Skills：完全支持，会自动调用
Copilot 支持标准的 SKILL.md 格式，和本项目一致。支持的地方包括：VS Code、Visual Studio、JetBrains 系列 IDE 的 Agent 模式，Copilot CLI，以及 GitHub 网站上的 Copilot 云端 Agent。

| 范围 | 位置 |
|---|---|
| 个人（所有项目可用） | `~/.copilot/skills/` 或 `~/.agents/skills/` |
| 项目（只在当前仓库） | `.github/skills/`、`.claude/skills/` 或 `.agents/skills/` |

Windows 上 `~` 指 `%USERPROFILE%`。

- **安装**：运行安装器，选"GitHub Copilot、Kimi Code"，会装到 `~/.agents/skills/`。这个位置 Kimi Code 也会读取，装一次两边都能用。
- **调用**：Copilot 会根据 description 自动加载；也可以在聊天框输入 `/` 手动选择。
- **注意**：VS Code 的"Local"会话模式还会读取 `~/.claude/skills/`。如果你同时选了 Claude Code 那一项，可能会看到同名技能出现两次，删掉其中一处即可。

## 全局准则：放在个人指令文件里
| 范围 | 位置 | 内容 |
|---|---|---|
| 个人（所有项目，始终生效） | `~/.copilot/copilot-instructions.md` | `dist/coding-agents.md` |
| 项目 | 仓库根目录的 `.github/copilot-instructions.md` 或 `AGENTS.md` | 项目自己的规则 |

安装器会自动创建 `~/.copilot/copilot-instructions.md`。如果这个文件已经存在、而且是你自己写的内容，安装器不会覆盖，会提示你手动把 `dist/coding-agents.md` 的内容粘贴进去。

也可以在 VS Code 里手动创建：命令面板（Ctrl/Cmd + Shift + P）→ **Chat: Open Customizations** → Instructions → 在 **User** 下点 New Instruction。

## 验证
在 Copilot Chat 里提问后，展开回答下方的 **References**，能看到加载了哪些指令和技能。加载出错时，运行 **Developer: Open Agent Debug Logs** 查看原因。

来源：[Use Agent Skills in VS Code](https://code.visualstudio.com/docs/agent-customization/agent-skills)、[Use custom instructions in VS Code](https://code.visualstudio.com/docs/agent-customization/custom-instructions)、[About agent skills（GitHub Docs）](https://docs.github.com/en/copilot/concepts/customizations/agent-skills)
