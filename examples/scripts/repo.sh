#!/usr/bin/env sh

set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PY_DIR="$ROOT_DIR/athletic-analyst-py"
TS_DIR="$ROOT_DIR/athletic-analyst-ts"
PY_VENV="$PY_DIR/.venv"
PYTHON_BIN="${PY_VENV}/bin/python"

print_help() {
  cat <<'EOF'
Usage: ./scripts/repo.sh <command>

Commands:
  help              Show available commands
  setup-py          Create a virtualenv and install Python dependencies
  setup-ts          Install TypeScript dependencies and build the project
  build-ts          Compile the TypeScript example
  test-integration  Run the end-to-end test runner (requires WORD and PIN env vars)
EOF
}

require_credentials() {
  : "${WORD:?WORD is required}"
  : "${PIN:?PIN is required}"
}

setup_py() {
  python3 -m venv "$PY_VENV"
  "$PY_VENV/bin/pip" install -r "$PY_DIR/requirements.txt"
  cp -n "$PY_DIR/.env.example" "$PY_DIR/.env" || true
}

setup_ts() {
  cd "$TS_DIR"
  npm install
  cp -n .env.example .env || true
  npm run build
}

build_ts() {
  cd "$TS_DIR"
  npm run build
}

test_integration() {
  require_credentials
  cd "$ROOT_DIR"
  if [ -x "$PYTHON_BIN" ]; then
    "$PYTHON_BIN" tests/run_tests.py "$WORD" "$PIN"
  else
    python3 tests/run_tests.py "$WORD" "$PIN"
  fi
}

COMMAND="${1:-help}"

case "$COMMAND" in
  help)
    print_help
    ;;
  setup-py)
    setup_py
    ;;
  setup-ts)
    setup_ts
    ;;
  build-ts)
    build_ts
    ;;
  test-integration)
    test_integration
    ;;
  *)
    print_help
    exit 1
    ;;
esac
