# Athletic Performance Analyst (Python)

An AI agent that connects wearable data from [Vytallink](https://vytallink.xmartlabs.com) with Anthropic Claude to produce athletic performance reports.

**Model**: Anthropic Claude
**Analysis modes**: Readiness · Recovery · Training Load · Sleep · Interactive Chat

For an overview of the integration pattern and the TypeScript equivalent, see the [root README](../README.md).

---

## Prerequisites

- Python >= 3.11
- Vytallink Word + PIN (see [Getting Vytallink credentials](../README.md#getting-vytallink-credentials))
- `ANTHROPIC_API_KEY`

---

## Setup

```bash
cd athletic-analyst-py
pip install -r requirements.txt
cp .env.example .env   # then edit .env and add your API key

python scripts/discover_tools.py   # verify connection to Vytallink and list available tools
```

---

## Configuration

`.env`:

```env
ANTHROPIC_API_KEY=your_anthropic_key_here
```

---

## Usage

```bash
python -m src.main --mode <mode> [--query "custom question"]
```

| Flag | Values | Default | Description |
|------|--------|---------|-------------|
| `--mode` | `readiness`, `recovery`, `training`, `sleep`, `chat` | `chat` | Analysis protocol to run |
| `--query` | any string | *(predefined per mode)* | Override the default query for that mode |

Available modes: `readiness`, `recovery`, `training`, `sleep`, `chat`. See [Analysis modes](../README.md#analysis-modes) for details on each one.

---

## Scripts

| Command | What it does |
|---------|-------------|
| `python scripts/discover_tools.py` | Connects to the Vytallink MCP server and lists all available tools (saves to your system temp directory, override with `VYTALLINK_DISCOVERY_OUTPUT`) |
| `python -m src.main` | Runs the CLI agent |

---

## Quick examples

```bash
# Readiness check
python -m src.main --mode readiness

# 28-day recovery trends
python -m src.main --mode recovery

# Training load analysis
python -m src.main --mode training

# Sleep analysis
python -m src.main --mode sleep

# Interactive chat
python -m src.main --mode chat

# Custom query on a specific mode
python -m src.main --mode training --query "Am I ready for a 10K race this Saturday?"
```

---

## Project structure

```
athletic-analyst-py/
├── src/
│   ├── __init__.py
│   ├── main.py            # CLI entry point, arg parsing, chat loop
│   ├── agent.py           # Agent loop (Anthropic SDK + MCP tools)
│   ├── mcp_bridge.py      # Spawns and manages the Vytallink MCP subprocess
│   ├── system_prompt.py   # Mode-specific system prompts and AnalysisMode types
│   ├── test_config.py     # Test-mode flags and helpers (integration tests only)
│   └── execution_trace.py # Execution tracing (test mode only)
├── scripts/
│   └── discover_tools.py  # Connects to MCP and dumps available tools
├── .env                   # API key (not committed)
├── .env.example           # Template, copy to .env and fill in your key
└── requirements.txt
```
