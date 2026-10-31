# 原始提示词去向对照表

每条原始提示词被放到了哪里、做了什么改动。原始提示词的版权归各自作者所有，本项目是在其基础上的重组和改写。

## 来源
- A：你自己的两条提示词（开源调研、深度化追问）
- B：《12 个最常用的 Prompt》，作者：数字生命卡兹克
- C：小红书《从思路整理到执行计划》8 条（Reality Check 等）
- D：小红书转述的 Andrej Karpathy 四级输出法（原推文未核实）
- E：《GPT 4 小时个人导师》6 条
- F：《真正烧 Token 的 10 个习惯》
- G：《GPT 上帝模式》7 条
- H：10 个 GitHub 仓库（见 `third-party.md`）
- I：小红书 12 个提示词新版（B 的更新版），以及 @yan5xu 的推文"我碰到的是什么经典问题的变体，并且有什么解法"
- J：《Organization and Prompts》科研知识库方案（小红书作者"红腚大马猴"，基于 Karpathy 的 LLM Wiki 思路，针对"积累科研领域经验 + 和 LLM 协作讨论 idea"设计）

## 对照表

| 原始提示词 | 去向 | 主要改动 |
|---|---|---|
| A1 开源方案调研 | `oss-scout` | 加入需求补全、可查证的维护标准、许可证检查、决策阈值 |
| A2 四个问题深度化 | `deepen`；精神进入全局第 3、4、6 节 | 加入"更深不是更宽"的硬判定和具体性自检 |
| B1 苏格拉底式提问 | `socratic-diagnosis` 标准问诊 | 基本保留 |
| B2 双层解释法 | `tutor` 模式 1 | 基本保留 |
| B3 反向拆解 | `reverse-engineer` 模式 A | 基本保留 |
| B4 横纵分析法 | `hv-research` | 加入篇幅选项、分段交付；证据规则同步进全局第 4 节 |
| B5 事实核查 | `fact-check` | 加入核查标记符号、不能联网时的处理、高风险话题双向检索 |
| B6 专家会诊 | `perspective-lab` 工具 B | 基本保留 |
| B7 第一性原理 | `perspective-lab` 工具 C | 基本保留 |
| B8 跨领域借解 | `perspective-lab` 工具 D | 补全原文缺失的半句；加入"案例必须真实可查" |
| B9 双向钢人论证 | `decision-lab` 第 1–4 步 | 与 C5、B10 合并 |
| B10 最小实验 | `decision-lab` 第 5 步 B | 与 B9 合并 |
| B11 挖掘隐藏天赋 | `talent-discovery` | 加入"非官方测评、非诊断"说明和保护规则，篇幅可选 |
| B12 人生设计术 | `life-design` | 保留原有保护规则（低谷时跳过反向推演）并加强，篇幅可选 |
| C1 Reality Check | `plan-stress-test` 第 1 步；全局第 5 节 | 与 C7 合并，加入严重程度排序 |
| C2 Reframe Lens | `perspective-lab` 工具 A | 角色可按问题替换 |
| C3 Gut Decode | `socratic-diagnosis` 直觉解码模式 | 合并 |
| C4 Thought Organizer | `socratic-diagnosis` 思路整理模式 | 合并 |
| C5 Decision Mirror | `decision-lab` 第 3 步 | 合并 |
| C6 Root Question | `socratic-diagnosis` 挖根问题模式 | 合并 |
| C7 Risk Scan | `plan-stress-test` 第 2 步 | 用"事前验尸"法改写 |
| C8 Next Move | 全局第 9 节 | 变成所有行动类话题的默认收尾 |
| D 四级输出法 | `explain-levels`；第 1 级规则进入全局第 8 节 | 加入中文受控写作的适配、升级原则、视频制作流程 |
| E1 学习曲线破坏者 | `tutor` 模式 3 | 去掉"再也见不到我"的设定，保留核心要求 |
| E2 真实错误模拟器 | `tutor` 模式 4 | 基本保留 |
| E3 困惑破碎机 | `tutor` 模式 2 | 基本保留 |
| E4 个人学习路径 | `tutor` 模式 7 | 基本保留 |
| E5 隐藏漏洞检测器 | `tutor` 模式 5 | 改为一次问一个 |
| E6 强制费曼方法 | `tutor` 模式 6 | 基本保留 |
| F 10 个烧 Token 习惯 | 模型能执行的进入全局第 8、10 节；其余进入 `usage-habits.md` | 区分"模型规则"和"使用者习惯" |
| G1 隐藏知识探测器 | **未收录** | "被隐藏的真相"框架容易诱导阴谋论式编造 |
| G2 精通路线图生成器 | `tutor` 模式 8 | 去掉"顶尖 1% 的秘籍"渲染，要求只推荐真实资源 |
| G3 未来 AI 顾问 | **未收录** | 让模型扮演"来自未来"会诱导编造 |
| G4 平行现实智慧 | **未收录** | 同上，且原文没有具体任务 |
| G5 天才大脑复制器 | `reverse-engineer` 模式 B | 要求只依据可查证材料，不编造原话 |
| G6 古代智慧 + 现代科学 | **未收录** | 容易产生伪科学混搭；真正需要时可用 `fact-check` 核查具体说法 |
| G7 后人类智能模式 | `perspective-lab` 的"反常规视角"说明 | 用第一性原理和跨领域借解实现，不用虚构设定 |
| I0 经典问题的变体（推文） | 全局第 7 节、精简版第 8 条；`perspective-lab` 第 0 步 | 新增：作为解决不简单问题前的默认动作 |
| I1/I2/I3/I4/I6/I7/I9/I10 | 与 B 版内容一致 | 无需改动 |
| I5 事实核查（新版） | `fact-check` | 新增 1–5 分可信度评分；"补强版本"改为"去掉夸张后还剩什么" |
| I8 跨领域借解（新版） | `perspective-lab` 工具 D | 采用新版结构：底层结构词汇、远领域示例、"要改哪几个变量""怎么兜底"、可直接试的方案 |
| I11 挖掘隐藏天赋（新版） | `talent-discovery` | 新增快速版；四条主线命名；边收集边形成"天赋假设"；输出增加"暗面""工作和项目形状""桌面自我提醒" |
| I12 人生设计术（新版） | `life-design` | 新增快速版；版本 A 改为"做到极致"、版本 C 改为"为好奇心而活"；每个版本都带季度、月、今天三级行动；四项自评由用户自己打分 |
| J1 目录结构 | `research-wiki` 初始化步骤；`skills/research-wiki/assets/schema.md` 目录约定 | 保留结构；规则文件改为 `AGENTS.md`，另建一行 `@AGENTS.md` 的 `CLAUDE.md`，让 Claude Code、Copilot、Kiro、Kimi Code 共用 |
| J2 CLAUDE.md 模板 | `skills/research-wiki/assets/schema.md`、`skills/research-wiki/assets/paper.md` | 拆成知识库规则文件和论文页模板；新增命名规则、概念页格式、假设条目格式、日志格式；新增"不编造论文内容、数字注明出处"等铁律 |
| J3.1 Ingest 提示词 | `research-wiki` 操作二 | 先口头汇报再写文件；增加"快速模式"；概念出现 3 次以上自动建页 |
| J3.2 领域全景讨论 | `research-wiki` 操作四 | 基本保留，结束时增加同步 field-map 的询问 |
| J3.3 Idea 生成 | `research-wiki` 操作五 | 新增"自己认为最弱的地方"和实验成本；未指定方向时先给选项 |
| J3.4 Lint 提示词 | `research-wiki` 操作六 | 合并原 CLAUDE.md 里的 Lint 清单，新增孤儿页面、已被回答的问题；改为先报告、确认后再改 |
| J3.5 多模型辩论 | `research-wiki` 操作七、`skills/research-wiki/assets/debate.md` | 模型分工改为可替换的角色；"2025 年后"改为"最新论文"；新增回答格式要求 |
| J4 答案写回 wiki | `research-wiki` 操作三 | 改为由 AI 主动询问是否写回，不需要用户每次手动补一句 |
| H Karpathy 编码准则仓库 | 全局第 6、7 节 | 用自己的话重写四条原则 |
| H 其余 9 个仓库 | `third-party.md` | 只引用和推荐，不复制代码 |
