# Cherry Studio 适配

支持系统：Windows、macOS、Linux。

Cherry Studio 是一个可以接入多家模型（Claude、Gemini、GPT、DeepSeek、通义、Kimi、智谱、本地 Ollama 等）的桌面客户端。它有两种用法，全局准则和 Skills 的放法不同。

## 先选对版本
Cherry Studio 本身不决定提示词怎么写，**你选的模型决定**：
| 你在 Cherry Studio 里用的模型 | 全局准则用哪个文件 |
|---|---|
| Claude 系列 | `dist/claude.md` |
| Gemini 系列 | `dist/gemini.md` |
| GPT 系列 | `dist/openai.md` |
| Grok 系列 | `dist/grok.md` |
| DeepSeek、通义千问、Kimi、智谱 GLM、豆包、MiniMax、混元、本地模型 | `dist/domestic.md` |

## 用法一：聊天"助手"
助手就是"一段系统提示词 + 一个模型"。

1. **全局准则**：编辑默认助手（新建对话时默认使用的助手），把对应版本的全局准则粘贴到它的提示词里。之后新建的对话都会带上。
2. **场景流程**：为常用的流程各建一个助手。提示词 = 全局准则 + 对应的 `dist/templates/<名称>.md`。建议只建你常用的 3–5 个，比如：
   - "问诊助手" = 全局准则 + socratic-diagnosis 模板
   - "决策助手" = 全局准则 + decision-lab 模板
   - "导师" = 全局准则 + tutor 模板
3. 需要联网核查的流程（fact-check、hv-research、oss-scout），在对话里打开联网搜索。

## 用法二：Agent 模式
Cherry Studio 2.x 提供 Agent 模式，并在设置里有 Skills 管理页面。根据 Cherry Studio 仓库自带的 skills-manager 说明，Agent 的 Skills 安装在用户级 `~/.claude/skills/` 或项目级 `.claude/skills/`，格式就是 SKILL.md，和本项目一致。

安装方法（任选一种）：
- 双击安装器，菜单选 1：Windows 双击 `install-windows.bat`，macOS 双击 `install-macos.command`，Linux 运行 `bash install-linux.sh`。会复制到 `~/.claude/skills/`（Windows 为 `%USERPROFILE%\.claude\skills\`）。
- 在 Cherry Studio 的 Skills 设置页面导入。

安装后到 Skills 设置页面确认本项目的技能都已列出并启用。Agent 的系统提示词或指令里同样放入对应版本的全局准则。

以上路径来自 Cherry Studio 仓库中的说明，不同版本可能调整，以你安装的版本的界面为准。

参考：[Cherry Studio skills-manager 说明（tessl 镜像）](https://tessl.io/registry/skills/github/CherryHQ/cherry-studio/skills-manager)、[Cherry Studio v2.0.13 更新记录](https://newreleases.io/project/github/CherryHQ/cherry-studio/release/v2.0.13)

## 省 Token 的提醒
助手的提示词每轮都会发送。如果你用的是按量计费的 API，场景助手可以只放精简版全局准则（`core/global-prompt-lite.md`）+ 模板。
