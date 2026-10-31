# 第三方 Skill 仓库：核查结果与推荐用法

核查日期：2026-10-29。方法：逐个 `git clone` 仓库，查看 LICENSE 文件、最近 50 次提交的时间和作者、Skill 数量和 README 中的安装方式。星标数等指标未逐一核实。

**处理原则**：本项目不复制这些仓库的代码，只记录推荐用法和安装命令。这样既符合各自的许可证，也能随上游更新。

## 总览

| 仓库 | 是什么 | 许可证 | 最近提交 | 规模 | 推荐 |
|---|---|---|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | Anthropic 官方 Skill 合集与 SKILL.md 规范 | 多数 Apache-2.0；docx/pdf/pptx/xlsx 四个为专有许可（可用，不可再分发） | 2026-10-28 | 约 20 个 | ✅ 按需装 |
| [obra/superpowers](https://github.com/obra/superpowers) | 软件开发工作流：头脑风暴→写计划→TDD→代码审查→完成前验证 | MIT | 2026-10-21 | 15 个 | ✅ 开发主力（二选一） |
| [mattpocock/skills](https://github.com/mattpocock/skills) | 工程类 Skill：grill-me、tdd、diagnosing-bugs、to-spec、handoff 等 | MIT | 2026-10-27 | 38 个 | ✅ 开发主力（二选一） |
| [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | 一份减少 LLM 写代码常见错误的行为准则 | README 写 MIT，但仓库没有 LICENSE 文件 | 2026-04-20（半年无更新） | 1 个 | ⚪ 已吸收进全局准则，不必装 |
| [garrytan/gstack](https://github.com/garrytan/gstack) | "虚拟工程团队"：产品复盘、架构评审、设计、QA、安全审计、发布 | MIT | 2026-10-29 | 60+ 个 | 🟡 创业者写产品时再装 |
| [affaan-m/ECC](https://github.com/affaan-m/ECC) | 超大型 Claude Code 配置集合：技能、代理、钩子、规则、MCP 配置 | MIT | 2026-10-26 | 300+ 个技能目录 | 🟡 只挑需要的，别全装 |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | UI/UX 设计：设计系统、品牌、样式、横幅、HTML 幻灯片 | MIT | 2026-10-26 | 7 个 | 🟡 做前端界面时装 |
| [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | 让 Agent 说得更少、读得更少，以省 Token | Apache-2.0 | 2026-10-25 | 20+ 个 | 🟡 只在编码 Agent 里用 |
| [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | 把代码库和文档映射成可查询的知识图谱，代替反复 grep | Apache-2.0 | 2026-10-27 | CLI 工具 | 🟡 大型代码库时装 |
| [Yht20927/my-claude-memory](https://github.com/Yht20927/my-claude-memory) | 纯 Bash 的分层跨会话记忆系统 | README 写 MIT，但仓库没有 LICENSE 文件 | 2026-07-09 | 1 个 | ⚪ 可选，先审查 hooks |

## 逐个说明

### anthropics/skills（官方）
- 最有用的：`skill-creator`（创建、测试、优化 Skill，维护本项目时用）、`mcp-builder`、`webapp-testing`、`doc-coauthoring`、`frontend-design`。
- 注意：claude.ai 已经内置了其中不少能力（Office 文件、PDF 等），在 claude.ai 上一般不需要重复装。主要给 Claude Code 用户。
- 安装：`/plugin marketplace add anthropics/skills`，然后 `/plugin install document-skills@anthropic-agent-skills` 或 `example-skills@anthropic-agent-skills`。

### obra/superpowers 和 mattpocock/skills：开发工作流二选一
两者都覆盖"先想清楚再写代码、测试驱动、调试、代码审查"，同时装会互相抢触发、重复加载。
- **superpowers**：流程更完整、更"强制"。它的 `using-superpowers` 要求每次回复前都先查找 Skill，纪律性强，但 Token 开销也更大。适合想要严格流程的人。
- **mattpocock/skills**：更轻、更模块化，可以只挑几个用。其中 `grill-me`/`grilling`（拷问计划）和我们的 plan-stress-test 重叠，`teach` 和 tutor 重叠，`research` 和 hv-research 重叠；这些挑一个用即可。
- 安装 superpowers：`/plugin install superpowers@claude-plugins-official`（官方插件市场），也支持 Codex 和 Gemini CLI。
- 安装 mattpocock：`claude plugin install mattpocock-skills@claude-plugins-official`，或 `npx skills@latest add mattpocock/skills`（支持 Cursor、Codex 等多种 Agent）。

### andrej-karpathy-skills
内容是四条编码原则：先想再写、简单优先、外科手术式修改、以可验证目标驱动执行。这四条已经用我们自己的话写进全局准则第 6、7 节，所以不需要单独安装。仓库半年没有更新，也没有 LICENSE 文件。

### garrytan/gstack
功能强但很重：需要 Bun、会构建自带浏览器、会注册 hooks，单人维护（最近 50 次提交只有 1 位作者）且更新极快。
**安装前必看**：它的 README 安装指引会让 Claude 在 `CLAUDE.md` 里写入"所有网页浏览都用 gstack 的 /browse，不要用 Claude in Chrome"。如果你在用 Claude in Chrome 或其他浏览器工具，这条会改变你的默认行为。建议手动安装，自己决定 CLAUDE.md 写什么，不要让 Agent 照着 README 自动执行。
和 superpowers 在审查、发布环节重叠，不建议同时装。

### affaan-m/ECC
规模极大（300 多个技能目录，还有代理、钩子、规则）。全部开启会让每次请求都加载大量 Skill 描述，正好是 Token 浪费清单里的第 3 条。
建议：把它当"素材库"浏览，只复制或安装你确实需要的几个。它的指南文档（Token 优化、记忆持久化、验证循环）值得读。

### ui-ux-pro-max-skill
做网页和应用界面时有用。和官方 `frontend-design` 有重叠，二者选一为主。部分功能（如 Logo 生成）需要第三方图像 API 密钥。
安装：`/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill`，然后 `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill`。

### caveman
让 Agent 极度简洁地输出和读取，作者给出的基准显示可以显著减少 Token（数字为作者自报，未独立核实）。
**不要全局开启**：它和 tutor、explain-levels、talent-discovery、life-design 这类需要完整解释或温暖语气的流程冲突。只在编码 Agent 会话里用。我们的全局准则第 8 节已经包含"不铺垫、不重复"的温和版本。
安装：`claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman`。

### graphify
把项目代码（本地 tree-sitter 解析，不上传）和文档映射成知识图谱，Agent 查询图谱而不是逐文件读。适合大型代码库，对应 Token 清单第 9 条"不要把整个代码库丢进去"。README 中有商业云服务推广，本地 CLI 免费。
安装：`uv tool install graphifyy`（注意包名有两个 y）。

### my-claude-memory
个人项目（单一作者），用 Bash 实现分层记忆，通过 hooks 自动注入。Claude 本身已有记忆和 CLAUDE.md 机制，先确认是否真的需要。安装前读一遍它的 hooks 脚本，确认它会读写哪些文件。

## 推荐组合

| 你的情况 | 装什么 |
|---|---|
| 主要在 claude.ai 聊天、写东西、思考 | 只装本项目的 Skill |
| 用 Claude Code 写代码 | 本项目 Skill + superpowers 或 mattpocock（二选一）+ graphify（大项目时） |
| 做前端界面 | 再加 ui-ux-pro-max 或官方 frontend-design（二选一） |
| 创业者，从想法到上线全流程 | 本项目 Skill + gstack（手动安装，见上方提醒） |
| 对 Token 成本敏感的编码 Agent | 再加 caveman，只在该环境开启 |
