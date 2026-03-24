# Vytallink Agent Examples

Two working examples (TypeScript and Python) that show how to build AI agents on top of the [Vytallink](https://vytallink.xmartlabs.com) MCP server.

## What this repo shows

[Vytallink](https://vytallink.xmartlabs.com) exposes wearable metrics (HRV, sleep, training load, recovery) through an [MCP](https://modelcontextprotocol.io/) server (`@xmartlabs/vytallink-mcp-server`). Both examples follow the same pattern:

1. Spawn the Vytallink MCP server as a subprocess
2. Expose its tools to Claude via the Model Context Protocol
3. Let Claude decide when to call tools based on the user's query
4. Run a multi-step agentic loop until the model produces a final answer

The "Athletic Performance Analyst" is one use case built on this pattern. The integration approach works for any domain.

## Architecture

```
CLI → Agent loop → Claude (claude-sonnet-4-6)
                         ↕ tool calls
                  MCP subprocess (Vytallink)
                         ↕ HTTP
                  Vytallink API (health data)
```

## How the code is organized

Each implementation has the same 4-file structure. These are the files to read:

| File | What it does |
|------|--------------|
| `mcp-bridge` | Spawns the Vytallink MCP server as a child process, manages the connection, exposes a `callTool()` interface |
| `agent` | Runs Claude's tool-use loop: sends messages, handles `tool_use` stop reasons, feeds results back, repeats until done |
| `system-prompt` | Defines domain-specific analysis modes (readiness, recovery, training, sleep, chat) |
| `index` / `main` | CLI entry point: parses arguments, prompts for credentials, wires everything together |

| Directory | Language | SDK |
|-----------|----------|-----|
| [`athletic-analyst-ts/`](./athletic-analyst-ts/) | TypeScript | Anthropic SDK |
| [`athletic-analyst-py/`](./athletic-analyst-py/) | Python | Anthropic SDK |

## Vytallink MCP tools

The MCP server exposes these tools for Claude to call:

| Tool | Description |
|------|-------------|
| `direct_login` | Authenticate with the Vytallink API (Word + PIN from the mobile app) |
| `get_health_metrics` | Fetch raw wearable metrics for a date range |
| `get_summary` | Get aggregated health summaries |

Run the discover script in either project to see the full tool catalog:

```bash
# TypeScript
cd athletic-analyst-ts && npm run discover

# Python
cd athletic-analyst-py && python scripts/discover_tools.py
```

By default, the output is saved to your system temp directory at
`$TMPDIR/vytallink-agent-examples/vytallink-tools.json` (or equivalent on
your OS). You can override this with `VYTALLINK_DISCOVERY_OUTPUT`.

## Analysis modes

Both implementations support the same modes:

| Mode | Question it answers | Data window |
|------|---------------------|-------------|
| `readiness` | Should I train hard today? | Today vs. 7-day HRV baseline |
| `recovery` | How is my recovery trending? | 28 days |
| `training` | Am I overtraining? | Acute 7d / Chronic 28d |
| `sleep` | Is sleep supporting performance? | 14 days |
| `chat` | Any free-form question | Variable |

## Prerequisites

- Python 3.11+ (for the Python example)
- Node.js 18+ (for the TypeScript example)
- `ANTHROPIC_API_KEY`
- Vytallink Word + PIN credentials (see below)

## Getting Vytallink credentials

To use these examples you need a Word + PIN from the Vytallink mobile app:

1. Download [VytalLink](https://vytallink.xmartlabs.com) from the [App Store](https://apps.apple.com/app/id6752308627) or [Google Play](https://play.google.com/store/apps/details?id=com.xmartlabs.vytallink)
2. Open the app and connect your wearable data source (Apple Health, Google Fit, etc.)
3. Tap "Get Word + PIN" inside the app
4. Keep the app open while using the agent, the phone acts as a local bridge that streams health data on demand

## Quick start

Use `scripts/repo.sh` for convenience, or follow each project's README directly.

```bash
# Show available commands
./scripts/repo.sh help

# Python setup: create .venv, install deps, seed .env
./scripts/repo.sh setup-py

# TypeScript setup: npm install, build, seed .env
./scripts/repo.sh setup-ts
```

## Running the agents

```bash
# TypeScript
cd athletic-analyst-ts
npm run agent -- --mode readiness

# Python
cd athletic-analyst-py
python -m src.main --mode readiness
```

See each project's README for the full usage guide.

## Running tests

The repo includes an integration test runner that exercises both implementations against the real Vytallink API:

```bash
WORD=<your-word> PIN=<your-pin> ./scripts/repo.sh test-integration
```

Or directly:

```bash
python3 tests/run_tests.py <your-word> <your-pin>
```

## Per-project setup

Each example can be set up independently from its own directory:

- TypeScript: [`athletic-analyst-ts/README.md`](./athletic-analyst-ts/README.md)
- Python: [`athletic-analyst-py/README.md`](./athletic-analyst-py/README.md)
