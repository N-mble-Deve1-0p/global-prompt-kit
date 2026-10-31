# Kimi 适配

Kimi 有两个完全不同的产品，放法不一样：
- **Kimi 网页版 / App**：聊天助手。
- **Kimi Code**：编程用的命令行工具，也有编辑器插件。

## Kimi 网页版 / App

### Skills：可以导入，会自动调用，但要逐个转换
Kimi 的技能入口在 **插件 → 技能 → 自定义**。官方说明里，相关技能会被自动加载。

导入方法：选 **文档转技能**，上传本项目 `skills/<名称>/SKILL.md`。Kimi 会把文档转换成它自己的技能格式，你可以检查后再保存。

转换是 Kimi 自动完成的，内容可能被改写。保存前对照原文看一遍，重点检查"铁律""保护规则"这类约束有没有被删掉。

### 全局准则
目前没有找到 Kimi 网页版"自定义指令"类设置的官方说明。如果你的版本有这类入口，就粘贴 `dist/lite-router.md`；没有的话，在新对话开头粘贴它。

来源：[Kimi：创建技能](https://www.kimi.com/resources/create-skills)

## Kimi Code（命令行 / 编辑器插件）

### Skills：完全支持，会自动调用
| 范围 | 位置 |
|---|---|
| 个人（所有项目可用） | `~/.kimi-code/skills/` 或 `~/.agents/skills/` |
| 项目 | `.kimi-code/skills/` 或 `.agents/skills/` |

- **安装**：运行安装器，选"GitHub Copilot、Kimi Code"，会装到 `~/.agents/skills/`。这个位置 GitHub Copilot 也会读取。
- **调用**：Kimi Code 会根据 description 自动调用；也可以输入 `/skill:名称` 手动调用，例如 `/skill:decision-lab`。
- 旧版 Kimi CLI 使用 `~/.kimi/skills/`，并且会读取 `~/.claude/skills/`。如果你用的是旧版，选 Claude Code 那一项也能用。

### 全局准则
放在 `~/.kimi-code/AGENTS.md`（只给 Kimi 用）或 `~/.agents/AGENTS.md`（多个工具共用），内容用 `dist/coding-agents.md`。

如果检测到 `~/.kimi-code` 文件夹，安装器会自动写入 `~/.kimi-code/AGENTS.md`。这个路径来自第三方资料，Kimi 官方文档里没有找到。如果没生效，可以在项目根目录放一份 `AGENTS.md` 试试，或者在对话开头粘贴 `dist/lite-router.md`。

来源：[Kimi Code：Agent Skills](https://moonshotai.github.io/kimi-code/zh/customization/skills)、[Kimi Code CLI 读取 AGENTS.md 的位置（第三方）](https://www.ultracite.ai/agents/kimi-code)
