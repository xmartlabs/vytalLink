#!/bin/bash
# Script to copy sensitive files to their correct locations

# Resolve project root relative to this script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

SECRETS_DIR="$PROJECT_ROOT/secrets"

# Required files
REQUIRED_FILES=(
  "$SECRETS_DIR/google-services.json"
  "$SECRETS_DIR/GoogleService-Info.dev.plist"
  "$SECRETS_DIR/GoogleService-Info.prod.plist"
)

# Check if all required files exist
for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo "Error: Missing required file $FILE. Place the secrets inside 'secrets/' under the mobile/ folder."
    exit 1
  fi
done

# ANDROID
cp "$SECRETS_DIR/google-services.json" "$PROJECT_ROOT/android/app/google-services.json"

# IOS
cp "$SECRETS_DIR/GoogleService-Info.dev.plist" "$PROJECT_ROOT/ios/Runner/Dev/GoogleService-Info.plist"
cp "$SECRETS_DIR/GoogleService-Info.prod.plist" "$PROJECT_ROOT/ios/Runner/GoogleService-Info.plist"

echo "Secrets copied successfully."
