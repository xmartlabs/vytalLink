# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VytalLink is a health data platform that collects Apple HealthKit / Google Health Connect data and exposes it through an MCP-compatible interface for AI assistants. This is a monorepo with three workspaces:

- **mobile/** — Flutter app with embedded MCP server
- **landing/** — Static marketing site on Firebase Hosting
- **mcp-server/** — Standalone Node.js MCP server (`@xmartlabs/vytallink-mcp-server`)
- **docs/** — Shared documentation and guidelines

## Build & Development Commands

### Mobile (Flutter)
```bash
cd mobile && fvm flutter pub get              # Install dependencies
cd mobile && fvm flutter run                  # Launch on active device
cd mobile && fvm flutter test                 # Run all tests
cd mobile && fvm flutter test <path>          # Run a single test file
cd mobile && ./scripts/checks.sh              # Format + analyze + metrics (run before every PR)
cd mobile && ./scripts/clean_up.sh            # Clean, refetch deps, regenerate code (after model/l10n changes)
cd mobile && ./scripts/integration_test.sh    # MCP integration end-to-end tests
```

**Always use `fvm` to run Flutter/Dart commands** — the pinned version is in `.fvmrc`.

### Landing
```bash
cd landing && firebase serve --only hosting --port 5000   # Local preview
cd landing && firebase deploy --only hosting              # Deploy
```

### MCP Server
```bash
cd mcp-server && npm install && npm start     # Run server
cd mcp-server && npm run mcpb:package         # Build Claude Desktop bundle
```

## Architecture

### Mobile App (Flutter)
**Layered architecture** with BLoC state management:

- **lib/ui/** — Presentation layer: screens, widgets, routing (auto_route with code generation)
- **lib/core/service/** — Service layer: health data, MCP server, shared preferences
- **lib/core/service/server/** — MCP server implementation with WebSocket and foreground service transports
- **lib/core/model/** — Data models using Freezed for immutability + code generation
- **lib/core/di/** — Dependency injection via GetIt service locator
- **lib/core/common/** — Shared utilities (Logger, Analytics, Config)
- **lib/l10n/** — Localization (single source: `intl_en.arb`)
- **design_system/** — Shared design package (colors, gradients, typography, reusable widgets)

### MCP Server (Node.js)
Proxy pattern: receives JSON-RPC 2.0 requests via stdin, delegates tool logic to the backend API (`/mcp/tools`, `/mcp/call` endpoints). Uses ES modules.

## Code Standards

Full details in `docs/CODE_STANDARDS.md`. Key rules:

- **English only** for all code, comments, docs, and commit messages
- **No hardcoded UI strings** — use `context.localizations.your_key` via `AppLocalizations`
- **No `print()`** — use `Logger.d()/.i()/.w()/.e()` from `lib/core/common/logger.dart`
- **No hardcoded colors** — use design system tokens via `context.theme.colorScheme` / `context.theme.customColors`
- **`package:` imports** for all code under `lib/` (no relative paths)
- **`const`/`final`** preferred; trailing commas mandatory on multi-line constructs
- **Import order**: Dart/Flutter core → third-party packages → local project imports
- Use `color.withValues(alpha: 0.XX)` for opacity (not `withAlpha`)
- Prefer dedicated `Widget` classes over `_buildX()` helper methods
- Async methods should return `Future<void>`, not `void`

### Generated Code
After touching Freezed models, routes, or localization, run `./mobile/scripts/clean_up.sh` to regenerate.

### Adding Localized Strings
1. Add key-value to `lib/l10n/intl_en.arb`
2. Run `flutter gen-l10n` (or `./scripts/checks.sh`)
3. Use `context.localizations.your_key`

## Testing

- Unit tests: `mobile/test/unit/`
- Integration tests: `mobile/test/integration/`
- Design system tests: `mobile/design_system/test/`
- Test helpers: `mobile/test/test_utils.dart`, `mobile/test/helpers/test_data_factory.dart`

## Git Workflow

- **Commit format**: `type: short summary (#issue)` — imperative present tense
- **Branch naming**: `feat/*`, `fix/*`, `refactor/*`, `chore/*`
- Run `./scripts/checks.sh` before every PR
- CI runs on every PR: lints, tests, generated code checks, Android debug build
