#!/usr/bin/env python3
"""生成各模型可直接粘贴的提示词和跨模型模板。

输出到 dist/：
  dist/claude.md  dist/openai.md  dist/gemini.md  dist/grok.md  dist/domestic.md
  dist/templates/<skill>.md   每个 Skill 的可粘贴模板版本
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
DIST = ROOT / "dist"
ADAPTERS = {
    "claude": "claude.md",
    "openai": "openai.md",
    "gemini": "gemini.md",
    "grok": "grok.md",
    "domestic": "domestic.md",
}


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


def main():
    DIST.mkdir(exist_ok=True)
    for name, f in ADAPTERS.items():
        if name == "claude":
            out = f"<global_rules>\n{CORE}\n</global_rules>\n\n{addon(f)}\n"
        else:
            out = f"{CORE}\n\n{addon(f)}\n"
        (DIST / f"{name}.md").write_text(out, encoding="utf-8")

    tdir = DIST / "templates"
    tdir.mkdir(exist_ok=True)
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
        (tdir / f"{name}.md").write_text(header + body + "\n", encoding="utf-8")

        # claude.ai 上传用的 ZIP：压缩包内是 <name>/ 文件夹
        zdir = DIST / "skill-zips"
        zdir.mkdir(exist_ok=True)
        with zipfile.ZipFile(zdir / f"{name}.zip", "w", zipfile.ZIP_DEFLATED) as z:
            for f in sorted(skill.parent.rglob("*")):
                rel = f.relative_to(skill.parent)
                # 跳过 .DS_Store、Thumbs.db 等系统文件
                if not f.is_file() or any(p.startswith(".") for p in rel.parts) or f.name == "Thumbs.db":
                    continue
                z.write(f, f"{name}/{rel.as_posix()}")
        count += 1
    print(f"已生成 {len(ADAPTERS)} 个模型版本、{count} 个模板和 {count} 个 ZIP，位于 {DIST}")


if __name__ == "__main__":
    main()
