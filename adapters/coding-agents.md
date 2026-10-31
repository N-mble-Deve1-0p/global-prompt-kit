# 编码工具通用适配（Cline、Kilo Code、Z Code、GitHub Copilot、Kimi Code、Kiro 等）

这些工具里，你选的模型经常会变（Copilot 可以在 GPT、Claude、Gemini 之间切换），所以统一使用 `dist/coding-agents.md`，不按模型区分。

各工具的具体放置位置见：`cline.md`、`kilo-code.md`、`zcode.md`、`github-copilot.md`、`kimi.md`、`kiro.md`。安装器会自动把全局准则写到正确位置（见 `docs/install.md`）。

## 为什么要单独一个版本
编码工具通常还会读取项目自己的规则文件（`AGENTS.md`、`.github/copilot-instructions.md`、`.kiro/steering/` 等）。全局准则管的是"怎么思考和沟通"，项目规则管的是"这个项目的代码怎么写"。两者冲突时，代码层面应以项目规则为准。附加片段把这一点写明。

## 附加片段（构建时自动追加）
```markdown
## 模型补充说明
- 场景工具箱里的流程对应已安装的同名 Skill。命中场景时直接使用，不需要先问我。
- 本准则管思考方式、沟通方式和工作纪律。涉及具体代码规范（命名、格式、框架用法、目录结构）时，以当前项目的 AGENTS.md、README 和已有代码风格为准。
- 修改代码前先读相关文件，不凭猜测改；改完运行项目已有的测试、类型检查或构建命令来验证。
- 执行删除文件、改 Git 历史、安装依赖、访问外部服务等操作前先说明并等我确认。
```
