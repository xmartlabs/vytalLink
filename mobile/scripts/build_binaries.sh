#!/bin/bash

select_environment() {
  echo "🌍 Select environment:"
  echo "1) 🌱 Development"
  echo "2) 🚀 Production"
  read -p "Enter your choice (1 or 2): " env_choice

  case $env_choice in
    1)
      ENV="dev"
      ;;
    2)
      ENV="prod"
      ;;
    *)
      echo "❌ Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

select_platform() {
  echo "📱 Select platform:"
  echo "1) 🍎 iOS"
  echo "2) 🤖 Android"
  echo "3) 🌐 Both"
  read -p "Enter your choice (1, 2, or 3): " platform_choice

  case $platform_choice in
    1)
      PLATFORM="ios"
      ;;
    2)
      PLATFORM="android"
      ;;
    3)
      PLATFORM="both"
      ;;
    *)
      echo "❌ Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

select_export_method() {
  echo "📦 Select export method for iOS:"
  echo "1) 🛠 Ad-Hoc"
  echo "2) 🏬 App Store"
  read -p "Enter your choice (1 or 2): " export_choice

  case $export_choice in
    1)
      EXPORT_METHOD="ad-hoc"
      ;;
    2)
      EXPORT_METHOD="app-store"
      ;;
    *)
      echo "❌ Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

build_ios() {
  echo "🍎 Building for iOS with export method: $EXPORT_METHOD..."
  if fvm flutter build ipa --export-method=$EXPORT_METHOD --flavor=$ENV --dart-define=ENV=$ENV; then
    echo "📂 iOS build generated at: build/ios/ipa"
  else
    echo "❌ iOS build failed."
    exit 1
  fi
}

build_android() {
  local artifact=${ANDROID_ARTIFACT:-apk}
  echo "🤖 Building for Android ($artifact)..."

  if [ "$artifact" == "apk" ]; then
    if fvm flutter build apk --flavor=$ENV --dart-define=ENV=$ENV; then
      echo "📂 Android APK generated at: build/app/outputs/flutter-apk/app-$ENV-release.apk"
    else
      echo "❌ Android APK build failed."
      exit 1
    fi
  else
    if fvm flutter build appbundle --flavor=$ENV --dart-define=ENV=$ENV; then
      echo "📂 Android App Bundle generated at: build/app/outputs/bundle/$ENV/app-$ENV-release.aab"
    else
      echo "❌ Android App Bundle build failed."
      exit 1
    fi
  fi
}

select_android_artifact() {
  echo "📦 Select Android artifact:"
  echo "1) 📱 APK"
  echo "2) 🧳 App Bundle (.aab)"
  read -p "Enter your choice (1 or 2): " artifact_choice

  case $artifact_choice in
    1)
      ANDROID_ARTIFACT="apk"
      ;;
    2)
      ANDROID_ARTIFACT="appbundle"
      ;;
    *)
      echo "❌ Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

select_environment
select_platform

if [ "$PLATFORM" == "ios" ]; then
  select_export_method
  build_ios
elif [ "$PLATFORM" == "android" ]; then
  select_android_artifact
  build_android
elif [ "$PLATFORM" == "both" ]; then
  select_export_method
  build_ios
  select_android_artifact
  build_android
fi

echo "✅ Build process completed."
