# Scripts Overview

Utility scripts that streamline common tasks for the VytalLink mobile app. All commands assume you run them from the `mobile/` directory unless otherwise noted.

| Script                        | Purpose                                                                                                                                                 | Typical Usage                                                            |
|-------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `build_binaries.sh`           | Interactive helper to build signed Android APKs and iOS IPAs for either dev or prod flavors.                                                            | `./scripts/build_binaries.sh`                                            |
| `checks.sh`                   | Runs the full local quality gate: sorts ARB files, enforces formatting, runs Flutter analyzer, Dart Code Metrics, and lints the design-system packages. | `./scripts/checks.sh` before every PR                                    |
| `checks_using_fastlane.sh`    | Delegates linting, testing, and Android build steps to Fastlane workflows. Useful on CI or when Fastlane is already set up locally.                     | `./scripts/checks_using_fastlane.sh`                                     |
| `clean_up.sh`                 | Cleans the Flutter project, fetches dependencies, and regenerates all build_runner code after model or localization changes.                            | `./scripts/clean_up.sh` whenever generated code might be stale           |
| `copy_secrets.sh`             | Copies Firebase configuration files from `mobile/secrets/` into the required Android and iOS locations. Fails if any required file is missing.          | `./scripts/copy_secrets.sh` after updating secrets                       |
| `integration_test.sh`         | Launches the integration test suite via `flutter drive` using the dev flavor.                                                                           | `./scripts/integration_test.sh`                                          |
| `project_setup.sh`            | Bootstraps a fresh checkout by installing dependencies, generating flavors, icons, and splash assets.                                                   | `./scripts/project_setup.sh` on first setup or after flavor/icon changes |
| `regenerate_fastlane_docs.sh` | Refreshes Fastlane dependency metadata for the repo plus Android and iOS subfolders.                                                                    | `./scripts/regenerate_fastlane_docs.sh` after updating Fastlane configs  |

## Install Helpers

Additional setup scripts live under `scripts/install/`:

- `install_fvm.sh` — Installs FVM globally and verifies the installation.
- `install_fastlane.sh` — Installs Ruby + Fastlane (Debian/Ubuntu oriented).

Run them with `./scripts/install/<script_name>.sh` if your environment is missing those tools.
