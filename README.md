# Global Prompt Kit

一套适用于 Claude、Gemini、GPT、Grok 和国内主流模型的**底层全局提示词 + 场景 Skills**。

- **全局准则**：每次对话都生效的底层规则，管住模型的通病：答得浅、乱认同、编来源、铺垫废话、一改就重写全文、Agent 无限重试。
- **13 个场景 Skill**：思考、决策、研究、学习、讲解、人生规划等需要固定流程的任务。缺信息时先引导你补充，再按优化过的流程执行。
- **一份 SKILL.md，多处通用**：Claude、Gemini、WorkBuddy、Cherry Studio Agent 都能直接读取同一份 SKILL.md；不支持的环境用自动生成的可粘贴模板。

## 快速开始

`dist/` 里已经是生成好的文件，**不需要运行任何脚本就能用**。Windows、macOS、Linux 都支持，完整步骤和常见问题见 **[docs/install.md](docs/install.md)**。

| 你用的是 | 全局准则放哪里 | Skills 怎么装 |
|---|---|---|
| **Claude 网页版 / 桌面版 / 手机 App** | 设置 → 个人偏好，粘贴 `dist/claude.md` | 在网页或桌面版：Customize → Skills → Upload，逐个上传 `dist/skill-zips/*.zip`；手机端自动可用 |
| **Gemini 网页版 / Mac 应用 / 手机 App** | 设置中的个人指令，粘贴 `core/global-prompt-lite.md` | 在网页或 Mac 应用：Customize → Skills → 导入 `skills/<名称>/SKILL.md`（不要传 ZIP）；手机端自动可用 |
| **腾讯 WorkBuddy**（Windows、macOS） | 规则/记忆设置，粘贴 `dist/domestic.md` | 双击安装器，菜单选 2 |
| **Cherry Studio** | 默认助手的提示词，按所选模型粘贴对应版本 | Agent 模式：双击安装器，菜单选 1；聊天助手：用 `dist/templates/` 建场景助手 |
| **Claude Code** | `~/.claude/CLAUDE.md`，内容用 `dist/claude.md` | 双击安装器，菜单选 1 |
| **国内模型官方 App**（DeepSeek、通义、Kimi、豆包、智谱等） | 有自定义指令就放 `core/global-prompt-lite.md`；没有就在对话开头粘贴 | 需要时粘贴 `dist/templates/<名称>.md` |

**安装器**：Windows 双击 `install-windows.bat`；macOS 双击 `install-macos.command`；Linux 在终端运行 `bash install-linux.sh`。

每个平台的版本选择、原理和已知限制见 `adapters/` 下对应文件。

### 按模型选版本
| 模型 | 文件 |
|---|---|
| Claude | `dist/claude.md` |
| Gemini | `dist/gemini.md` |
| GPT | `dist/openai.md` |
| Grok | `dist/grok.md` |
| DeepSeek、通义千问、Kimi、智谱 GLM、豆包、MiniMax、混元、本地模型 | `dist/domestic.md` |
| 任何有字数上限的输入框 | `core/global-prompt-lite.md` |

## 13 个 Skill

| Skill | 什么时候用 | 你可以这样说 |
|---|---|---|
| `oss-scout` | 想做一个东西，先找开源方案，判断用/改/自研，给 MVP | "我要做一个 XX，先别写代码，帮我找开源项目" |
| `deepen` | 觉得回答太浅 | "太浅了，按顶尖专家的标准重来" |
| `socratic-diagnosis` | 说不清卡在哪、思路乱、想找真正的问题 | "我也说不清哪里不对……" |
| `decision-lab` | 多个选项纠结；想用小实验验证 | "要不要辞职，帮我想清楚" |
| `perspective-lab` | 换视角、专家会诊、第一性原理、跨领域借鉴 | "从第一性原理重新想一遍" |
| `plan-stress-test` | 方案落地前挑刺、排查风险 | "别先认同我，帮我挑刺" |
| `fact-check` | 核查说法、数据、结论 | "这个说法靠谱吗" |
| `hv-research` | 深度研究产品、公司、人物、技术、行业 | "用横纵分析法研究一下 X" |
| `reverse-engineer` | 拆解优秀范例或人物思维，提炼规律 | "拆解一下这个页面为什么转化高" |
| `tutor` | 学概念、学技能、检验是否真懂、学习路径 | "考考我是不是真懂了 X" |
| `explain-levels` | 把复杂内容讲透：干净文字→图表→交互网页→视频 | "做个可交互的演示讲清楚这个" |
| `talent-discovery` | 挖掘被忽视的天赋 | "帮我找找我的天赋" |
| `life-design` | 人生方向规划，三个五年版本 | "我不知道未来几年该怎么走" |

## 目录结构

```
core/
  global-prompt.md        全局准则完整版（模型无关，唯一的规则源）
  global-prompt-lite.md   精简版，用于有字数上限的输入框
adapters/
  claude.md  gemini.md  openai.md  grok.md  domestic.md    按模型：包装方式和附加片段
  cherry-studio.md  workbuddy.md                           按客户端：放置位置和安装方法
skills/                   13 个 Skill（SKILL.md 格式）
install-windows.bat       Windows：双击安装 Skills
install-macos.command     macOS：双击安装 Skills
install-linux.sh          Linux：bash install-linux.sh
docs/
  install.md              三个系统的安装指南和常见问题
  third-party.md          10 个 GitHub 仓库的核查结果、推荐组合和安装命令
  usage-habits.md         你自己的使用习惯：省 Token 又出好结果
  source-map.md           每条原始提示词的去向和改动
scripts/
  build.py                生成 dist/（各模型版本 + 模板 + Claude 用的 ZIP）
  install.sh              macOS / Linux / Git Bash 安装脚本（上面的启动器会调用它）
  install.ps1             Windows PowerShell 安装脚本
dist/                     构建产物，不要手改
  claude.md gemini.md openai.md grok.md domestic.md   各模型的全局准则
  templates/              每个 Skill 的可粘贴模板
  skill-zips/             上传到 claude.ai 的 ZIP
```

## 维护规则
- **只改源文件**：规则改 `core/global-prompt.md`，模型专属内容改 `adapters/` 里的附加片段，流程改 `skills/`。改完运行构建脚本（macOS/Linux：`python3 scripts/build.py`；Windows：`py scripts\build.py`），会同时更新 `dist/` 下的所有文件。
- **上传到 GitHub**：推荐用 git 或 GitHub Desktop，网页拖拽会丢失脚本的执行权限。在 Windows 上提交的注意事项见 `docs/install.md` 末尾。
- **加新 Skill**：在 `skills/` 新建文件夹，文件夹名与 `name` 一致；在全局准则第 12 节的表格里登记。可以用官方的 `skill-creator` 帮你写和测试。
- **精简版**是手动维护的摘要，改了完整版的规则后记得同步。

## 致谢
场景流程改编自数字生命卡兹克等作者公开分享的提示词，以及 Andrej Karpathy 分享的输出方法；编码原则参考了 andrej-karpathy-skills 仓库。详见 `docs/source-map.md`。第三方仓库的版权归原作者所有，本项目只引用、不复制。
