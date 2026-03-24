## ci.yml

Unified CI workflow for the monorepo. Runs on every pull request and on pushes to `main`.

A `changes` job detects which paths were modified, and downstream jobs only run if their relevant paths changed:

- **`flutter_build`** — runs on `macos-latest` when `mobile/**` or `.fvmrc` changes. Installs dependencies via Fastlane, runs lints, Flutter tests, checks generated code, and builds a debug Android APK.
- **`mcp_server_check`** — runs on `ubuntu-latest` when `mcp-server/**` or `examples/**` changes. Installs dependencies and validates JavaScript syntax.
- **`examples_ts_build`** — runs on `ubuntu-latest` when `mcp-server/**` or `examples/**` changes. Installs dependencies and builds the TypeScript example.
- **`examples_py_check`** — runs on `ubuntu-latest` when `mcp-server/**` or `examples/**` changes. Installs dependencies, compiles Python sources, and runs unit tests.

## flutter-production-cd.yml

CD workflow triggered when a PR is merged into `main`. Calculates the next build number, then deploys to TestFlight (iOS) and Google Play (Android) in parallel.

### Secrets required

```
GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS_CONTENT
FIREBASE_SERVICE_ACCOUNT_CREDENTIALS_BASE_64
IOS_DIST_CERTIFICATE_BASE_64
DIST_CERTIFICATE_PASSWORD
APPSTORE_CONNECT_API_KEY_ID
APPSTORE_CONNECT_API_KEY_ISSUER_ID
APPSTORE_CONNECT_API_KEY_BASE_64
```

## flutter-staging-cd.yml

CD workflow triggered when a PR is merged into `staging`. Calculates the next build number, then deploys to Firebase App Distribution (iOS and Android) in parallel.

### Secrets required

```
GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS_CONTENT
FIREBASE_SERVICE_ACCOUNT_CREDENTIALS_BASE_64
IOS_DIST_CERTIFICATE_BASE_64_CONTENT
IOS_DIST_CERTIFICATE_PASSWORD
APPSTORE_CONNECT_API_KEY_ID
APPSTORE_CONNECT_API_KEY_ISSUER_ID
APPSTORE_CONNECT_API_KEY_BASE_64_CONTENT
```

## pr-title-checker.yml

Validates that PR titles follow the project's commit convention on every PR open, edit, or sync event.
