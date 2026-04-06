#!/usr/bin/env python3
"""Generate LLM-friendly Markdown from landing pages."""

from __future__ import annotations

import json
import os
import re
import urllib.request
from collections.abc import Callable
from pathlib import Path

import html2text
from bs4 import BeautifulSoup, NavigableString, Tag


EXCLUDE = {"index", "terms", "privacy", "demo", "app", "contact"}
PUBLIC = Path(__file__).parent.parent / "public"
APP_DOWNLOAD_URL = "https://vytallink.xmartlabs.com/app"


def new_converter() -> html2text.HTML2Text:
    converter = html2text.HTML2Text()
    converter.ignore_links = False
    converter.ignore_images = True
    converter.body_width = 0
    converter.ignore_emphasis = False
    return converter


def clean_text(value: str) -> str:
    return " ".join(value.replace("\xa0", " ").split()).replace(" ›", "").strip()


def normalize_markdown(markdown: str) -> str:
    lines = [line.rstrip() for line in markdown.splitlines()]
    cleaned: list[str] = []

    for line in lines:
        stripped = line.strip()
        if stripped == "__":
            continue
        if re.fullmatch(r"\[\s*(.*?)\s*\]", stripped):
            line = re.sub(r"\[\s*(.*?)\s*\]", lambda match: f"[{match.group(1).strip()}]", line)
        cleaned.append(line)

    markdown = "\n".join(cleaned)
    markdown = re.sub(r"\n{3,}", "\n\n", markdown)
    return markdown.strip()


def join_blocks(blocks: list[str]) -> str:
    return normalize_markdown("\n\n".join(block.strip() for block in blocks if block and block.strip()))


def clone_tag(tag: Tag) -> Tag:
    return BeautifulSoup(str(tag), "html.parser").find()  # type: ignore[return-value]


def text_from(node: Tag | None) -> str:
    if node is None:
        return ""
    return clean_text(node.get_text(" ", strip=True))


def strip_fragment_noise(fragment: Tag) -> Tag:
    for selector in [".copy-btn", ".brand-mark", ".arrow"]:
        for node in fragment.select(selector):
            node.decompose()

    for node in fragment.find_all(["i", "img", "button"]):
        node.decompose()

    return fragment


def fragment_to_markdown(node: Tag) -> str:
    fragment = strip_fragment_noise(clone_tag(node))
    return normalize_markdown(new_converter().handle(str(fragment)).strip())


def inner_markdown(node: Tag) -> str:
    fragment = BeautifulSoup("".join(str(child) for child in node.contents), "html.parser")
    root = fragment.find() or fragment
    if isinstance(root, Tag):
        root = strip_fragment_noise(root)
    return normalize_markdown(new_converter().handle(str(fragment)).strip())


def render_list(list_tag: Tag) -> str:
    ordered = list_tag.name == "ol"
    lines: list[str] = []

    for index, item in enumerate(list_tag.find_all("li", recursive=False), start=1):
        clone = clone_tag(item)
        for nested in clone.find_all(["ul", "ol"]):
            nested.decompose()

        prefix = f"{index}. " if ordered else "- "
        content = inner_markdown(clone)
        lines.append(f"{prefix}{content}")

    return "\n".join(lines)


def list_links(anchors: list[Tag]) -> str:
    lines: list[str] = []
    for anchor in anchors:
        label = text_from(anchor)
        href = anchor.get("href", "").strip()
        if not href or href == "#":
            if "download-app-btn" in anchor.get("class", []):
                href = APP_DOWNLOAD_URL
            else:
                continue
        lines.append(f"- [{label}]({href})")
    return "\n".join(lines)


def code_language(code_tag: Tag) -> str:
    for class_name in code_tag.get("class", []):
        if class_name.startswith("language-"):
            return class_name.removeprefix("language-")
    return ""


def render_code_block(code_block: Tag, heading: str | None = None, level: int = 4) -> str:
    code_tag = code_block.find("code")
    if code_tag is None:
        return ""

    heading_text = heading or text_from(code_block.select_one(".code-header span"))
    language = code_language(code_tag)
    code = code_tag.get_text("\n").strip("\n")

    blocks = [f"{'#' * level} {heading_text}" if heading_text else ""]
    blocks.append(f"```{language}\n{code}\n```".strip())
    return join_blocks(blocks)


def render_note(tag: Tag) -> str:
    note = fragment_to_markdown(tag)
    return "\n".join("> " + line if line else ">" for line in note.splitlines())


def render_paths(container: Tag) -> str:
    lines: list[str] = []
    for path in container.select(".os-path"):
        path_id = path.get("id", "").lower()
        if "windows" in path_id:
            label = "Windows"
        elif "linux" in path_id:
            label = "Linux"
        else:
            label = "macOS"

        code = text_from(path.find("code"))
        if code:
            lines.append(f"- **{label}:** `{code}`")

    if not lines:
        return ""

    return join_blocks(["#### Configuration File Locations", "\n".join(lines)])


def render_auth_example(container: Tag) -> str:
    lines = ["#### Example Conversation"]
    for message in container.select(".chat-message"):
        speaker = text_from(message.find("strong")).rstrip(":")
        text = clean_text(message.get_text(" ", strip=True))
        if speaker:
            text = text.removeprefix(f"{speaker}:").strip()
            lines.append(f"- **{speaker}:** {text}")
        elif text:
            lines.append(f"- {text}")
    return "\n".join(lines)


def render_prerequisites(section: Tag) -> str:
    blocks = ["## Prerequisites"]
    intro = section.select_one(".section-header p")
    if intro:
        blocks.append(text_from(intro))

    for card in section.select(".prereq-card"):
        title = text_from(card.find("h3"))
        parts = [f"### {title}", *[fragment_to_markdown(p) for p in card.find_all("p", recursive=False)]]
        links = list_links(card.select(".prereq-links a"))
        if links:
            parts.append(links)
        blocks.append(join_blocks(parts))

    return join_blocks(blocks)


def render_support_links(section: Tag) -> str:
    title = text_from(section.find("h3"))
    intro = fragment_to_markdown(section.find("p")) if section.find("p") else ""
    links = list_links(section.select("a"))
    return join_blocks([f"## {title}", intro, links])


def render_steps(steps: list[Tag], extra_renderer: Callable[[Tag], str] | None = None) -> list[str]:
    blocks: list[str] = []
    for step in steps:
        number = text_from(step.select_one(".step-number"))
        title = text_from(step.find("h3"))
        parts = [f"### Step {number}: {title}"]
        content = step.select_one(".step-content")
        if content is None:
            blocks.append(join_blocks(parts))
            continue

        for child in content.children:
            if isinstance(child, NavigableString):
                continue
            if child.name == "h3":
                continue

            classes = set(child.get("class", []))
            if child.name == "p":
                parts.append(fragment_to_markdown(child))
            elif "code-block" in classes:
                parts.append(render_code_block(child))
            elif classes & {"cursor-note", "vscode-note"}:
                parts.append(render_note(child))
            elif classes & {"config-location", "config-paths"}:
                parts.append(render_paths(child))
            elif "auth-example" in classes:
                parts.append(render_auth_example(child))
            elif extra_renderer is not None:
                rendered = extra_renderer(child)
                if rendered:
                    parts.append(rendered)
            elif child.name in {"ul", "ol"}:
                parts.append(render_list(child))

        blocks.append(join_blocks(parts))

    return blocks


def render_about(soup: BeautifulSoup) -> str:
    hero = soup.select_one(".about-hero")
    blocks = [
        f"# {text_from(hero.find('h1'))}",
        text_from(hero.select_one(".hero-subtitle")),
    ]

    for section in soup.select(".about-section"):
        title = section.select_one(".content-text h2") or section.select_one(".section-title")
        if title is None:
            continue

        section_blocks = [f"## {text_from(title)}"]
        for paragraph in section.select(".content-text > p"):
            section_blocks.append(fragment_to_markdown(paragraph))

        if section.select(".value-card"):
            for card in section.select(".value-card"):
                section_blocks.append(join_blocks([
                    f"### {text_from(card.find('h3'))}",
                    fragment_to_markdown(card.find("p")),
                ]))

        cta_links = list_links(section.select(".cta-buttons a"))
        if cta_links:
            section_blocks.append(cta_links)

        blocks.append(join_blocks(section_blocks))

    return join_blocks(blocks)


def render_chatgpt_setup(soup: BeautifulSoup) -> str:
    hero = soup.select_one(".setup-header")
    blocks = [
        f"# {text_from(hero.find('h1'))}",
        fragment_to_markdown(hero.find("p")),
        "_Most Popular Integration_",
    ]

    what_is = soup.select_one(".what-is-section")
    if what_is:
        section = [f"## {text_from(what_is.find('h2'))}"]
        intro = what_is.select_one(".what-is-text > p")
        if intro:
            section.append(fragment_to_markdown(intro))
        features = [text_from(feature.select_one("span")) for feature in what_is.select(".gpt-feature")]
        section.append("\n".join(f"- {feature}" for feature in features if feature))
        example_user = text_from(what_is.select_one(".chat-message.user span"))
        example_assistant = text_from(what_is.select_one(".chat-message.assistant span"))
        section.append(join_blocks([
            "### Example Conversation",
            f"- **You:** {example_user}",
            f"- **Assistant:** {example_assistant}",
        ]))
        blocks.append(join_blocks(section))

    steps_section = soup.select_one(".setup-instructions")
    if steps_section:
        section = [f"## {text_from(steps_section.find('h2'))}", text_from(steps_section.select_one(".section-header p"))]

        def render_chatgpt_step_extra(child: Tag) -> str:
            classes = set(child.get("class", []))
            if "gpt-access-options" in classes:
                option_blocks: list[str] = []
                for option in child.select(".gpt-option"):
                    option_blocks.append(join_blocks([
                        f"#### {text_from(option.find('h4'))}",
                        fragment_to_markdown(option.find("p")),
                        list_links(option.select("a")),
                    ]))
                return join_blocks(option_blocks)
            return ""

        section.extend(render_steps(steps_section.select(".setup-steps > .step"), render_chatgpt_step_extra))
        blocks.append(join_blocks(section))

    examples = soup.select_one(".examples-section")
    if examples:
        questions = [text_from(node) for node in examples.select(".question-bubble")]
        blocks.append(join_blocks([
            f"## {text_from(examples.find('h2'))}",
            text_from(examples.select_one(".section-header p")),
            "\n".join(f"- {question}" for question in questions if question),
        ]))

    cta = soup.select_one(".cta-section")
    if cta:
        blocks.append(join_blocks([
            f"## {text_from(cta.find('h2'))}",
            fragment_to_markdown(cta.find("p")),
            f"- [Download the VytalLink app]({APP_DOWNLOAD_URL})",
            list_links([link for link in cta.select(".cta-buttons a") if link.get("href") != "#"]),
        ]))

    return join_blocks(blocks)


def render_claude_bundle_setup(soup: BeautifulSoup) -> str:
    hero = soup.select_one(".setup-header")
    blocks = [
        f"# {text_from(hero.find('h1'))}",
        fragment_to_markdown(hero.find("p")),
    ]

    prereqs = soup.select_one(".prerequisites")
    if prereqs:
        blocks.append(render_prerequisites(prereqs))

    setup = soup.select_one(".setup-instructions")
    if setup:
        section = [f"## {text_from(setup.find('h2'))}", text_from(setup.select_one(".section-header p"))]

        def render_bundle_step_extra(child: Tag) -> str:
            classes = set(child.get("class", []))
            if "cursor-note" in classes or "bundle-alternative" in classes:
                return render_note(child)
            return ""

        section.extend(render_steps(setup.select(".setup-steps > .step"), render_bundle_step_extra))
        alternative = setup.select_one(".bundle-alternative")
        if alternative:
            section.append(render_note(alternative))
        blocks.append(join_blocks(section))

    troubleshooting = soup.select_one(".troubleshooting")
    if troubleshooting:
        section = [f"## {text_from(troubleshooting.find('h2'))}", text_from(troubleshooting.select_one(".section-header p"))]
        for item in troubleshooting.select(".faq-item"):
            section.append(join_blocks([
                f"### {text_from(item.find('h3'))}",
                fragment_to_markdown(item.find("p")),
            ]))
        blocks.append(join_blocks(section))

    return join_blocks(blocks)


def render_mcp_setup(soup: BeautifulSoup) -> str:
    hero = soup.select_one(".setup-header")
    blocks = [
        f"# {text_from(hero.find('h1'))}",
        fragment_to_markdown(hero.find("p")),
        "Supported clients: Claude Desktop, Cursor, VS Code, and other MCP-compatible clients.",
    ]

    prereqs = soup.select_one(".prerequisites")
    if prereqs:
        blocks.append(render_prerequisites(prereqs))

    setup = soup.select_one(".setup-instructions")
    if setup:
        section = [f"## {text_from(setup.find('h2'))}", text_from(setup.select_one(".section-header p"))]

        tabs = {
            "claude-content": "Claude Desktop",
            "cursor-content": "Cursor",
            "vscode-content": "VS Code",
            "other-content": "Other MCP Clients",
        }

        for panel_id, title in tabs.items():
            panel = setup.select_one(f"#{panel_id}")
            if panel is None:
                continue

            panel_parts = [f"## {title}"]
            panel_parts.extend(render_steps(panel.select(".setup-steps > .step")))
            section.append(join_blocks(panel_parts))

        blocks.append(join_blocks(section))

    troubleshooting = soup.select_one(".troubleshooting")
    if troubleshooting:
        section = [f"## {text_from(troubleshooting.find('h2'))}", text_from(troubleshooting.select_one(".section-header p"))]
        for item in troubleshooting.select(".faq-item"):
            section.append(join_blocks([
                f"### {text_from(item.find('h3'))}",
                fragment_to_markdown(item.find("p")),
            ]))

        support = troubleshooting.select_one(".support-section")
        if support:
            section.append(render_support_links(support))
        blocks.append(join_blocks(section))

    return join_blocks(blocks)


def render_developers(soup: BeautifulSoup) -> str:
    hero = soup.select_one(".setup-header")
    blocks = [
        f"# {text_from(hero.find('h1'))}",
        fragment_to_markdown(hero.find("p")),
    ]

    overview = soup.select_one(".dev-overview")
    if overview:
        lines = []
        for card in overview.select(".dev-overview-card"):
            lines.append(f"- **{text_from(card.find('h3'))}:** {fragment_to_markdown(card.find('p'))}")
        blocks.append(join_blocks(["## Why VytalLink", "\n".join(lines)]))

    how_it_works = soup.select_one(".dev-how-it-works")
    if how_it_works:
        section = [
            f"## {text_from(how_it_works.select_one('.section-header h2'))}",
            text_from(how_it_works.select_one(".section-header p")),
            "### How It Works",
            render_list(how_it_works.select_one(".dev-flow-steps-list")),
        ]

        for step in how_it_works.select(".setup-steps > .step"):
            number = text_from(step.select_one(".step-number"))
            title = text_from(step.find("h3"))
            parts = [f"### Step {number}: {title}"]
            content = step.select_one(".step-content")
            if content is None:
                continue

            lead = content.find("p", recursive=False)
            if lead:
                parts.append(fragment_to_markdown(lead))

            if title == "Integrate the VytalLink server":
                callout = content.select_one(".dev-template-callout")
                if callout:
                    parts.append(join_blocks([
                        "#### Recommended: Health Kit Template",
                        fragment_to_markdown(callout.find("p")),
                        list_links(callout.select("a")),
                    ]))

                for panel in content.select(".dev-step-code .client-content"):
                    heading = "TypeScript Example" if panel.get("data-client-panel") == "typescript" else "Python Example"
                    code_block = panel.select_one(".code-block")
                    if code_block:
                        parts.append(render_code_block(code_block, heading))

            elif title == "Link the user":
                deeplink = content.select_one(".dev-deeplink-widget")
                if deeplink:
                    parts.append(join_blocks([
                        "#### Share Link",
                        f"- [Download App]({APP_DOWNLOAD_URL})",
                        f"- Direct link: `{text_from(deeplink.select_one('#deeplink-example'))}`",
                    ]))

                auth_intro = content.find_all("p", recursive=False)
                if len(auth_intro) > 1:
                    parts.append(fragment_to_markdown(auth_intro[1]))

                for panel in content.select(".client-content"):
                    heading = "TypeScript Example" if panel.get("data-client-panel") == "typescript" else "Python Example"
                    code_block = panel.select_one(".code-block")
                    if code_block:
                        parts.append(render_code_block(code_block, heading))

            elif title == "Start querying data":
                for panel in content.select(".client-content"):
                    heading = "TypeScript Example" if panel.get("data-client-panel") == "typescript" else "Python Example"
                    code_block = panel.select_one(".code-block")
                    if code_block:
                        parts.append(render_code_block(code_block, heading))

            section.append(join_blocks(parts))

        blocks.append(join_blocks(section))

    notes = soup.select_one(".dev-notes")
    if notes:
        lines = []
        for card in notes.select(".dev-note-card"):
            badge = text_from(card.select_one(".dev-note-badge"))
            title = text_from(card.find("h3"))
            description = fragment_to_markdown(card.find("p"))
            lines.append(f"- **{badge} - {title}:** {description}")
        blocks.append(join_blocks([
            f"## {text_from(notes.find('h2'))}",
            text_from(notes.select_one(".section-header p")),
            "\n".join(lines),
        ]))

    http_api = soup.select_one(".dev-http-api")
    if http_api:
        lines = []
        for card in http_api.select(".dev-note-card"):
            badge = text_from(card.select_one(".dev-note-badge"))
            title = text_from(card.find("h3"))
            description = fragment_to_markdown(card.find("p"))
            lines.append(f"- **{badge} - {title}:** {description}")
        blocks.append(join_blocks([
            f"## {text_from(http_api.find('h2'))}",
            text_from(http_api.select_one(".section-header p")),
            "\n".join(lines),
        ]))

    tools = soup.select_one(".dev-tools")
    if tools:
        lines = []
        for card in tools.select(".dev-tool-card"):
            lines.append(f"- `{text_from(card.find('h3'))}`: {fragment_to_markdown(card.find('p'))}")
        reference_link = list_links(tools.select(".dev-swagger-cta a"))
        blocks.append(join_blocks([
            f"## {text_from(tools.find('h2'))}",
            text_from(tools.select_one(".section-header p")),
            "\n".join(lines),
            reference_link,
        ]))

    return join_blocks(blocks)


def render_faq_items(items, heading_level: int = 2) -> list[str]:
    blocks = []
    prefix = "#" * heading_level
    for item in items:
        question = text_from(item.find("summary"))
        answer = item.select_one(".faq-answer")
        if answer is None:
            continue
        answer_blocks = [f"{prefix} {question}"]
        for child in answer.children:
            if isinstance(child, NavigableString):
                continue
            if child.name == "p":
                answer_blocks.append(fragment_to_markdown(child))
            elif child.name in {"ul", "ol"}:
                answer_blocks.append(render_list(child))
        blocks.append(join_blocks(answer_blocks))
    return blocks


def render_faq(soup: BeautifulSoup) -> str:
    hero = soup.select_one(".faq-hero")
    blocks = [
        f"# {text_from(hero.find('h1'))}",
        text_from(hero.select_one(".hero-subtitle")),
    ]

    sections = soup.select(".faq-list .faq-section")
    if sections:
        for section in sections:
            title = section.select_one(".faq-section-title")
            if title:
                blocks.append(f"## {text_from(title)}")
            blocks.extend(render_faq_items(section.select("details"), heading_level=3))
    else:
        blocks.extend(render_faq_items(soup.select(".faq-list > details"), heading_level=2))

    return join_blocks(blocks)


def render_generic(soup: BeautifulSoup) -> str:
    main = soup.find("main") or soup.find("body") or soup
    return fragment_to_markdown(main)


RENDERERS = {
    "about": render_about,
    "chatgpt-setup": render_chatgpt_setup,
    "claude-bundle-setup": render_claude_bundle_setup,
    "developers": render_developers,
    "faq": render_faq,
    "mcp-setup": render_mcp_setup,
}


def html_to_md(html_path: Path) -> str:
    soup = BeautifulSoup(html_path.read_text(encoding="utf-8"), "html.parser")

    for tag in soup.find_all(["nav", "footer", "script", "style"]):
        tag.decompose()

    renderer = RENDERERS.get(html_path.stem, render_generic)
    return normalize_markdown(renderer(soup))


def page_heading(markdown: str, fallback: str) -> str:
    for line in markdown.splitlines():
        if line.startswith("# "):
            return line
    return f"# {fallback}"


def _fetch_json(url: str) -> dict | None:
    try:
        req = urllib.request.Request(url, headers={
            "Accept": "application/json",
            "User-Agent": "vytallink-build/1.0",
        })
        with urllib.request.urlopen(req, timeout=15) as resp:
            return json.loads(resp.read())
    except Exception as exc:
        print(f"Warning: failed to fetch {url}: {exc}")
        return None


# Developer-friendly conversion notes that supplement the raw API description.
# These are applied after parsing to give developers the context they need
# to interpret values correctly without needing to make trial API calls.
_NOTES_ENRICHMENT: dict[str, str] = {
    "SLEEP": "avg minutes per night when using AVERAGE statistic. Divide by 60 to get hours (e.g. 396 min → 6.6h)",
    "DISTANCE": "value in meters. Divide by 1000 for km (e.g. 117666 → 117.7 km)",
    "EXERCISE_TIME": "minutes of exercise. May return empty (count: 0) depending on the user's device. Check count before using",
    "WORKOUT": "object with fields: session_count (int), total_energy_burned (kcal), total_distance (meters), total_steps (int), workout_type (string). NOT a number — requires special parsing",
    "CALORIES": "total and active calories burned, in kcal",
}


def _parse_units_table(description: str) -> list[tuple[str, str, str, str]]:
    """Parse metric entries from the value_type description.

    Handles two patterns:
    - Standard: 'METRIC (description — unit: UNIT)'
    - Special:  'METRIC (description — NOTES)' (for WORKOUT, BODY_METRICS, etc.)
    """
    rows: list[tuple[str, str, str, str]] = []
    for match in re.finditer(
        r"(\b[A-Z][A-Z_]+)\s*\(([^)]+)\)",
        description,
    ):
        metric = match.group(1)
        inner = match.group(2).strip()
        # Try to extract unit from "description — unit: UNIT" pattern
        unit_match = re.search(r"(?:—|--|-)\s*unit(?:s)?:\s*(.+)", inner)
        if unit_match:
            raw_unit = unit_match.group(1).strip().rstrip(",. ")
            # Some units have extra context after a semicolon (e.g. SLEEP),
            # keep only the unit name itself.
            unit = raw_unit.split(";")[0].strip()
            desc = inner[:unit_match.start()].strip().rstrip(",. —-")
            value_type = "number"
        elif metric == "WORKOUT":
            unit = "noUnit"
            # Capture everything after the em-dash as the description since
            # it contains the field list ("value is an object with fields: …")
            parts = inner.split("—", 1)
            desc = parts[1].strip().rstrip(",. ") if len(parts) > 1 else inner
            value_type = "**object**"
        else:
            # Metrics like BODY_METRICS with "units vary"
            parts = inner.split("—", 1)
            desc = parts[0].strip().rstrip(",. ")
            unit = parts[1].strip().rstrip(",. ") if len(parts) > 1 else "varies"
            value_type = "number"
        # Apply developer-friendly enrichment notes where defined
        desc = _NOTES_ENRICHMENT.get(metric, desc)
        rows.append((metric, unit, value_type, desc))
    return rows


def _format_example(key: str, example: dict) -> str:
    """Format an OpenAPI example as a markdown fenced code block."""
    summary = example.get("summary", key)
    value = example.get("value", {})
    json_str = json.dumps(value, indent=2, ensure_ascii=False)
    return f"**{summary}:**\n\n```json\n{json_str}\n```"


def generate_mcp_reference(base_url: str) -> str | None:
    """Fetch MCP tool definitions and OpenAPI spec, return a markdown reference section."""
    tools_data = _fetch_json(f"{base_url}/mcp/tools")
    openapi_data = _fetch_json(f"{base_url}/docs/mcp/openapi.json")

    if not tools_data or not openapi_data:
        return None

    tools = tools_data.get("tools", [])
    health_tool = next((t for t in tools if t["name"] == "get_health_metrics"), None)
    if not health_tool:
        print("Warning: get_health_metrics tool not found in /mcp/tools response")
        return None

    blocks: list[str] = ["# MCP API Reference"]

    # --- Response format (static text) ---
    blocks.append(join_blocks([
        "## Response format",
        (
            "Every tool response has two fields:\n"
            "- `content[0].text`: human-readable summary for LLMs\n"
            "- `structuredContent`: full JSON payload — **always read from here when parsing programmatically**\n\n"
            "The shape of `structuredContent` depends on the tool:\n"
            "- `get_health_metrics` / `get_summary`: `{ healthData, count, success }`\n"
            "- `direct_login`: `{ success, access_token, token_type, expires_in, user_id, message }`\n\n"
            "**direct_login response example:**\n"
            "```json\n"
            "{\n"
            '  "content": [{ "type": "text", "text": "Authentication successful! You are now logged in." }],\n'
            '  "structuredContent": {\n'
            '    "success": true,\n'
            '    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",\n'
            '    "token_type": "Bearer",\n'
            '    "expires_in": 7200\n'
            "  }\n"
            "}\n"
            "```\n"
            "The token is always in `structuredContent.access_token`. It is not in `content[0].text`.\n\n"
            "**healthData record fields** (for `get_health_metrics` and `get_summary`):\n"
            "- `type` (string): metric type, e.g. `STEPS`, `SLEEP_SESSION`, `WORKOUT`\n"
            "- `value` (number or object): the metric value — number for most metrics, object for WORKOUT\n"
            "- `unit` (string): unit of measurement, e.g. `count`, `minute`, `meter`\n"
            "- `date_from` (ISO 8601): start of the measurement period — **field is `date_from`, not `startDate` or `start_time`**\n"
            "- `date_to` (ISO 8601): end of the measurement period\n"
            "- `source_id` (string): identifies the app or device that recorded the data (e.g. `com.apple.health`, `com.google.android.apps.fitness`)"
        ),
    ]))

    # --- get_health_metrics call example (exact parameter names) ---
    blocks.append(join_blocks([
        "## get_health_metrics parameters",
        (
            "Required: `value_type`, `start_time`, `end_time`. Optional: `group_by`, `statistic`.\n\n"
            "**Parameter names are exact — do not use aliases** (`metric_type`, `start_date`, `end_date`, `aggregation` are not valid).\n\n"
            "```json\n"
            "{\n"
            '  "name": "get_health_metrics",\n'
            '  "arguments": {\n'
            '    "value_type": "STEPS",\n'
            '    "start_time": "2026-01-01T00:00:00Z",\n'
            '    "end_time": "2026-01-31T23:59:59Z",\n'
            '    "group_by": "DAY",\n'
            '    "statistic": "SUM"\n'
            "  }\n"
            "}\n"
            "```"
        ),
    ]))

    # --- Units per metric (parsed from tool definition) ---
    value_type_desc = (
        health_tool.get("inputSchema", {})
        .get("properties", {})
        .get("value_type", {})
        .get("description", "")
    )
    rows = _parse_units_table(value_type_desc)
    if rows:
        table_lines = [
            "| value_type | Unit | value field type | Notes |",
            "|-----------|------|-----------------|-------|",
        ]
        for metric, unit, vtype, notes in rows:
            table_lines.append(f"| {metric} | {unit} | {vtype} | {notes} |")
        blocks.append(join_blocks(["## Units per metric", "\n".join(table_lines)]))

    # --- Response examples (from OpenAPI spec) ---
    examples = (
        openapi_data.get("paths", {})
        .get("/mcp/call", {})
        .get("post", {})
        .get("responses", {})
        .get("200", {})
        .get("content", {})
        .get("application/json", {})
        .get("examples", {})
    )
    health_examples = {
        k: v for k, v in examples.items() if k.startswith("healthMetrics")
    }
    if health_examples:
        example_blocks = ["## Response examples"]
        for key, example in health_examples.items():
            example_blocks.append(_format_example(key, example))
        blocks.append(join_blocks(example_blocks))

    # --- Device availability notes (static text) ---
    blocks.append(join_blocks([
        "## Device availability notes",
        (
            "Not all devices report all metrics. EXERCISE_TIME and MINDFULNESS are commonly unavailable. "
            "When count is 0 and healthData is empty, the metric is not tracked by the user's device. "
            "Handle this gracefully in your integration.\n\n"
            "**Multiple sources per time period:** A single call can return multiple entries in `healthData` "
            "for the same time period — one per `source_id` (e.g. Google Fit, heytap health, Apple Health). "
            "Do not sum across sources. Pick the `source_id` with the most entries and use only those values. "
            "Summing all entries will produce inflated totals."
        ),
    ]))

    return join_blocks(blocks)


def main() -> None:
    all_md: list[str] = []
    pages = sorted(f.stem for f in PUBLIC.glob("*.html") if f.stem not in EXCLUDE)

    for page in pages:
        html_file = PUBLIC / f"{page}.html"
        md = html_to_md(html_file)

        out = PUBLIC / f"{page}.md"
        out.write_text(md + "\n", encoding="utf-8")
        all_md.append(md)
        print(f"Generated {out.name}")

    api_url = os.environ.get("VYTALLINK_API_URL")
    if api_url:
        mcp_ref = generate_mcp_reference(api_url.rstrip("/"))
        if mcp_ref:
            all_md.append(mcp_ref)
            print("Generated MCP API Reference section from backend")
    else:
        print("Skipping MCP API Reference (VYTALLINK_API_URL not set)")

    full_path = PUBLIC / "llms-full.txt"
    full_path.write_text("\n\n---\n\n".join(all_md) + "\n", encoding="utf-8")
    print(f"Generated {full_path.name}")


if __name__ == "__main__":
    main()
