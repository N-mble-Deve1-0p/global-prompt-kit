# Kiro 适配

Kiro 是 AWS 推出的 AI 编程 IDE，也有命令行版本。

## Skills：完全支持，会自动调用
Kiro 支持标准的 SKILL.md 格式，和本项目一致。

| 范围 | 位置 |
|---|---|
| 全局（所有项目可用） | `~/.kiro/skills/`（Windows 为 `%USERPROFILE%\.kiro\skills\`） |
| 项目 | 项目根目录的 `.kiro/skills/` |

- **安装**：运行安装器，选 Kiro。也可以在 Kiro 面板的 **Agent Steering & Skills** 里点 **+** → **Import a skill**，选择本项目 `skills/` 下的某个文件夹。
- **调用**：Kiro 会根据 description 自动加载；也可以输入 `/` 加技能名手动调用。
- **注意**：全局技能在 Kiro 的网页版和手机版里不可用，只在 IDE 和命令行里生效。如果你用了自定义 Agent，它默认不加载技能，需要在 Agent 的 `resources` 里加上 `skill://` 路径。

## 全局准则：放进全局 Steering
Kiro 把"始终生效的规则"叫 Steering。全局 Steering 放在 `~/.kiro/steering/`，对所有项目生效。

安装器会创建 `~/.kiro/steering/global-prompt-kit.md`。文件开头带有 `inclusion: always`，表示每次对话都加载。内容来自 `dist/kiro-steering.md`。

手动放置也可以：把 `dist/kiro-steering.md` 复制到 `~/.kiro/steering/` 下即可。

来源：[Kiro Agent Skills](https://kiro.dev/docs/skills/)、[Kiro Steering](https://kiro.dev/docs/steering/)
