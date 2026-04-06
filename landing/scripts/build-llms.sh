#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

VENV_DIR="$ROOT_DIR/.build-llms-venv"
PYTHON_BIN="$VENV_DIR/bin/python"

# Install dependencies into an isolated virtual environment.
# This avoids relying on ambient pip behavior (e.g. --break-system-packages support).
if [ ! -x "$PYTHON_BIN" ]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

if ! "$PYTHON_BIN" -c "import html2text, bs4" 2>/dev/null; then
  echo "Installing dependencies..."
  "$PYTHON_BIN" -m pip install "html2text==2024.2.26" "beautifulsoup4==4.12.3"
fi

# VYTALLINK_API_URL defaults to production. Override for local/staging builds.
VYTALLINK_API_URL="${VYTALLINK_API_URL:-https://api.vytallink.xmartlabs.com}" \
    "$PYTHON_BIN" "$ROOT_DIR/scripts/generate_md.py"
echo "Done. Run 'firebase serve --only hosting --port 5000' to verify."
