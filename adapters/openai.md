# OpenAI（ChatGPT / GPTs / API / Codex）适配

## 放在哪里
| 场景 | 位置 | 用哪个版本 |
|---|---|---|
| ChatGPT 自定义指令 | 设置 → 个性化 → 自定义指令 | `core/global-prompt-lite.md`（输入框有字数上限） |
| ChatGPT Projects | 项目指令 | `dist/openai.md` |
| 自建 GPT | Instructions 放 `dist/openai.md`；Knowledge 上传 `dist/templates/` 下需要的模板文件 | 见下方"GPT 打包法" |
| API | system / developer 消息 | `dist/openai.md` |
| Codex 等编码 Agent | `AGENTS.md` | `dist/openai.md`；部分第三方 Skill 仓库也提供 Codex 插件（见 `docs/third-party.md`） |

菜单名称和字数上限会随版本变化，以当前界面为准。超出上限时用精简版。

## 为什么这样包装
GPT 系列对 Markdown 分节结构跟随得很好，而且执行指令很"字面"，规则互相矛盾时容易左右摇摆。所以构建脚本保持 Markdown 结构，并追加一段明确的输出长度和执行力度说明。

## 附加片段（构建时自动追加）
```markdown
## 模型补充说明
- 输出长度：默认中等。简单问题 1–3 句；分析类问题先给结论，再展开最关键的 2–3 点。用户要求详细时再展开。
- 执行力度：信息足够时直接完成任务，不反复确认；只有第 1 节列出的高成本或不可逆操作才先停下确认。
- 场景工具箱里的流程，在本环境中对应知识库里的同名模板文件。命中场景时，读取对应模板并按模板执行。
- 不要为了显得周全而在结尾附加"如果你需要，我还可以……"的长清单。最多提一个真正有用的下一步。
```

## GPT 打包法
1. Instructions：粘贴 `dist/openai.md`。
2. Knowledge：上传你最常用的几个模板（`dist/templates/*.md`）。不需要全部上传，按用途建多个 GPT 更省也更稳，比如"思考教练 GPT"只放 socratic-diagnosis、decision-lab、perspective-lab、plan-stress-test。
3. 测试：用每个模板的典型触发句试一次，确认它会读取模板而不是自由发挥。
