#!/usr/bin/env python3
"""Converts HTML pages to Markdown for LLM consumption (llms.txt standard).

Usage:
    pip install html2text beautifulsoup4
    python3 scripts/generate_md.py
"""
import html2text
from bs4 import BeautifulSoup
from pathlib import Path

# Pages excluded from LLM content: UI-only, legal boilerplate, or redirect pages
EXCLUDE = {"index", "terms", "privacy", "demo", "app", "contact"}

PUBLIC = Path(__file__).parent.parent / "public"


def html_to_md(html_path: Path) -> str:
    soup = BeautifulSoup(html_path.read_text(encoding="utf-8"), "html.parser")

    # Remove nav and footer — keep only content sections
    for tag in soup.find_all(["nav", "footer"]):
        tag.decompose()

    # Remove script and style tags
    for tag in soup.find_all(["script", "style"]):
        tag.decompose()

    body = soup.find("body") or soup
    h = html2text.HTML2Text()
    h.ignore_links = False
    h.ignore_images = True
    h.body_width = 0
    h.ignore_emphasis = False
    return h.handle(str(body)).strip()


def main() -> None:
    all_md: list[str] = []
    pages = sorted(f.stem for f in PUBLIC.glob("*.html") if f.stem not in EXCLUDE)

    for page in pages:
        html_file = PUBLIC / f"{page}.html"

        md = html_to_md(html_file)
        out = PUBLIC / f"{page}.md"
        out.write_text(md, encoding="utf-8")
        all_md.append(f"# {page}\n\n{md}")
        print(f"Generated {out.name}")

    full_path = PUBLIC / "llms-full.txt"
    full_path.write_text("\n\n---\n\n".join(all_md), encoding="utf-8")
    print(f"Generated {full_path.name}")


if __name__ == "__main__":
    main()
