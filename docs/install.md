# 安装指南：Windows / macOS / Linux

整个项目分两部分：
- **全局准则**：一段文字，粘贴到各应用的设置里。所有系统操作相同。
- **Skills**：13 个文件夹。有的应用在网页上上传，有的需要放进电脑上的指定文件夹。

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
| 腾讯 WorkBuddy | ✅ | ✅ | ❌ 无 Linux 版 | 放进本机文件夹（见 C） |
| Cherry Studio | ✅ | ✅ | ✅ | Agent 模式放进本机文件夹（见 C）；聊天助手用模板（见 D） |
| 国内模型官方 App / 网页 | ✅ | ✅ | ✅ | 粘贴模板（见 D） |

---

## A. Claude（网页版、桌面版聊天、手机 App）
所有系统操作相同，不需要运行任何脚本。

1. **全局准则**：设置 → 个人偏好（Personal preferences），粘贴 `dist/claude.md` 的全部内容。
2. **开启功能**：设置 → Capabilities，打开代码执行与文件创建（Team/Enterprise 版由管理员开启）。
3. **上传 Skills**：Customize → Skills → "+" → Create skill → Upload a skill，逐个上传 `dist/skill-zips/` 里的 13 个 ZIP。
4. 手机 App 不用单独设置，同一个账号自动可用。

## B. Gemini（网页版、Mac 应用、手机 App）
所有系统操作相同，不需要运行任何脚本。Windows 和 Linux 用户在浏览器里打开 Gemini 网页版操作。

1. **全局准则**：设置里的个人指令，粘贴 `core/global-prompt-lite.md`（输入框够长时可用 `dist/gemini.md`）。
2. **导入 Skills**：Customize → Skills → 导入，逐个选择 `skills/<名称>/SKILL.md`。**不要传 ZIP**，Gemini 不支持压缩包。
3. 手机 App 不用单独设置。

## C. 需要放进电脑文件夹的应用
适用于 Claude Code、Cherry Studio 的 Agent 模式、腾讯 WorkBuddy。

### 方法一：双击运行（推荐）
| 系统 | 做法 |
|---|---|
| **Windows** | 双击项目根目录的 `install-windows.bat`，按菜单提示输入编号 |
| **macOS** | 双击 `install-macos.command`，按菜单提示输入编号 |
| **Linux** | 在项目目录打开终端，运行 `bash install-linux.sh` |

菜单里可以选择装到哪里，以及是否更新旧版本。更新时，旧版本会先备份到 skills 目录旁边的 `skills-backup` 文件夹。

**macOS 提示"无法打开"或"无法验证开发者"**：这是因为文件来自网络。可以到 系统设置 → 隐私与安全性，在页面下方点"仍要打开"。也可以打开"终端"，输入 `bash ` （bash 后面有一个空格），把 `install-macos.command` 拖进终端窗口，再按回车。

**macOS 提示"没有权限"**：从 GitHub 网页直接下载 ZIP 时，偶尔会丢失文件的执行权限。用上面"终端 + 拖拽"的方法运行即可。

**Windows 提示"Windows 已保护你的电脑"**：点"更多信息"→"仍要运行"。

**Windows 用户在 WSL 里运行了 install.sh**：会装到 Linux 子系统里，Windows 上的应用看不到。请改为双击 `install-windows.bat`。

### 方法二：手动复制
把 `skills/` 下的 13 个文件夹复制到下面的位置。目标文件夹不存在就新建一个。

| 应用 | Windows | macOS / Linux |
|---|---|---|
| Claude Code、Cherry Studio Agent | `%USERPROFILE%\.claude\skills\` | `~/.claude/skills/` |
| WorkBuddy | `%USERPROFILE%\.workbuddy\skills\` | `~/.workbuddy/skills/`（仅 macOS） |

**怎么打开这些隐藏文件夹**：
- **Windows**：在文件资源管理器的地址栏粘贴 `%USERPROFILE%\.claude\skills`，按回车。
- **macOS**：在访达里按 `Cmd + Shift + G`，输入 `~/.claude/skills`，按回车。也可以按 `Cmd + Shift + .` 显示所有隐藏文件。
- **Linux**：在文件管理器里按 `Ctrl + H` 显示隐藏文件。

### 装完之后
- 重启对应的应用。
- **全局准则**也要放：Claude Code 放进 `~/.claude/CLAUDE.md`（Windows 为 `%USERPROFILE%\.claude\CLAUDE.md`），内容用 `dist/claude.md`；Cherry Studio 和 WorkBuddy 见 `adapters/` 下的对应文件。
- WorkBuddy 的路径来自社区教程。如果装完看不到这些 Skill，就在它的 Skills 管理界面导入；Windows 上也可以试试 `%APPDATA%\WorkBuddy\skills\`。

## D. 不支持 Skills 的地方
例如国内模型的官方 App，或 Cherry Studio 的聊天助手。

1. **全局准则**：有"自定义指令"就粘贴进去；没有就在对话开头粘贴 `core/global-prompt-lite.md`。
2. **场景流程**：需要时打开 `dist/templates/<名称>.md`，全文复制粘贴到对话开头，后面写你的情况。
3. Cherry Studio 可以把"全局准则 + 某个模板"保存成一个助手，以后直接选用。详见 `adapters/cherry-studio.md`。

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
