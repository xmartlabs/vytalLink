#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Install dependencies into the same interpreter used to run the generator.
# Homebrew-managed Python may require these flags for user installs.
if ! python3 -c "import html2text, bs4" 2>/dev/null; then
  echo "Installing dependencies..."
  python3 -m pip install --user --break-system-packages html2text beautifulsoup4
fi

python3 "$ROOT_DIR/scripts/generate_md.py"
echo "Done. Run 'firebase serve --only hosting --port 5000' to verify."
