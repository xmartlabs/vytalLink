"""Discover and list tools exposed by the Vytallink MCP server."""

import asyncio
import json
import os
import sys
import tempfile
from pathlib import Path

# Allow running as `python scripts/discover_tools.py` from athletic-analyst-py/
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

from src.mcp_bridge import build_mcp_environment


def build_output_path() -> Path:
    custom_path = os.getenv("VYTALLINK_DISCOVERY_OUTPUT")
    if custom_path and custom_path.strip():
        return Path(custom_path).expanduser().resolve()

    return Path(tempfile.gettempdir()) / "vytallink-agent-examples" / "vytallink-tools.json"


async def main() -> None:
    print("Connecting to Vytallink MCP server (deployed backend)...")

    server_params = StdioServerParameters(
        command="npx",
        args=["@xmartlabs/vytallink-mcp-server"],
        env=build_mcp_environment(),
    )

    async with stdio_client(server_params) as (read_stream, write_stream):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()
            result = await session.list_tools()
            tools = result.tools

            print(f"Connected. Found {len(tools)} tools:\n")
            for t in tools:
                desc = (t.description or "")[:80]
                print(f"  - {t.name}: {desc}...")

            output_path = build_output_path()
            output_path.parent.mkdir(parents=True, exist_ok=True)

            tools_data = [
                {
                    "name": t.name,
                    "description": t.description,
                    "inputSchema": t.inputSchema,
                }
                for t in tools
            ]
            output_path.write_text(json.dumps(tools_data, indent=2))
            print(f"\nSaved to {output_path}")


if __name__ == "__main__":
    asyncio.run(main())
