#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_FILE="$ROOT_DIR/public/styles.css"
PARTIALS_DIR="$ROOT_DIR/public/styles"

printf "/* Built bundle — do not edit directly. Edit files in /public/styles */\n" > "$OUT_FILE"

# Concatenate in numeric order
for f in $(ls -1 "$PARTIALS_DIR"/[0-9][0-9]-*.css | sort); do
  printf "\n/* >>> %s <<< */\n" "$(basename "$f")" >> "$OUT_FILE"
  cat "$f" >> "$OUT_FILE"
  printf "\n" >> "$OUT_FILE"
done

echo "Built CSS bundle at $OUT_FILE"
