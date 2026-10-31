# WorkBuddy（腾讯）适配

WorkBuddy 是腾讯的 AI 办公工作台，目前支持 **Windows 10（1909 起）/ 11 和 macOS 10.15 起**，没有 Linux 版。它用自然语言规划并执行文件、内容、数据、设计和编码任务，支持 Skills、连接器和 MCP。

## 全局准则：放在"自定义指令"
入口：**头像 → 设置 → 功能 → 个性化 → 自定义指令**。

粘贴 **`dist/lite-router.md`**。它是精简版全局准则，末尾加了一张"什么情况用哪个技能"的对照表，并明确要求模型主动调用技能。自定义指令通常有字数上限，所以用这个精简版。如果你的版本放得下，也可以改用 `dist/domestic.md` 完整版，但完整版没有技能对照表。

不要把全局准则放进 **设置 → 记忆**。记忆是模型从你的对话里自动提取的，内容会被它改写和合并，不适合放固定规则。

## Skills：会自动调用，但要满足条件
WorkBuddy 的技能**支持自动调用**：模型会根据任务内容和技能的 description，自己判断该用哪个技能。手动方式是在对话框里选中某个技能，或输入 `@技能名`。

如果你发现技能只能手动选、从不自动触发，按顺序检查：
1. **技能是否处于"启用"状态。** 在技能列表里，每个技能都有开关。关闭的技能仍会出现在"已安装"列表里，但**不参与自动调用**。这是最常见的原因。
2. **自定义指令里有没有放 `dist/lite-router.md`。** 它会明确告诉模型"遇到这些情况主动用对应技能"，能明显提高触发率。
3. **用的是哪个模型。** 模型选 Auto 时，简单任务可能被分到较小的模型，小模型更少主动调用技能。重要任务可以手动选更强的模型。
4. **说法是否接近技能的触发词。** 例如说"我在纠结要不要换工作"比"工作的事你怎么看"更容易触发 decision-lab。每个技能的触发词写在 `SKILL.md` 开头的 description 里。

## 安装 Skills
WorkBuddy 的技能也是 `SKILL.md` 格式，和本项目兼容。
- 用户级（所有项目可用）：
  - **新版 WorkBuddy AI（5.x 起）**：`~/.workbuddy-ai/skills/<名称>/SKILL.md`（Windows 为 `%USERPROFILE%\.workbuddy-ai\skills\`）。2026-10-31 在 5.9.4 上实测确认，从技能市场安装的技能也放在这里。
  - 旧版：`~/.workbuddy/skills/<名称>/SKILL.md`
  - 安装器会自动判断：检测到 `~/.workbuddy-ai` 文件夹就装到新位置。
- 项目级（只在当前项目）：`<工作区>/.workbuddy/skills/<名称>/SKILL.md`

安装：运行安装器，选 WorkBuddy（Windows 双击 `install-windows.bat`，macOS 双击 `install-macos.command`）。也可以在技能页面用 **上传技能** 导入本地技能包。

注意：WorkBuddy 网页端和客户端的个人技能库**互不相通**。安装器装的是客户端；如果你也用网页端，要在网页端单独上传。

复制进文件夹后要**完全退出 WorkBuddy 再打开**才会识别。如果仍然看不到，就用界面的"上传技能"导入。

## 模型
企业版文档列出的内置模型包括：Auto（自动选择）、混元 Hy3、GLM-5.2/5.1、GLM-5v-Turbo、MiniMax-M3、Kimi-K2.7-Code、Kimi-K2.6、DeepSeek-V4-Flash、DeepSeek-V4-Pro。也可以在 头像 → 设置 → 模型 中接入自定义 API 或本地 Ollama。

## 注意
WorkBuddy 会真正执行操作（读写文件、调用连接器）。全局准则第 1 节"不可逆操作先确认"和第 10 节"失败 3 次停下"在这里尤其重要。第三方技能安装前，先看它包含的脚本和权限。

参考：[WorkBuddy 手册：技能](https://neohoy.github.io/workbuddybook/advanced/01-skills.html)、[WorkBuddy 手册：记忆](https://neohoy.github.io/workbuddybook/advanced/09-memory.html)、[WorkBuddy 技能系统深度指南（腾讯云开发者社区）](https://cloud.tencent.com/developer/article/2693324)、[WorkBuddy 模型配置（腾讯云文档）](https://cloud.tencent.com/document/product/1831/134445)、[WorkBuddy Skill 入门（掘金）](https://juejin.cn/post/7655959397797019694)、[WorkBuddy 安装教程（系统要求）](https://gitcode.csdn.net/6aa0e3af1a35784c8420aad4.html)
