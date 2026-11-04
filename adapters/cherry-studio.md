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

## 用法二：Agent 模式和技能页面
Cherry Studio 最新版的技能页面显示的是自己的技能库，不会把外部复制到 `~/.claude/skills/` 的文件自动收录进去。这个目录不能作为 Cherry Studio 的安装入口；项目安装器的 `claude` 目标只服务 Claude Code 和 Z Code。

推荐按下面的顺序安装：

1. 打开 **设置 → 技能 → 从本地 ZIP 文件安装**，逐个导入 `dist/skill-zips/` 下的 ZIP。也可以使用“从文件夹安装”，选择 `skills/<技能名>/`。
2. 在技能页面确认每个技能卡片的开关已打开。
3. 打开 **工作 → Agent → 编辑 → 技能**，把需要的技能绑定到该 Agent。
4. 按上方模型表，把对应的 `dist/*.md` 全文粘贴到 Agent 的**系统提示词**；保存后新发一条消息才会生效。

安装器也提供专用提示：Windows 运行 `install-windows.bat` 选 **6**，macOS/Linux 运行安装器选 **6**，或直接运行 `bash scripts/install.sh cherry`。它不会复制文件，只会显示上述界面操作，避免误以为 `~/.claude/skills/` 已安装成功。

聊天助手不需要绑定 Agent：编辑默认助手的提示词，粘贴对应模型的 `dist/*.md`；场景助手可再追加 `dist/templates/<名称>.md`。Cherry Studio 的菜单名称可能随版本变化，以当前界面为准。

## 省 Token 的提醒
助手的提示词每轮都会发送。如果你用的是按量计费的 API，场景助手可以只放精简版全局准则（`core/global-prompt-lite.md`）+ 模板。
