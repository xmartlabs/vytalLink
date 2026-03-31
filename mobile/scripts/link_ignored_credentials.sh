#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_TARGET="$(cd "$SCRIPT_DIR/../.." && pwd)"

SOURCE_REPO=""
TARGET_REPO="$DEFAULT_TARGET"
declare -a EXTRA_INCLUDE_PATTERNS=()

usage() {
  cat <<'EOF'
Link ignored credential files from a source workspace into a target worktree.

Usage:
  ./mobile/scripts/link_ignored_credentials.sh --source /path/to/source/repo [--target /path/to/worktree] [--include pattern]

Options:
  --source   Source repository/workspace that already has the ignored credentials.
  --target   Target repository/worktree where symlinks should be created. Defaults to the current repo root.
  --include  Additional substring pattern to consider credential-like. Can be passed multiple times.
  --help     Show this help text.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      SOURCE_REPO="$2"
      shift 2
      ;;
    --target)
      TARGET_REPO="$2"
      shift 2
      ;;
    --include)
      EXTRA_INCLUDE_PATTERNS+=("$2")
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$SOURCE_REPO" ]]; then
  echo "--source is required." >&2
  usage >&2
  exit 1
fi

SOURCE_REPO="$(cd "$SOURCE_REPO" && pwd)"
TARGET_REPO="$(cd "$TARGET_REPO" && pwd)"

if [[ ! -d "$SOURCE_REPO/.git" && ! -f "$SOURCE_REPO/.git" ]]; then
  echo "Source path is not a git repository: $SOURCE_REPO" >&2
  exit 1
fi

if [[ ! -d "$TARGET_REPO/.git" && ! -f "$TARGET_REPO/.git" ]]; then
  echo "Target path is not a git repository: $TARGET_REPO" >&2
  exit 1
fi

matches_default_credential_pattern() {
  local relative_path="$1"
  case "$relative_path" in
    *.env|*.private.env|*"/secrets/"*|*"/secrets"|*GoogleService-Info*.plist|*google-services*.json|*keys.properties|*upload_certificate.pem)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_generated_path() {
  local relative_path="$1"
  case "$relative_path" in
    build/*|*/build/*|.dart_tool/*|*/.dart_tool/*|ios/Pods/*|*/ios/Pods/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

matches_extra_pattern() {
  local relative_path="$1"
  if [[ "${#EXTRA_INCLUDE_PATTERNS[@]}" -eq 0 ]]; then
    return 1
  fi

  for pattern in "${EXTRA_INCLUDE_PATTERNS[@]}"; do
    if [[ "$relative_path" == *"$pattern"* ]]; then
      return 0
    fi
  done
  return 1
}

is_credential_like() {
  local relative_path="$1"
  if is_generated_path "$relative_path"; then
    return 1
  fi

  matches_default_credential_pattern "$relative_path" || \
    matches_extra_pattern "$relative_path"
}

is_tracked_in_target() {
  local relative_path="$1"
  git -C "$TARGET_REPO" ls-files --error-unmatch -- "$relative_path" >/dev/null 2>&1
}

safe_link_file() {
  local source_file="$1"
  local relative_path="$2"
  local target_file="$TARGET_REPO/$relative_path"

  if is_tracked_in_target "$relative_path"; then
    echo "Skipping tracked path: $relative_path"
    return
  fi

  mkdir -p "$(dirname "$target_file")"

  if [[ -L "$target_file" ]]; then
    local existing_target
    existing_target="$(readlink "$target_file")"
    if [[ "$existing_target" == "$source_file" ]]; then
      echo "Already linked: $relative_path"
      return
    fi

    echo "Skipping conflicting symlink: $relative_path -> $existing_target"
    return
  fi

  if [[ -e "$target_file" ]]; then
    echo "Skipping existing non-symlink path: $relative_path"
    return
  fi

  ln -s "$source_file" "$target_file"
  echo "Linked: $relative_path"
}

collect_credential_candidates() {
  git -C "$SOURCE_REPO" ls-files --others -i --exclude-standard | while read -r candidate; do
    if [[ -z "$candidate" ]]; then
      continue
    fi

    local source_path="$SOURCE_REPO/$candidate"

    if [[ -d "$source_path" ]]; then
      find "$source_path" -type f | while read -r nested_file; do
        local nested_relative="${nested_file#"$SOURCE_REPO/"}"
        if is_credential_like "$nested_relative"; then
          echo "$nested_relative"
        fi
      done
      continue
    fi

    if is_credential_like "$candidate"; then
      echo "$candidate"
    fi
  done | awk '!seen[$0]++'
}

declare -a CANDIDATES=()
while IFS= read -r candidate; do
  CANDIDATES+=("$candidate")
done < <(collect_credential_candidates)

if [[ "${#CANDIDATES[@]}" -eq 0 ]]; then
  echo "No ignored credential files matched the default patterns."
  exit 0
fi

for relative_path in "${CANDIDATES[@]}"; do
  safe_link_file "$SOURCE_REPO/$relative_path" "$relative_path"
done
