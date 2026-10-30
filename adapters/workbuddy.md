# WorkBuddy（腾讯）适配

WorkBuddy 是腾讯的 AI 办公工作台，目前支持 **Windows 10（1909 起）/ 11 和 macOS 10.15 起**，没有 Linux 版。它用自然语言规划并执行文件、内容、数据、设计和编码任务，支持 Skills、连接器和 MCP。

## 模型
企业版文档列出的内置模型包括：Auto（自动选择）、混元 Hy3、GLM-5.2/5.1、GLM-5v-Turbo、MiniMax-M3、Kimi-K2.7-Code、Kimi-K2.6、DeepSeek-V4-Flash、DeepSeek-V4-Pro。也可以在 头像 → 设置 → 模型 中接入自定义 API 或本地 Ollama。

因此全局准则使用 **`dist/domestic.md`**。如果你接入了 Claude 或 Gemini，就换成对应版本。

来源：[WorkBuddy 模型配置（腾讯云文档）](https://cloud.tencent.com/document/product/1831/134445)

## 安装 Skills
WorkBuddy 的 Skill 也是 `SKILL.md` 格式，和本项目兼容。
- 用户级（所有项目可用）：macOS 为 `~/.workbuddy/skills/<名称>/SKILL.md`；Windows 为 `%USERPROFILE%\.workbuddy\skills\<名称>\SKILL.md`
- 项目级（只在当前项目）：`<工作区>/.workbuddy/skills/<名称>/SKILL.md`

安装：双击安装器，菜单选 2（Windows 双击 `install-windows.bat`，macOS 双击 `install-macos.command`）。也可以在 Claw 设置 → Skills 管理 中通过界面创建或导入。

WorkBuddy 的 SKILL.md 还支持可选的 `version` 和 `triggers`（触发关键词）字段。本项目没有加 `triggers`，靠 `description` 判断何时加载。如果你发现某个 Skill 不容易被触发，可以在它的 frontmatter 里加一行，例如：
```yaml
triggers: ["我在纠结", "帮我做决定", "A 还是 B"]
```

以上路径来自社区教程，官方文档未核实。Windows 上如果放在 `%USERPROFILE%\.workbuddy\skills\` 不生效，检查 `%APPDATA%\WorkBuddy\skills\`，或直接在 Skills 管理界面导入。

参考：[WorkBuddy Skill 入门（掘金）](https://juejin.cn/post/7655959397797019694)、[WorkBuddy Skills 创建与开发（CSDN）](https://gitcode.csdn.net/69e7284054b52172bc6b325f.html)、[awesome-workbuddy](https://github.com/semlinker/awesome-workbuddy)、[WorkBuddy 安装教程（系统要求）](https://gitcode.csdn.net/6aa0e3af1a35784c8420aad4.html)

## 放全局准则
在 WorkBuddy 的规则、记忆或自定义指令设置里粘贴 `dist/domestic.md`（字数受限时用精简版）。如果你的版本没有这类入口，在每个任务的第一条消息开头粘贴精简版。

## 注意
WorkBuddy 会真正执行操作（读写文件、调用连接器）。全局准则第 1 节"不可逆操作先确认"和第 10 节"失败 3 次停下"在这里尤其重要。第三方 Skill 安装前先看它包含的脚本和权限。
