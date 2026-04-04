#!/usr/bin/env python3
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from generate_md import html_to_md


PUBLIC = Path(__file__).resolve().parents[1] / "public"


class GenerateMarkdownTests(unittest.TestCase):
    def test_chatgpt_page_drops_mockup_artifacts(self) -> None:
        markdown = html_to_md(PUBLIC / "chatgpt-setup.html")

        self.assertIn("## What is vytalLink's Custom GPT?", markdown)
        self.assertIn("- AI that understands health and fitness data", markdown)
        self.assertNotIn("Word health", markdown)
        self.assertNotIn("PIN 123456", markdown)
        self.assertNotIn("__", markdown)

    def test_mcp_page_expands_client_tabs_into_sections(self) -> None:
        markdown = html_to_md(PUBLIC / "mcp-setup.html")

        self.assertIn("## Claude Desktop", markdown)
        self.assertIn("## Cursor", markdown)
        self.assertIn("## VS Code", markdown)
        self.assertIn("## Other MCP Clients", markdown)
        self.assertNotIn("Claude Desktop  Cursor  VS Code", markdown)
        self.assertNotIn("__", markdown)

    def test_developers_page_keeps_labeled_code_examples(self) -> None:
        markdown = html_to_md(PUBLIC / "developers.html")

        self.assertIn("#### TypeScript Example", markdown)
        self.assertIn("#### Python Example", markdown)
        self.assertIn("```typescript", markdown)
        self.assertIn("```python", markdown)
        self.assertNotIn("Copy", markdown)
        self.assertNotIn("__Developer's agent", markdown)

    def test_faq_page_uses_conservative_privacy_wording(self) -> None:
        markdown = html_to_md(PUBLIC / "faq.html")

        self.assertIn("## Who receives my data during a session?", markdown)
        self.assertNotIn("configured to not use your data for training", markdown)
        self.assertNotIn("completely anonymous", markdown)
        self.assertNotIn("no data is stored", markdown)
        self.assertNotIn("›", markdown)


if __name__ == "__main__":
    unittest.main()
