---
name: deeptutor-cli
description: 用户要安装、配置、使用或排查 DeepTutor 学习平台，或操作其 CLI、学习能力、知识库、Partners、学习记忆、会话、笔记本和 Web 服务时使用。仅学习某个学科或技能时使用 tutor；要管理 DeepTutor 平台本身时使用本技能。
---

# DeepTutor CLI：安装、操作与排查

本技能依据 [DeepTutor 官方 CLI Skill](https://github.com/HKUDS/DeepTutor/blob/main/SKILL.md)、[Agent Setup 指南](https://github.com/HKUDS/DeepTutor/blob/main/docs-for-dev/AGENT_SETUP.md) 和 [README](https://github.com/HKUDS/DeepTutor)。DeepTutor 更新频繁；执行前优先检查本机安装版本和 `--help`，不要把这里的示例当成所有版本都适用。

## 适用范围

- 安装或升级 DeepTutor，配置服务、模型或运行目录。
- 运行对话、测验、深度研究、解题、可视化、Mastery Path 等学习能力。
- 创建、查询、评估知识库；管理学习记录、问题、Books、Partners、Skills、会话或笔记本。
- 检查 DeepTutor 的模块状态、错误日志或服务可用性。

## 安装与配置

1. 先检查是否已有 DeepTutor 检出目录、CLI、Python 环境及 `DEEPTUTOR_HOME`；复用现有安装并保留其设置和学习数据。
2. 当前官方完整 Web 应用安装方式为 `python -m pip install -U "deeptutor[full]"`；核心 CLI/SDK 可用 `python -m pip install -U deeptutor`。源码安装按仓库的 Agent Setup 指南操作。不要默认直接升级旧安装；先识别版本，尤其注意 1.6.15 及更早版本的迁移说明。
3. 首次初始化可运行 `deeptutor init`，仅 CLI 使用时加 `--cli`，指定数据运行目录时用 `--home <path>`。统一使用同一运行目录；不要把 `data/` 子目录误当成 `DEEPTUTOR_HOME`。
4. 初始化后检查 `deeptutor module list` 和 `deeptutor doctor --format json`。需要验证在线模型时，`doctor --online` 会发起真实模型请求，可能产生费用；只有用户已授权外部调用时才运行。
5. 配置密钥时只引用用户指定的环境变量或认证流程。不要在聊天、命令行回显、JSON 配置或日志中输出密钥。缺少提供商、模型、凭据来源或目标目录时，先完成不依赖它们的检查，再询问缺失项。
6. 安装或修改模块前先确认目标版本和依赖状态；对源码检出按官方指南使用 `python scripts/install_extras.py ...`，不要自行假设模块已安装或可用。

## 常用命令

先用 `deeptutor --help`、`deeptutor <命令> --help` 确认本机版本语法。以下示例基于官方 CLI：

```bash
deeptutor chat
deeptutor chat --capability deep_solve --kb textbook --tool web_search
deeptutor run chat "Explain Fourier transform"
deeptutor run deep_solve "Solve x^2 = 4" --kb textbook
deeptutor run deep_question "Linear algebra" --config num_questions=5
deeptutor run deep_research "Attention mechanisms" --config mode=report --config depth=standard
deeptutor plugin list
deeptutor module list
deeptutor doctor --format json
```

### 知识库与学习记录

```bash
deeptutor kb list
deeptutor kb create physics --doc ch1.pdf --doc ch2.pdf
deeptutor kb search physics "Newton's third law"
deeptutor kb eval physics --dataset qa.jsonl --top-k 5
deeptutor session list
deeptutor notebook list
deeptutor memory show
```

删除知识库、会话、记忆或笔记内容会移除用户数据。先说明将删除的具体对象，并按 CLI 要求让用户确认；不要使用跳过确认的强制选项，除非用户明确要求。

### Web 应用

用 `deeptutor start` 启动完整 Web 应用，按命令输出的地址访问；停止时用 `deeptutor stop` 或按启动方式中断服务。不要为释放端口而停止无关进程。避免同一 `DEEPTUTOR_HOME` 同时被后台 Web 应用与另一个 CLI turn 使用；先停止应用再跑 CLI 检查。

## 故障排查

1. 确认用户实际使用的安装方式、版本、Python 环境、`DEEPTUTOR_HOME` 和服务地址；健康的另一份安装不能证明目标实例正常。
2. 根据症状先取最小证据：`deeptutor config show`（密钥应脱敏）、`deeptutor doctor --format json`、`deeptutor module list`、相关时间段的日志。不要整份复制或暴露私密日志。
3. 一次验证一个假设；将问题定位到浏览器/API、能力/模块、模型提供方、知识检索或存储边界。
4. 检查失败项本身；总状态成功不代表可选模块、Embedding、搜索或工具都可用。报告已验证结果和未完成项，不把“设置已保存”说成“服务已就绪”。
5. 修改配置、升级、迁移或清理数据前，检查本地改动和数据位置；按官方指南备份并保留既有运行目录。

## 版本与来源

DeepTutor 官方仓库和文档是版本敏感信息的事实来源：

- 仓库与发布说明：https://github.com/HKUDS/DeepTutor
- 官方 CLI Skill：https://github.com/HKUDS/DeepTutor/blob/main/SKILL.md
- 安装、配置和验证：https://github.com/HKUDS/DeepTutor/blob/main/docs-for-dev/AGENT_SETUP.md

如果命令、模块或安装方式与本技能不一致，以对应版本仓库的 `--help` 和官方文档为准，并简短说明差异。
