---
name: research-wiki
description: 为某个研究方向搭建并维护一个长期积累的论文知识库（LLM Wiki）：AI 把论文整理成结构化页面，持续积累方法谱系、研究空白和创新假设，好的讨论结果写回知识库。用于初始化知识库、处理新论文、基于知识库问答、领域全景讨论、生成研究 idea、定期健康检查、多模型辩论。触发词如"建一个研究知识库""处理这篇论文""入库""读一下这篇 paper""这个领域现在什么情况""帮我想研究 idea""检查一下 wiki""research wiki"。
---

# 科研知识库（Research Wiki）

把零散的论文阅读变成会复利的知识库。分工是：**用户提供原材料和方向判断，AI 做全部整理工作**。用户读 `wiki/`，AI 写 `wiki/`。

## 适用环境
本技能需要读写本地文件，适合在 Claude Code、GitHub Copilot、Kiro、Kimi Code、WorkBuddy、Cherry Studio Agent 等能操作文件夹的环境中使用。

在不能写文件的纯聊天环境中，照常执行各项操作，但把要写入的页面完整输出，并注明文件路径，让用户自己保存。

## 第 0 步：找到知识库
1. 在当前工作目录或用户指定的路径里，查找根目录下的 `AGENTS.md`，并确认文件开头是 `# Research Wiki Schema`。
2. 找到了：先完整读一遍 `AGENTS.md`，再读 `wiki/index.md`，然后按用户的需求选择下面的操作。
3. 没找到：问用户是否要在某个文件夹新建知识库，同意后执行"初始化"。

**`AGENTS.md` 是这个知识库的最高规则**：页面格式、命名、frontmatter 都以它为准。用户修改过它的，以用户版本为准。

## 操作一：初始化
1. 一次问清以下问题，最多 3 个：
   - 研究方向（一两句话）
   - 知识库使用的语言（默认中文，术语保留英文）
   - 论文主要来源（默认 arXiv，用 arXiv ID 命名；其他来源用 `作者-年份-短标题`）
2. 创建目录结构：
   ```
   AGENTS.md            ← 复制 assets/schema.md，把 {{研究方向}} 等占位符替换掉
   CLAUDE.md            ← 只有一行：@AGENTS.md（Claude Code 会据此读取 AGENTS.md）
   raw/papers/  raw/notes/  raw/assets/
   wiki/index.md  wiki/log.md  wiki/overview.md
   wiki/papers/  wiki/concepts/  wiki/entities/  wiki/comparisons/
   wiki/gaps/confirmed-gaps.md  wiki/gaps/hypotheses.md  wiki/gaps/questions.md
   wiki/synthesis/field-map.md  wiki/synthesis/shared-assumptions.md
   ```
   每个 `.md` 文件只写标题和一行用途说明，不编造内容。
3. 告诉用户：
   - 怎么把 PDF 转成 Markdown 放进 `raw/papers/`。推荐 MinerU，公式和表格保留得较好；也可以用 marker、pymupdf4llm 等工具。直接放 PDF 也行，但识别质量可能下降。
   - 建议的节奏：每读一篇做一次"处理新论文"，每 1–2 周做一次"健康检查"。
4. 如果知识库文件夹还不是 Git 仓库，建议用户初始化 Git，每次操作后提交一次，方便回看和撤销。

## 操作二：处理新论文（Ingest）
1. 读取 `raw/papers/` 里的这篇论文全文。
2. **先不写任何文件**。先告诉用户三件事：
   - 这篇论文的核心 claim（一句话）
   - 它假设了哪些在这个领域里大家都没质疑过的东西
   - 它和 `wiki/` 里已有内容有没有矛盾（引用具体页面）
3. 和用户讨论 2–3 个关键 takeaway。用户说"直接入库"或"快速模式"时跳过讨论，页面状态标为 `skimmed`。
4. 按 `assets/paper.md` 的格式写 `wiki/papers/<id>.md`。**"Gap 线索"一栏要写具体**：这篇论文暗示了、但没有做的方向，哪怕想法还粗糙，也不要写客套话。
5. 更新相关的 `wiki/concepts/` 和 `wiki/entities/` 页面：补充新证据，修正已有理解。某个概念在 3 篇以上论文中出现、但还没有页面的，新建它的页面。
6. 发现矛盾时，在**两个**相关页面上都显式标注，并互相链接。
7. 有新的开放问题，就追加到 `wiki/gaps/questions.md`。
8. 更新 `wiki/index.md`，在 `wiki/log.md` 末尾追加一条记录。
9. 用 3–5 行向用户汇报：新建和修改了哪些页面，发现了什么矛盾或新问题。

## 操作三：基于知识库问答（Query）
1. 先读 `wiki/index.md`，找到相关页面再读。
2. 回答时用 `[[页面名]]` 引用知识库内容。知识库之外的知识要标明"知识库外"；涉及事实时，按全局准则的证据规则处理。
3. 知识库里没有足够依据的，直接说知识库里还缺什么，以及应该补读哪类论文。
4. 答案有价值时（一次对比分析、一个新发现的联系、一个新判断），**主动问用户要不要写回知识库**：
   - 方法对比类 → `wiki/comparisons/<主题>-comparison.md`
   - 综合判断类 → `wiki/synthesis/discussion-<日期>.md`，核心结论不超过 200 字
   - 同时更新 `wiki/log.md` 和 `wiki/index.md`

## 操作四：领域全景讨论
1. 读取 `wiki/overview.md`、`wiki/synthesis/field-map.md`、`wiki/synthesis/shared-assumptions.md`。
2. 回答三个问题：
   - 按知识库的记录，这个领域主流的方法谱系是什么？用"问题 → 主流解法 → 代表论文"的格式整理。
   - 这些方法共享哪些隐含假设？哪个假设最脆弱、却很少有论文去质疑？
   - 最近入库的 3 篇论文里，有没有暗示某种范式转变？
3. 结束时问用户：要不要把这次讨论的结论写进 `wiki/synthesis/`，以及是否同步更新 `field-map.md` 和 `shared-assumptions.md`。

## 操作五：生成研究 idea
1. 读取 `wiki/gaps/confirmed-gaps.md`、`wiki/gaps/questions.md` 和 `wiki/synthesis/shared-assumptions.md`。
2. 围绕用户指定的方向，提出 3 个研究假设。用户没指定方向时，先从 `confirmed-gaps.md` 里选 2–3 个方向给用户挑。
3. 每个假设必须写清：
   - 它和哪些已有工作有什么区别（引用知识库里的具体论文页面）
   - 最强的反对理由是什么，哪篇论文可能是反例
   - 如果成立，最小的可验证实验是什么（数据、对照组、指标、预计成本）
   - 你自己认为它最弱的地方
4. **不讨好用户**。某个想法很普通，就直接说；发现比用户指定的方向更有价值的空白，主动指出。
5. 讨论后，把达成共识的假设写入 `wiki/gaps/hypotheses.md`，状态标为 `draft`，并记录日期和讨论要点。

## 操作六：健康检查（Lint，建议每 1–2 周一次）
检查以下项目，然后生成报告：
1. 在 3 篇以上论文中出现、但没有独立 `concepts/` 页面的概念
2. `hypotheses.md` 里的 `draft` 假设，有没有在新入库的论文里找到证据或反例
3. `overview.md` 和 `field-map.md` 里，有没有被新论文推翻的结论
4. 两个页面之间的矛盾（不同的实验结论、不同的假设），以及还没有显式标注的矛盾
5. 孤儿页面（没有任何页面链接到它）
6. `questions.md` 里的开放问题，有没有已经被新论文回答的

报告格式：
```
## 需要创建的新概念页面
## 假设状态更新
## 需要修订的结论
## 检测到的矛盾
## 孤儿页面
## 已被回答的开放问题
```
**先报告，再动手**。列出建议的修改，等用户确认后再执行。执行后更新 `wiki/log.md`。

## 操作七：多模型辩论
用于让多个模型（例如 Claude、Gemini、Codex，或任何组合）就同一个问题各自发表意见。
1. 按 `assets/debate.md` 生成一份 `wiki/synthesis/debate-<日期>.md`，填入：本轮议题、从知识库摘录的相关段落、上轮结论、每个模型的分工。
2. 告诉用户：把这个文件分别交给各个模型，收集回答后粘贴回来，或保存为 `raw/notes/` 下的文件。
3. 用户带回各模型的回答后：对比共识、分歧和各自的证据，把汇总结论写入 `wiki/synthesis/discussion-<日期>.md`，并更新 `wiki/log.md`。
4. 默认分工可以调整：一个模型负责综合知识库给出判断，一个负责联网检索最新论文来支持或反驳，一个专门挑最弱的假设并找反例。

## 铁律（所有操作通用）
- `raw/` **只读**。永远不修改、不删除用户放进去的原始材料。
- **不编造论文内容**。数字、结论、作者、引用都必须能在 `raw/` 中的原文找到出处，在页面里注明章节或页码。原文里找不到的，写"原文未提及"。
- 知识库之外的判断，标为"推测"或"知识库外"，并对应设置 `confidence: low`。
- 每次写文件后，都更新 `wiki/index.md` 和 `wiki/log.md`。`log.md` 只追加，不修改历史记录。
- 涉及较多页面的大改动（批量重命名、合并页面、删除页面），先列计划，等用户确认后再执行。
