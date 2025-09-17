# This script copies the correct GoogleService-Info.plist depending on the build configuration.
# Place this script in your iOS project and add it as a Run Script Build Phase in Xcode.

PLIST_SRC_PATH="${PROJECT_DIR}/Runner/GoogleService-Info.plist"
if [ "$CONFIGURATION" == "Dev" ]; then
  PLIST_SRC_PATH="${PROJECT_DIR}/Runner/Dev/GoogleService-Info.plist"
fi

PLIST_DEST_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

cp -r "$PLIST_SRC_PATH" "$PLIST_DEST_PATH"
echo "Copied $PLIST_SRC_PATH to $PLIST_DEST_PATH"
