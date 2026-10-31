#!/usr/bin/env python3
"""生成 dist/ 下的全部文件。

输出：
  dist/claude.md  openai.md  gemini.md  grok.md  domestic.md   各模型的全局准则
  dist/coding-agents.md       GitHub Copilot、Kimi Code、Kiro 等编码工具用的全局准则
  dist/kiro-steering.md       Kiro 全局规则文件（带 inclusion: always 头部）
  dist/lite-router.md         精简版 + 技能路由表，给 WorkBuddy 自定义指令等有字数限制、又装了 Skills 的地方
  dist/templates/<skill>.md   每个 Skill 的可粘贴模板
  dist/skill-zips/<skill>.zip 上传 claude.ai 用的 ZIP

只有修改了 core/、adapters/、skills/ 之后才需要运行。只用 Python 标准库，需要 Python 3.8+。
用法：
  macOS / Linux：python3 scripts/build.py
  Windows：      py scripts\\build.py      （或 python scripts\\build.py）
"""
import re
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CORE = (ROOT / "core" / "global-prompt.md").read_text(encoding="utf-8").strip()
LITE = (ROOT / "core" / "global-prompt-lite.md").read_text(encoding="utf-8").strip()
DIST = ROOT / "dist"
ADAPTERS = {
    "claude": "claude.md",
    "openai": "openai.md",
    "gemini": "gemini.md",
    "grok": "grok.md",
    "domestic": "domestic.md",
    "coding-agents": "coding-agents.md",
}
# 安装器写入用户配置文件时用这个标记识别"由本项目管理的文件"，不要改动
MARKER = "<!-- global-prompt-kit: 本文件由 Global Prompt Kit 安装器生成，重新安装时会被更新 -->"


def addon(adapter_file: str) -> str:
    """取出适配文件中"附加片段"标题下的第一个代码块内容。"""
    text = (ROOT / "adapters" / adapter_file).read_text(encoding="utf-8")
    m = re.search(r"附加片段[^\n]*\n```[a-z]*\n(.*?)\n```", text, re.S)
    if not m:
        raise SystemExit(f"{adapter_file} 中找不到附加片段代码块")
    return m.group(1).strip()


def split_skill(path: Path):
    text = path.read_text(encoding="utf-8")
    m = re.match(r"---\n(.*?)\n---\n(.*)", text, re.S)
    if not m:
        raise SystemExit(f"{path} 缺少 frontmatter")
    meta = dict(
        line.split(":", 1) for line in m.group(1).splitlines() if ":" in line
    )
    return meta["name"].strip(), meta["description"].strip(), m.group(2).strip()


def router_table() -> str:
    """从全局准则第 12 节的表格生成技能路由说明。"""
    rows = re.findall(r"^\| ([^|\n]+?) \| ([a-z-]+) \|$", CORE, re.M)
    if len(rows) < 5:
        raise SystemExit("全局准则第 12 节的场景表格解析失败")
    lines = [
        "12. 我已安装下列技能。遇到对应情况时，**主动使用对应技能，不需要等我点名或询问我**；没有安装技能的环境里，按同样的思路执行：",
    ]
    lines += [f"   - {scene} → {skill}" for scene, skill in rows]
    return "\n".join(lines)


def main():
    DIST.mkdir(exist_ok=True)
    for name, f in ADAPTERS.items():
        if name == "claude":
            out = f"<global_rules>\n{CORE}\n</global_rules>\n\n{addon(f)}\n"
        else:
            out = f"{CORE}\n\n{addon(f)}\n"
        (DIST / f"{name}.md").write_text(out, encoding="utf-8")

    coding = (DIST / "coding-agents.md").read_text(encoding="utf-8")
    (DIST / "kiro-steering.md").write_text(
        f"---\ninclusion: always\n---\n{MARKER}\n\n{coding}", encoding="utf-8"
    )
    # 去掉精简版开头写给人看的说明行，只保留给模型的规则
    lite_rules = "\n".join(l for l in LITE.splitlines() if not l.startswith("（")).strip()
    (DIST / "lite-router.md").write_text(f"{lite_rules}\n{router_table()}\n", encoding="utf-8")
    (DIST / "MARKER.txt").write_text(MARKER + "\n", encoding="utf-8")

    tdir = DIST / "templates"
    tdir.mkdir(exist_ok=True)
    zdir = DIST / "skill-zips"
    zdir.mkdir(exist_ok=True)
    count = 0
    for skill in sorted((ROOT / "skills").glob("*/SKILL.md")):
        name, desc, body = split_skill(skill)
        if name != skill.parent.name:
            raise SystemExit(f"{skill}: name 与文件夹名不一致")
        header = (
            f"# 模板：{name}\n\n"
            f"**用法**：把本模板全文粘贴到新对话的开头，然后在下面写你的情况。\n\n"
            f"**适用场景**：{desc}\n\n---\n\n"
        )
        # Skill 文件夹里的附件（如 assets/ 下的模板）附在末尾，让粘贴版也完整可用
        extras = ""
        for f in sorted(skill.parent.rglob("*")):
            rel = f.relative_to(skill.parent)
            if f.is_file() and f.name != "SKILL.md" and not any(p.startswith(".") for p in rel.parts):
                extras += (
                    f"\n\n---\n\n## 附件：{rel.as_posix()}\n\n"
                    f"~~~~markdown\n{f.read_text(encoding='utf-8').strip()}\n~~~~"
                )
        (tdir / f"{name}.md").write_text(header + body + extras + "\n", encoding="utf-8")

        # claude.ai 上传用的 ZIP：压缩包内是 <name>/ 文件夹
        with zipfile.ZipFile(zdir / f"{name}.zip", "w", zipfile.ZIP_DEFLATED) as z:
            for f in sorted(skill.parent.rglob("*")):
                rel = f.relative_to(skill.parent)
                # 跳过 .DS_Store、Thumbs.db 等系统文件
                if not f.is_file() or any(p.startswith(".") for p in rel.parts) or f.name == "Thumbs.db":
                    continue
                z.write(f, f"{name}/{rel.as_posix()}")
        count += 1
    print(f"已生成 {len(ADAPTERS)} 个全局准则版本、{count} 个模板和 {count} 个 ZIP，位于 {DIST}")


if __name__ == "__main__":
    main()
