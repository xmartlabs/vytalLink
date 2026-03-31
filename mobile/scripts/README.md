# Scripts Overview

Utility scripts that streamline common tasks for the VytalLink mobile app. All commands assume you run them from the `mobile/` directory unless otherwise noted.

| Script                        | Purpose                                                                                                                                                 | Typical Usage                                                            |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `build_binaries.sh`           | Interactive helper to build signed Android APKs and iOS IPAs for either dev or prod flavors.                                                            | `./scripts/build_binaries.sh`                                            |
| `checks.sh`                   | Runs the full local quality gate: sorts ARB files, enforces formatting, runs Flutter analyzer, Dart Code Metrics, and lints the design-system packages. | `./scripts/checks.sh` before every PR                                    |
| `checks_using_fastlane.sh`    | Delegates linting, testing, and Android build steps to Fastlane workflows. Useful on CI or when Fastlane is already set up locally.                     | `./scripts/checks_using_fastlane.sh`                                     |
| `clean_up.sh`                 | Cleans the Flutter project, fetches dependencies, and regenerates all build_runner code after model or localization changes.                            | `./scripts/clean_up.sh` whenever generated code might be stale           |
| `copy_secrets.sh`             | Copies Firebase configuration files from `mobile/secrets/` into the required Android and iOS locations. Fails if any required file is missing.          | `./scripts/copy_secrets.sh` after updating secrets                       |
| `integration_test.sh`         | Runs the current MCP integration test entrypoint with `fvm flutter test`. Defaults to `test/integration/health_data_flow_test.dart` and accepts an optional test path override. | `./scripts/integration_test.sh`                                          |
| `project_setup.sh`            | Bootstraps a fresh checkout by installing dependencies, generating flavors, icons, and splash assets.                                                   | `./scripts/project_setup.sh` on first setup or after flavor/icon changes |
| `regenerate_fastlane_docs.sh` | Refreshes Fastlane dependency metadata for the repo plus Android and iOS subfolders.                                                                    | `./scripts/regenerate_fastlane_docs.sh` after updating Fastlane configs  |

## Install Helpers

Additional setup scripts live under `scripts/install/`:

- `install_fvm.sh` — Installs FVM globally and verifies the installation.
- `install_fastlane.sh` — Installs Ruby + Fastlane (Debian/Ubuntu oriented).

Run them with `./scripts/install/<script_name>.sh` if your environment is missing those tools.

## Worktree Credentials

If you need the same ignored credential material in another checkout, use the repository-level helper from the repo root:

```bash
cd /path/to/vytalLink-client
./scripts/setup_wt.sh
```

By default the script uses the current directory as the target and the repo where the script lives as the source. Pass `--target` or `--source` only when you want to override that behavior.
