# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VytalLink is a health data platform. The mobile app reads wearable data from Apple HealthKit and Google Health Connect, then exposes it through an MCP-compatible interface for AI assistants.

## Monorepo Layout

- `mobile/` - Flutter app with embedded MCP server and design system in `design_system/`
- `mcp-server/` - Standalone Node.js MCP proxy published as `@xmartlabs/vytallink-mcp-server`
- `examples/` - TypeScript (`athletic-analyst-ts/`) and Python (`athletic-analyst-py/`) CLI agents
- `landing/` - Static marketing site hosted on Firebase
- `docs/` - Shared guidelines (`CODE_STANDARDS.md`, `CONSOLIDATED_GUIDELINES.md`, and more)

## Build and Development Commands

### Mobile (Flutter)

```bash
cd mobile && fvm flutter pub get                # install dependencies (Flutter pinned in .fvmrc)
cd mobile && fvm flutter run                    # launch on active device
cd mobile && fvm flutter test                   # run all tests
cd mobile && fvm flutter test <path>            # run a single test file
cd mobile && ./scripts/checks.sh                # format + analyze + metrics (mandatory before PR)
cd mobile && ./scripts/integration_test.sh      # MCP end-to-end integration tests
cd mobile && ./scripts/clean_up.sh              # clean, refetch deps, regenerate build_runner + l10n
```

Always use `fvm` for Flutter/Dart commands.

### MCP Server (Node.js)

```bash
cd mcp-server && npm install && npm start       # start server
cd mcp-server && npm run install-global         # expose CLI globally
cd mcp-server && npm run mcpb:package           # build Claude Desktop bundle
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
cd examples && python3 -m unittest tests/test_run_tests.py
```

### Landing

```bash
cd landing && firebase serve --only hosting --port 5000
cd landing && ./scripts/build-css.sh            # bundle CSS partials into public/styles.css
cd landing && firebase deploy --only hosting
```

## Architecture

### Mobile App (Flutter)

Layered architecture with BLoC state management:

- `lib/ui/` - Presentation layer: screens, widgets, routing (`auto_route` + codegen)
- `lib/core/service/` - Service layer: health data, MCP server, shared preferences
- `lib/core/service/server/` - MCP server implementation with WebSocket and foreground service transports
- `lib/core/model/` - Data models using Freezed
- `lib/core/di/` - Dependency injection via GetIt
- `lib/core/common/` - Shared utilities (Logger, Analytics, Config)
- `lib/l10n/` - Localization (`intl_en.arb` as source of truth)

### Agent Examples (TypeScript and Python)

Both examples use the same bridge pattern:

1. `mcp-bridge` spawns the MCP server process and manages tool discovery and execution.
2. `agent` runs a bounded loop: call Claude with tools, execute tool calls, continue until response.
3. `system-prompt` provides mode-specific instructions (`readiness`, `recovery`, `training`, `sleep`, `chat`).

### MCP Proxy (Node.js)

`vytalLink_mcp_server.js` is a thin proxy:

- Receives MCP requests via stdin
- Forwards requests to backend endpoints (`GET /mcp/tools`, `POST /mcp/call`)
- Uses backend as the source of truth for tool definitions
- Supports configurable base URL via `VYTALLINK_BASE_URL`

## Generated Code

**Never edit generated files manually.** Generated files include:

- `*.g.dart` — JSON serialization (json_serializable)
- `*.freezed.dart` — Freezed models
- `*.gr.dart` — auto_route routing
- `*.gen.dart` — flutter_gen assets
- `lib/l10n/app_*.dart` — localization

To regenerate after changing Freezed models, routes, localization, or assets:

```bash
cd mobile && ./scripts/clean_up.sh
```

This cleans the build cache, re-fetches deps, and reruns `build_runner` + l10n generation.

## Code Standards

Full details are in `docs/CODE_STANDARDS.md`. Key rules:

- English only for identifiers, comments, docs, commits
- No hardcoded UI strings; use localization keys in `lib/l10n/intl_en.arb`
- No `print()` in app code; use `Logger` from `lib/core/common/logger.dart`
- No hardcoded colors; use design system tokens
- Prefer `const` and `final`; trailing commas on multiline constructs
- Use `package:` imports for code under `lib/`
- Import order: Dart/Flutter -> third-party -> local
- Async methods should return `Future<void>`
- Prefer dedicated widget classes over private `_build*()` helpers
- Use `color.withValues(alpha: 0.xx)` instead of `withAlpha(...)`

## Testing

- Mobile unit and widget tests: `mobile/test/`
- Design system tests: `mobile/design_system/test/`
- MCP integration tests: `cd mobile && ./scripts/integration_test.sh`
- Quality gate: `cd mobile && ./scripts/checks.sh`
- Example regression tests: `cd examples && python3 -m unittest tests/test_run_tests.py`

## Configuration and Secrets

- Flutter version is pinned in `.fvmrc`; run Flutter commands through `fvm`
- Firebase secrets belong in `mobile/secrets/` and are staged with `./scripts/copy_secrets.sh`
- Seed `.env` files from `mobile/environments/` templates and keep local copies untracked
- Run `firebase login` and `firebase use` before hosting commands

## Git Workflow

- Commit format: `type: short summary (#issue)` (imperative present tense)
- Recommended types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`
- Suggested branch naming: `feat/*`, `fix/*`, `refactor/*`, `chore/*`
- Run `./scripts/checks.sh` before opening PRs
