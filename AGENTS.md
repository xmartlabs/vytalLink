# Repository Guidelines

## Project Structure & Module Organization
- `mobile/`: Flutter app + MCP server; code in `lib/`, design system in `design_system/`, env samples in `environments/`.
- `landing/`: Firebase site with HTML/JS under `public/` and CSS partials in `public/styles/`.
- `mcp-server/`: Node MCP server exported as `@xmartlabs/vytallink-mcp-server`; main file `vytalLink_mcp_server.js`.
- `docs/`: Shared guides (e.g., `CODE_STANDARDS.md`) plus repo-wide references.

## Build, Test, and Development Commands
- `cd mobile && fvm flutter pub get` installs dependencies pinned by `.fvmrc`.
- `cd mobile && fvm flutter run` launches the app on the active device.
- `cd mobile && ./scripts/checks.sh` formats + analyzer + metrics; run before every PR.
- `cd mobile && ./scripts/integration_test.sh` executes the MCP integration flow end-to-end.
- `cd mobile && ./scripts/clean_up.sh` cleans, refetches deps, regenerates build_runner + l10n outputs after model or copy changes.
- `cd landing && firebase serve --only hosting --port 5000` previews updates; `./scripts/build-css.sh` bundles CSS when needed.
- `cd mcp-server && npm install && npm start` starts the standalone server or `npm run install-global` to expose the CLI.

## Coding Style & Naming Conventions
- Follow `docs/CODE_STANDARDS.md`: two-space indent, `dart format`, clean `flutter analyze`.
- Use English identifiers (`lowerCamelCase` members, `UpperCamelCase` types) and `package:` imports under `lib/`.
- Localize UI strings via `lib/l10n/intl_en.arb`, regenerate with `flutter gen-l10n`, avoid hardcoded copy.
- Use the shared `Logger`, prefer `const`/`final`, and rely on design system colors.

## Testing Guidelines
- Co-locate Dart tests with their package (e.g., `mobile/design_system/test`) and name them `<feature>_test.dart`.
- `cd mobile && ./scripts/checks.sh` is mandatory; add focused runs with `fvm flutter test <path>`.
- `cd mobile && ./scripts/integration_test.sh` guards MCP behavior after flow changes.
- Validate landing work with `firebase serve --only hosting`; grow Node coverage under `mcp-server/tests/` and wire it into `npm test` when added.

## Commit & Pull Request Guidelines
- Use `type: short summary (#issue)` in imperative present tense.
- Commit cohesive changes, then rebase or squash before review.
- Describe scope, testing, and linked tickets in PRs; attach screenshots or logs for UX or CLI updates.
- Tag appropriate reviewers and list any follow-up tasks or risks.

## Security & Configuration Tips
- Keep Firebase secrets under `mobile/secrets/` and stage them via `./scripts/copy_secrets.sh`.
- Run Flutter commands through FVM to honor the version in `.fvmrc`.
- Verify `firebase login` and `firebase use` before deploys or hosting commands.
- Seed `.env` files from `mobile/environments/` templates and keep personal copies untracked.
