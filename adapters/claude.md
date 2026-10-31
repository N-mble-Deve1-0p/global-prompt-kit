# Claude 适配

## 支持的系统
- 网页版：所有系统。
- 桌面版：Windows、macOS；Linux 为测试版，仅支持 Ubuntu 22.04+ 和 Debian 12+。其他 Linux 发行版用网页版或 Claude Code 命令行。
- Skills 属于账号，在任一处上传后，网页版、桌面版、手机 App 都能用。

来源：[Claude Desktop on Linux (beta)](https://code.claude.com/docs/en/desktop-linux)

## 放在哪里
| 场景 | 位置 | 用哪个版本 |
|---|---|---|
| claude.ai / 桌面端 / 手机端 | 设置里的个人偏好（Personal preferences），或某个 Project 的项目指令 | `dist/claude.md` |
| Claude Code | `~/.claude/CLAUDE.md`（全局）或项目根目录的 `CLAUDE.md` | `dist/claude.md` |
| API | `system` 参数 | `dist/claude.md` |

菜单名称会随版本变化，以当前界面为准。

## 为什么这样包装
Claude 对 XML 标签分隔的结构响应很好，所以构建脚本会把核心准则包进 `<global_rules>` 标签，并追加下面的附加片段。

## 附加片段（构建时自动追加）
```xml
<claude_notes>
- 本准则中的"场景工具箱"对应已安装的 Skills。命中场景时直接使用对应 Skill，不需要先询问我是否使用。
- 需要深度推理的任务，先想清楚再回答；但最终回答只给结论和必要的理由，不展示冗长的推理过程。
- 规则后面写了原因的，按原因的精神执行，不要机械套用字面。
</claude_notes>
```

## 安装 Skills
**网页端 / 桌面应用**：Customize → Skills → "+" → Create skill → Upload a skill，逐个上传 `dist/skill-zips/` 里已经打包好的 ZIP（文件夹名与 Skill 名一致，里面包含 `SKILL.md`）。需要先在设置 → Capabilities 里开启代码执行与文件创建；Team/Enterprise 由管理员开启。

**手机 App**：在网页端或桌面端上传后，Skill 属于账号，手机上也能用。建议不要在手机上做上传操作。

**Claude Code**：双击安装器，菜单选 1（Windows 双击 `install-windows.bat`，macOS 双击 `install-macos.command`，Linux 运行 `bash install-linux.sh`）。会复制到 `~/.claude/skills/`，Windows 为 `%USERPROFILE%\.claude\skills\`。用同一账号登录时，claude.ai 上启用的 Skills 也会单向同步到 Claude Code。

来源：[Use skills in Claude（Claude 帮助中心）](https://support.claude.com/en/articles/12512180-use-skills-in-claude)

## 省 Token 的提醒
Skill 平时只加载名称和描述，命中时才加载全文，所以本项目的 Skill 常驻的开销不大。但第三方 Skill 包（尤其是 ECC、gstack 这类上百个 Skill 的集合）不要全部开启，按需安装。详见 `docs/third-party.md`。
