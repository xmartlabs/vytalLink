# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VytalLink is a health data aggregation platform. The mobile app reads wearables data (Apple HealthKit / Google Health Connect) and exposes it via an embedded MCP server. An external Node.js MCP proxy and AI agent examples complete the ecosystem.

## Monorepo Layout

- `mobile/` — Flutter app with embedded MCP server; design tokens in `design_system/`
- `mcp-server/` — Standalone Node.js MCP proxy published as `@xmartlabs/vytallink-mcp-server`
- `examples/` — TypeScript (`athletic-analyst-ts/`) and Python (`athletic-analyst-py/`) CLI agents
- `landing/` — Firebase-hosted static marketing site
- `docs/` — Shared guides (`CODE_STANDARDS.md`, `CONSOLIDATED_GUIDELINES.md`, etc.)

## Commands

### Mobile (Flutter)

```bash
cd mobile && fvm flutter pub get            # install dependencies (Flutter pinned in .fvmrc)
cd mobile && fvm flutter run                # launch on active device
cd mobile && ./scripts/checks.sh            # format + analyze + metrics — MANDATORY before PR
cd mobile && ./scripts/integration_test.sh  # MCP end-to-end integration tests
cd mobile && ./scripts/clean_up.sh          # clean, refetch, regenerate build_runner + l10n
fvm flutter test <path/to/feature_test.dart> # run a single test file
```

### MCP Server (Node.js)

```bash
cd mcp-server && npm install && npm start           # start server
cd mcp-server && npm run install-global             # expose CLI globally
```

### Agent Examples

```bash
# TypeScript
cd examples/athletic-analyst-ts && npm install && npm run build
npx tsx src/index.ts

# Python
cd examples/athletic-analyst-py && python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
python -m src.main --mode <mode>

# Monorepo helpers
cd examples && ./scripts/repo.sh help
cd examples && python3 -m unittest tests/test_run_tests.py  # regression tests
```

### Landing

```bash
cd landing && firebase serve --only hosting --port 5000
cd landing && ./scripts/build-css.sh  # bundle CSS partials → public/styles.css
```

## Architecture

### MCP Bridge Pattern

The TypeScript and Python examples follow the same pattern:

1. `mcp-bridge` spawns the MCP server as a subprocess and manages the tool list + execution retries.
2. `agent` runs a loop (max 15 steps): calls Claude with available tools → if `tool_use`, forwards to bridge → if `end_turn`, returns text.
3. `system-prompt` selects domain-specific instructions by mode (`readiness`, `recovery`, `training`, `sleep`, `chat`).

### Mobile App

- **State**: `flutter_bloc` + `freezed` immutable models throughout.
- **Routing**: `auto_route` — routes are generated, not hand-written.
- **DI**: `get_it` via `DiProvider.init()` as single entry point.
- **MCP server**: `flutter_foreground_task` keeps the embedded HTTP MCP server alive in the background (`lib/core/service/server/`).
- **Health data**: `health` package bridges HealthKit (iOS) and Health Connect (Android).

### MCP Proxy (Node.js)

`vytalLink_mcp_server.js` is a thin proxy: it accepts MCP requests on stdin and forwards them to the backend (`GET /mcp/tools`, `POST /mcp/call`). The backend is the authoritative source of tool definitions. Base URL is configurable via `VYTALLINK_BASE_URL`.

## Dart / Flutter Code Standards

The full spec is in `docs/CODE_STANDARDS.md`. Key rules:

- **English only** — all identifiers, comments, and docs.
- **Localization** — never hardcode UI strings; add keys to `lib/l10n/intl_en.arb` and use `context.localizations.your_key`.
- **Logging** — use `Logger` from `lib/core/common/logger.dart`; no `print()`.
- **Colors/tokens** — use design system only (`context.theme.colorScheme`, `context.theme.customColors`); no hardcoded `Color(0xFF...)`.
- **Opacity** — `color.withValues(alpha: 0.12)`, not `withAlpha(...)`.
- **Imports** — always `package:` imports for code under `lib/`; order: dart/flutter → third-party → local.
- **Widgets** — prefer dedicated `StatelessWidget` classes over private `_build*()` helper methods.
- **Async** — return `Future<void>`, not `void`, for async methods; avoid hiding I/O behind getters.
- **Generated code** — after touching `freezed`, `json_serializable`, or l10n, run `./scripts/clean_up.sh`.
- **Borders** — use `Border.all(...)` with `borderRadius`; non-uniform borders + radius cause rendering errors.

## Testing

- Dart tests live next to their package (e.g., `mobile/design_system/test/`) and are named `<feature>_test.dart`.
- `./scripts/checks.sh` is the quality gate — it runs format, analyze, metrics, and design system lints.
- For MCP behavior changes, run `./scripts/integration_test.sh`.
- Python example regression: `python3 -m unittest tests/test_run_tests.py`.

## Configuration & Secrets

- Flutter version is pinned in `.fvmrc` — always run Flutter through `fvm`.
- Firebase secrets go in `mobile/secrets/`; stage them via `./scripts/copy_secrets.sh`.
- Seed `.env` files from `mobile/environments/` templates; keep personal copies untracked.
- Run `firebase login` and `firebase use` before any hosting commands.

## Commit Format

```
type: short summary (#issue)
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`. Use imperative present tense.
