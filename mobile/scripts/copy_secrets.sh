#!/bin/bash
# Script to copy sensitive files to their correct locations

# Required files
REQUIRED_FILES=(
  "env/secrets/google-services.json"
  "env/secrets/GoogleService-Info.dev.plist"
  "env/secrets/GoogleService-Info.prod.plist"
)

# Check if all required files exist
for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo "Error: Missing required file $FILE. Place the secrets inside 'env/secrets' under the mobile/ folder."
    exit 1
  fi
done

# ANDROID
cp env/secrets/google-services.json android/app/google-services.json

# IOS
cp env/secrets/GoogleService-Info.dev.plist ios/Runner/Dev/GoogleService-Info.plist
cp env/secrets/GoogleService-Info.prod.plist ios/Runner/GoogleService-Info.plist

echo "Secrets copied successfully."
