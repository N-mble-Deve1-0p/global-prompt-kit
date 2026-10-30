# Google Gemini（网页端 / Mac 应用 / 手机 App / API）适配

## 重要变化：Gems 正在被 Skills 取代
- Gemini App 推出了 **Skills**，取代 Gems。
- 个人账号的 Gems 在 2026-11-17 变为只读，2026-12-17 被移除，到时会自动转换成 Skills。
- Workspace 企业版、非营利版在 2027 年 3 月迁移，教育版在 2027 年 6 月迁移。
- **Gemini 的 Skills 可以直接导入 SKILL.md 文件**，也就是说，本项目的 13 个 Skill 在 Gemini 上可以原生使用，不需要改成 Gem。

来源：[About the transition from Gems to skills（Google 帮助中心）](https://support.google.com/gemini/answer/18560919?hl=en)、[Google 官方博客](https://blog.google/products-and-platforms/products/gemini/automate-tasks-with-skills/)

## 放在哪里
| 内容 | 位置 | 用哪个文件 |
|---|---|---|
| 全局准则 | 设置中的个人指令（Instructions for Gemini 或同类入口） | `core/global-prompt-lite.md`；输入框够长时用 `dist/gemini.md` |
| 13 个 Skill | Customize → Skills，导入 SKILL.md | `skills/<名称>/SKILL.md` |
| API | `system_instruction` | `dist/gemini.md` |

菜单名称会随版本变化，以当前界面为准。

## 导入 Skills 的步骤
1. 在 **Gemini 网页端或 Mac 应用**操作（目前只有这两处支持上传文件来创建 Skill）。Windows 和 Linux 用户在浏览器里打开网页版即可；手机 App 可以直接使用已创建的 Skill。
2. Customize → Skills → 导入，选择 `skills/` 下某个文件夹里的 `SKILL.md`。
3. 不要上传 ZIP：Gemini 的 Skill 文件不支持压缩包。`dist/skill-zips/` 是给 Claude 用的。
4. 如果需要连同附件一起上传，上传整个文件夹，文件夹名必须和 Skill 名一致（本项目已经满足）。

## 使用方式
- **自动触发**：直接描述你的情况，Gemini 判断相关时会自动套用对应 Skill。
- **手动触发**：输入 `/` 加 Skill 名，例如 `/decision-lab`（官方说之后会改成 `@`）。
- 可以同时叠加多个 Skill。最多同时启用 100 个，13 个完全够用。

## 已知限制
- Skills 不能和 Canvas、Deep Research、视频生成、音乐生成、Guided learning 一起使用。所以想用 Gemini 的 Deep Research 做研究时，hv-research 不会生效；可以先用 Deep Research 收集资料，再在普通对话里用 hv-research 整理成报告。
- 未满 18 岁的个人账号暂不支持。

## 为什么这样包装
Gemini 擅长处理很长的上下文，但在长文档场景里，放在材料前面的指令容易被稀释。Google 的提示词建议是：长上下文时，把具体问题和关键要求放在材料之后。所以附加片段要求模型在长材料场景下，以材料之后重申的要求为准。

## 附加片段（构建时自动追加）
```markdown
## 模型补充说明
- 当我提供很长的材料时，我会在材料之后重申关键要求；以材料之后的要求为准。
- 联网检索的结果要区分来源级别：官方和原始资料优先，聚合网站和论坛属于二手信息，需要标注。
- 场景工具箱里的流程对应已导入的同名 Skill。命中场景时直接使用，不需要先问我。
- 不要用大量加粗和多级标题包装简单回答。
```

## 长材料使用习惯
把材料放前面，问题和要求放最后，并在最后加一句"请按全局准则第 4 节的证据纪律回答"。
