# 安装指南：Windows / macOS / Linux

整个项目分两部分：
- **全局准则**：一段文字，粘贴到各应用的设置里。所有系统操作相同。
- **Skills**：`skills/` 下的每个文件夹是一个技能。有的应用在网页上上传，有的需要放进电脑上的指定文件夹。

先在下面的表格里找到你用的应用，只看对应的那一节。

## 你用的应用在哪些系统上可用

| 应用 | Windows | macOS | Linux | Skills 怎么装 |
|---|---|---|---|---|
| Claude 网页版 | ✅ | ✅ | ✅ | 网页上传 ZIP（见 A） |
| Claude 桌面版（聊天） | ✅ | ✅ | 测试版，仅 Ubuntu 22.04+ / Debian 12+ | 同网页版，上传后账号内通用（见 A） |
| Claude 手机 App | — | — | — | 在网页或桌面上传后自动可用 |
| Claude Code（命令行，或桌面版里的 Code） | ✅ | ✅ | ✅ | 放进本机文件夹（见 C） |
| Gemini 网页版 | ✅ | ✅ | ✅ | 网页导入 SKILL.md（见 B） |
| Gemini Mac 应用 | — | ✅ | — | 同网页版（见 B） |
| Gemini 手机 App | — | — | — | 在网页上导入后自动可用 |
| 腾讯 WorkBuddy | ✅ | ✅ | ❌ 无 Linux 版 | 放进本机文件夹（见 C），全局准则在界面里粘贴 |
| Cherry Studio | ✅ | ✅ | ✅ | Agent 模式放进本机文件夹（见 C）；聊天助手用模板（见 D） |
| GitHub Copilot（VS Code、JetBrains、Visual Studio、Copilot CLI） | ✅ | ✅ | ✅ | 放进本机文件夹（见 C） |
| Kiro | ✅ | ✅ | ✅ | 放进本机文件夹（见 C） |
| Kimi Code（命令行 / 编辑器插件） | ✅ | ✅ | ✅ | 放进本机文件夹（见 C） |
| Kimi 网页版 / App | ✅ | ✅ | ✅ | 网页里"文档转技能"（见 E） |
| 其他国内模型官方 App / 网页 | ✅ | ✅ | ✅ | 粘贴模板（见 D） |

---

## A. Claude（网页版、桌面版聊天、手机 App）
所有系统操作相同，不需要运行任何脚本。

1. **全局准则**：设置 → 个人偏好（Personal preferences），粘贴 `dist/claude.md` 的全部内容。
2. **开启功能**：设置 → Capabilities，打开代码执行与文件创建（Team/Enterprise 版由管理员开启）。
3. **上传 Skills**：Customize → Skills → "+" → Create skill → Upload a skill，逐个上传 `dist/skill-zips/` 里的 ZIP。
4. 手机 App 不用单独设置，同一个账号自动可用。

## B. Gemini（网页版、Mac 应用、手机 App）
所有系统操作相同，不需要运行任何脚本。Windows 和 Linux 用户在浏览器里打开 Gemini 网页版操作。

1. **全局准则**：设置里的个人指令，粘贴 `core/global-prompt-lite.md`（输入框够长时可用 `dist/gemini.md`）。
2. **导入 Skills**：Customize → Skills → 导入，逐个选择 `skills/<名称>/SKILL.md`。**不要传 ZIP**，Gemini 不支持压缩包。
3. 手机 App 不用单独设置。

## C. 需要放进电脑文件夹的应用
适用于 Claude Code、Cherry Studio 的 Agent 模式、GitHub Copilot、Kiro、Kimi Code、腾讯 WorkBuddy。

安装器会同时做两件事：
1. **装 Skills**：把所有技能复制到对应工具的文件夹。
2. **写全局准则**：在支持全局规则文件的工具里，自动创建规则文件（见下方"手动复制"表格的最后一列）。只会创建新文件，或更新本项目以前生成的文件；如果那个文件里是你自己写的内容，安装器不会动它，只会在最后提示你手动合并。

菜单里的选项：

| 编号 | 工具 | Skills 位置 |
|---|---|---|
| 1 | Claude Code、Cherry Studio Agent | `~/.claude/skills/` |
| 2 | GitHub Copilot（VS Code 等）、Kimi Code | `~/.agents/skills/`（两者都读这个通用位置） |
| 3 | Kiro | `~/.kiro/skills/` |
| 4 | 腾讯 WorkBuddy | `~/.workbuddy-ai/skills/`（新版 WorkBuddy AI）或 `~/.workbuddy/skills/`（旧版），自动判断 |

可以多选，例如输入 `1 2` 再回车。

### 方法一：双击运行（推荐）
| 系统 | 做法 |
|---|---|
| **Windows** | 双击项目根目录的 `install-windows.bat`，按菜单提示输入编号 |
| **macOS** | 双击 `install-macos.command`，按菜单提示输入编号 |
| **Linux** | 在项目目录打开终端，运行 `bash install-linux.sh` |

菜单里还会问你是否更新旧版本、是否安装全局准则。更新时，旧版本会先备份到 skills 目录旁边的 `skills-backup` 文件夹。

**macOS 提示"无法打开"或"无法验证开发者"**：这是因为文件来自网络。可以到 系统设置 → 隐私与安全性，在页面下方点"仍要打开"。也可以打开"终端"，输入 `bash ` （bash 后面有一个空格），把 `install-macos.command` 拖进终端窗口，再按回车。

**macOS 提示"没有权限"**：从 GitHub 网页直接下载 ZIP 时，偶尔会丢失文件的执行权限。用上面"终端 + 拖拽"的方法运行即可。

**Windows 提示"Windows 已保护你的电脑"**：点"更多信息"→"仍要运行"。

**Windows 用户在 WSL 里运行了 install.sh**：会装到 Linux 子系统里，Windows 上的应用看不到。请改为双击 `install-windows.bat`。

### 方法二：手动复制
把 `skills/` 下的所有文件夹（连同里面的子文件夹）复制到下面的位置。目标文件夹不存在就新建一个。

Windows 上把 `~` 换成 `%USERPROFILE%`，`/` 换成 `\`。

| 应用 | Skills 放到 | 全局准则放到 | 全局准则内容 |
|---|---|---|---|
| Claude Code、Cherry Studio Agent | `~/.claude/skills/` | `~/.claude/CLAUDE.md` | `dist/claude.md` |
| GitHub Copilot | `~/.agents/skills/` 或 `~/.copilot/skills/` | `~/.copilot/copilot-instructions.md` | `dist/coding-agents.md` |
| Kimi Code | `~/.agents/skills/` 或 `~/.kimi-code/skills/` | `~/.kimi-code/AGENTS.md` | `dist/coding-agents.md` |
| Kiro | `~/.kiro/skills/` | `~/.kiro/steering/global-prompt-kit.md` | `dist/kiro-steering.md` |
| WorkBuddy（仅 Windows、macOS） | `~/.workbuddy-ai/skills/`（新版）或 `~/.workbuddy/skills/`（旧版） | 界面：设置 → 功能 → 个性化 → 自定义指令 | `dist/lite-router.md` |

**怎么打开这些隐藏文件夹**：
- **Windows**：在文件资源管理器的地址栏粘贴 `%USERPROFILE%\.claude\skills`，按回车。
- **macOS**：在访达里按 `Cmd + Shift + G`，输入 `~/.claude/skills`，按回车。也可以按 `Cmd + Shift + .` 显示所有隐藏文件。
- **Linux**：在文件管理器里按 `Ctrl + H` 显示隐藏文件。

### 装完之后
- 重启对应的应用。
- 按安装器最后列出的"还需要你手动做的"逐条完成。WorkBuddy 和 Cherry Studio 聊天助手的全局准则只能在界面里粘贴。
- 每个工具的细节和已知限制见 `adapters/` 下对应文件：`workbuddy.md`、`github-copilot.md`、`kiro.md`、`kimi.md`、`cherry-studio.md`。
- **VS Code 用户注意**：VS Code 的"Local"会话模式同时读取 `~/.claude/skills/` 和 `~/.agents/skills/`。如果你选了 1 和 2，可能看到同名技能出现两次，删掉其中一处即可。

## D. 不支持 Skills 的地方
例如国内模型的官方 App，或 Cherry Studio 的聊天助手。

1. **全局准则**：有"自定义指令"就粘贴进去；没有就在对话开头粘贴 `core/global-prompt-lite.md`。
2. **场景流程**：需要时打开 `dist/templates/<名称>.md`，全文复制粘贴到对话开头，后面写你的情况。
3. Cherry Studio 可以把"全局准则 + 某个模板"保存成一个助手，以后直接选用。详见 `adapters/cherry-studio.md`。

## E. Kimi 网页版 / App
1. **Skills**：插件 → 技能 → 自定义 → **文档转技能**，逐个上传 `skills/<名称>/SKILL.md`。Kimi 会把它转换成自己的格式，保存前对照原文检查一遍，确认"铁律""保护规则"这类约束没有被删掉。
2. **全局准则**：如果你的版本有自定义指令类设置，粘贴 `dist/lite-router.md`；没有就在对话开头粘贴。

## 技能不会自动触发怎么办
所有支持 Skills 的工具都是根据技能的 description（`SKILL.md` 开头那段说明）判断什么时候用哪个技能。如果总要手动选，按顺序检查：
1. **技能是否启用**：WorkBuddy、Gemini 等的技能列表里有开关，关闭的技能不参与自动调用。
2. **全局准则里有没有技能对照表**：把 `dist/lite-router.md` 放进全局指令，它会明确要求模型主动使用技能。
3. **模型够不够强**：小模型、"自动"模式下分到的轻量模型，更少主动调用技能。
4. **说法是否接近触发词**：每个技能的 description 里写了典型说法，例如"我在纠结……"会触发 decision-lab。
5. **最后的办法**：手动调用。Claude、Copilot、Kiro、Gemini 输入 `/技能名`；Kimi Code 输入 `/skill:技能名`；WorkBuddy 输入 `@技能名`。

---

## 修改之后重新生成（维护者）
改了 `core/`、`adapters/` 或 `skills/` 之后，运行构建脚本更新 `dist/`。只需要 Python 3.8 或更高版本，不用安装其他依赖。

| 系统 | 命令 | 没有 Python 时 |
|---|---|---|
| Windows | `py scripts\build.py` | 从 python.org 或 Microsoft Store 安装 Python |
| macOS | `python3 scripts/build.py` | 首次运行会提示安装"命令行开发者工具"，点安装即可 |
| Linux | `python3 scripts/build.py` | 大多数发行版已自带；没有就用包管理器装 `python3` |

## 上传到 GitHub（维护者）
- **推荐用 git 命令或 GitHub Desktop 上传**。网页拖拽上传会丢失脚本的执行权限，macOS 和 Linux 用户下载后就不能双击运行。
- 项目自带 `.gitattributes`，会自动处理不同系统的换行符，避免脚本在 Windows 上 clone 后出错。
- **在 Windows 上提交时**，git 默认不会记录执行权限。第一次提交前运行一次下面的命令：
  ```
  git add .
  git update-index --chmod=+x install-macos.command install-linux.sh scripts/install.sh scripts/build.py
  git commit -m "Initial commit"
  ```
