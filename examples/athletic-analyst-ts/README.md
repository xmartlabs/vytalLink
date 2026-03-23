# Athletic Performance Analyst (TypeScript)

An AI agent that connects wearable data from [Vytallink](https://vytallink.xmartlabs.com) with Anthropic Claude to produce athletic performance reports.

**Model**: Anthropic Claude
**Analysis modes**: Readiness · Recovery · Training Load · Sleep · Interactive Chat

For an overview of the integration pattern and the Python equivalent, see the [root README](../README.md).

---

## Prerequisites

- Node.js >= 18
- Vytallink Word + PIN (see [Getting Vytallink credentials](../README.md#getting-vytallink-credentials))
- `ANTHROPIC_API_KEY`

---

## Setup

```bash
cd athletic-analyst-ts
npm install
cp .env.example .env   # then edit .env and add your API key

npm run build      # verify the project compiles
npm run discover   # verify connection to Vytallink and list available tools
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
npm run agent -- --mode <mode> [--query "custom question"]
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
| `npm run discover` | Connects to the Vytallink MCP server and lists all available tools (saves to your system temp directory, override with `VYTALLINK_DISCOVERY_OUTPUT`) |
| `npm run agent` | Runs the CLI agent |
| `npm run build` | Compiles TypeScript to `dist/` |

---

## Quick examples

```bash
# Readiness check
npm run agent -- --mode readiness

# 28-day recovery trends
npm run agent -- --mode recovery

# Training load analysis
npm run agent -- --mode training

# Sleep analysis
npm run agent -- --mode sleep

# Interactive chat
npm run agent -- --mode chat

# Custom query on a specific mode
npm run agent -- --mode training --query "Am I ready for a 10K race this Saturday?"
```

---

## Project structure

```
athletic-analyst-ts/
├── src/
│   ├── index.ts           # CLI entry point, arg parsing, chat loop
│   ├── agent.ts           # Agent loop (Anthropic SDK + MCP tools)
│   ├── mcp-bridge.ts      # Spawns and manages the Vytallink MCP subprocess
│   ├── system-prompt.ts   # Mode-specific system prompts and AnalysisMode types
│   ├── test-config.ts     # Test-mode flags and helpers (integration tests only)
│   ├── execution-trace.ts # Execution tracing (test mode only)
│   └── line-reader.ts     # Readline wrapper for TTY and piped stdin
├── scripts/
│   └── discover-tools.ts  # Connects to MCP and dumps available tools
├── test/
│   └── line-reader.test.ts
├── .env                   # API keys (not committed)
├── .env.example           # Template, copy to .env and fill in your key
├── package.json
└── tsconfig.json
```
