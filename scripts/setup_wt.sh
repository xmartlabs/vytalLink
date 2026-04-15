#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_REPO="$(pwd)"
DRY_RUN=false
SOURCE_WAS_EXPLICIT=false
declare -a EXTRA_INCLUDE_PATTERNS=()

usage() {
  cat <<'EOF'
Link ignored credential files from one local checkout into another checkout.

Usage:
  ./scripts/setup_wt.sh [--target /path/to/worktree] [--source /path/to/source/repo] [--include pattern] [--dry-run]

Options:
  --target   Target checkout where symlinks should be created. Defaults to the current working directory.
  --source   Source checkout that already has the ignored credentials. Defaults to the repo where this script lives.
  --include  Additional substring pattern to treat as credential-like. Can be passed multiple times.
  --dry-run  Print the actions without creating symlinks.
  --help     Show this help text.
EOF
}

canonical_path() {
  local input_path="$1"
  (cd "$input_path" && pwd -P)
}

detect_default_source_repo() {
  local reference_repo="$1"
  local common_dir

  if ! common_dir="$(git -C "$reference_repo" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"; then
    return 1
  fi

  dirname "$common_dir"
}

matches_default_credential_pattern() {
  local relative_path="$1"

  case "$relative_path" in
    .env|.env.local|.env.production|.env.development|*.private.env|*.local.env|*.production.env|*.development.env|\
    *"/secrets/"*|*"/secrets"|*"/credentials/"*|*"/credentials"|\
    *firebase.json|*GoogleService-Info*.plist|*google-services*.json|*serviceAccount*.json|*credentials*.json|\
    *keys.properties|*upload_certificate.pem|*.jks|*.keystore|*.p8|*.pem|*.key)
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
    .git/*|*/.git/*|build/*|*/build/*|.dart_tool/*|*/.dart_tool/*|ios/Pods/*|*/ios/Pods/*|\
    .venv/*|*/.venv/*|.fvm/*|*/.fvm/*|node_modules/*|*/node_modules/*|dist/*|*/dist/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

matches_extra_pattern() {
  local relative_path="$1"
  local pattern

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

  case "$relative_path" in
    *.env.example|*.env.sample|*.env.default|*.example.env|*.sample.env|*.default.env|\
    *cacert.pem|*dummy*.pem|*dummy*.key|*debug.keystore)
      return 1
      ;;
  esac

  matches_default_credential_pattern "$relative_path" || matches_extra_pattern "$relative_path"
}

print_or_link() {
  local source_file="$1"
  local relative_path="$2"
  local target_file="$TARGET_REPO/$relative_path"

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
    echo "Skipping existing path: $relative_path"
    return
  fi

  if [[ "$DRY_RUN" == true ]]; then
    echo "Would link: $relative_path"
    return
  fi

  ln -s "$source_file" "$target_file"
  echo "Linked: $relative_path"
}

collect_credential_candidates() {
  local file_path
  local relative_path

  while IFS= read -r -d '' file_path; do
    relative_path="${file_path#"$SOURCE_REPO/"}"
    if is_credential_like "$relative_path"; then
      echo "$relative_path"
    fi
  done < <(find "$SOURCE_REPO" \
    \( -path "$SOURCE_REPO/.git" -o -path "$SOURCE_REPO/.venv" -o -path "$SOURCE_REPO/.fvm" -o -path "$SOURCE_REPO/node_modules" \) -prune \
    -o -type f -print0)
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      SOURCE_REPO="$2"
      SOURCE_WAS_EXPLICIT=true
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
    --dry-run)
      DRY_RUN=true
      shift
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

SOURCE_REPO="$(canonical_path "$SOURCE_REPO")"
TARGET_REPO="$(canonical_path "$TARGET_REPO")"

if [[ "$SOURCE_WAS_EXPLICIT" == false && "$SOURCE_REPO" == "$TARGET_REPO" ]]; then
  if detected_source_repo="$(detect_default_source_repo "$TARGET_REPO")"; then
    SOURCE_REPO="$(canonical_path "$detected_source_repo")"
  fi
fi

if [[ ! -d "$SOURCE_REPO" ]]; then
  echo "Source path does not exist: $SOURCE_REPO" >&2
  exit 1
fi

if [[ ! -d "$TARGET_REPO" ]]; then
  echo "Target path does not exist: $TARGET_REPO" >&2
  exit 1
fi

if [[ "$SOURCE_REPO" == "$TARGET_REPO" ]]; then
  echo "Source and target resolve to the same path: $SOURCE_REPO. Pass --source or --target to choose different checkouts." >&2
  exit 1
fi

declare -a CANDIDATES=()
while IFS= read -r candidate; do
  CANDIDATES+=("$candidate")
done < <(collect_credential_candidates | awk '!seen[$0]++')

if [[ "${#CANDIDATES[@]}" -eq 0 ]]; then
  echo "No credential-like files matched the configured patterns."
  exit 0
fi

echo "Source checkout: $SOURCE_REPO"
echo "Target checkout: $TARGET_REPO"

if [[ "$DRY_RUN" == true ]]; then
  echo "Running in dry-run mode."
fi

for relative_path in "${CANDIDATES[@]}"; do
  print_or_link "$SOURCE_REPO/$relative_path" "$relative_path"
done
