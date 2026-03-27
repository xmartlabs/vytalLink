"""
Direct MCP tool probe — calls a single tool and checks its result.

Usage (via run_tests.py):
    python -m src.tool_probe --tool get_summary --days 30

Reads word and pin from stdin (same format as the agent scripts).
Exits 0 on success, 1 on failure.
"""

import argparse
import asyncio
import json
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path

from dotenv import load_dotenv

from .mcp_bridge import McpBridge
from .test_config import emit_test_summary

load_dotenv(Path(__file__).parent.parent / ".env")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Direct MCP tool probe")
    parser.add_argument("--tool", required=True, help="Tool name to call")
    parser.add_argument("--days", type=int, default=30, help="Date range in days (default: 30)")
    return parser.parse_args()


def read_credentials() -> tuple[str, str]:
    word = input("  Word: ").strip()
    pin = input("  PIN:  ").strip()
    return word, pin


def build_date_range(days: int) -> tuple[str, str]:
    end = datetime.now(timezone.utc).replace(hour=23, minute=59, second=59, microsecond=0)
    start = (end - timedelta(days=days)).replace(hour=0, minute=0, second=0)
    return start.strftime("%Y-%m-%dT%H:%M:%SZ"), end.strftime("%Y-%m-%dT%H:%M:%SZ")


def check_tool_result(result: dict, tool: str) -> tuple[bool, str]:
    if result.get("is_error"):
        return False, result.get("content", "unknown error")
    content = result.get("content", "")
    try:
        data = json.loads(content)
        if isinstance(data, dict) and data.get("success") is False:
            return False, data.get("error_message", "tool returned success=false")
    except (json.JSONDecodeError, ValueError):
        json_start = content.find("{")
        if json_start != -1:
            try:
                data = json.loads(content[json_start:])
                if isinstance(data, dict) and data.get("success") is False:
                    return False, data.get("error_message", "tool returned success=false")
            except (json.JSONDecodeError, ValueError):
                pass
    if not content:
        return False, "empty response"
    return True, ""


async def main() -> None:
    args = parse_args()

    print(f"\n=== Tool Probe: {args.tool} ===\n")
    word, pin = read_credentials()

    bridge = McpBridge()
    await bridge.connect()

    ok = False
    try:
        login = await bridge.call_tool("direct_login", {"word": word, "code": pin})
        if login.get("is_error"):
            print(f"Authentication failed: {login.get('content')}", file=sys.stderr)
            sys.exit(1)

        start_time, end_time = build_date_range(args.days)

        tool_args: dict = {}
        if args.tool == "get_summary":
            summary_start, summary_end = build_date_range(30)
            tool_args = {
                "start_time": summary_start,
                "end_time": summary_end,
                "metrics": [
                    {"value_type": "STEPS"},
                    {"value_type": "HEART_RATE"},
                    {"value_type": "SLEEP"},
                    {"value_type": "HRV"},
                    {"value_type": "CALORIES"},
                    {"value_type": "EXERCISE_TIME"},
                ],
            }

        result = await bridge.call_tool(args.tool, tool_args)
        ok, reason = check_tool_result(result, args.tool)

        print(result.get("content", ""))

        if not ok:
            print(f"FAIL: {reason}", file=sys.stderr, flush=True)

    finally:
        emit_test_summary(bridge.get_execution_summary())
        await bridge.close()

    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    asyncio.run(main())
