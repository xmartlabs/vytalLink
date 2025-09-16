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
  fvm flutter build ipa --export-method=$EXPORT_METHOD --flavor=$ENV --dart-define=ENV=$ENV
  echo "📂 iOS build generated at: build/ios/ipa"
}

build_android() {
  echo "🤖 Building for Android..."
  fvm flutter build apk --flavor=$ENV --dart-define=ENV=$ENV
  echo "📂 Android build generated at: build/app/outputs/flutter-apk/app-$ENV-release.apk"
}

select_environment
select_platform

if [ "$PLATFORM" == "ios" ]; then
  select_export_method
  build_ios
elif [ "$PLATFORM" == "android" ]; then
  build_android
elif [ "$PLATFORM" == "both" ]; then
  select_export_method
  build_ios
  build_android
fi

echo "✅ Build process completed."
