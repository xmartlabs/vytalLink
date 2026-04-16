# 16 KB Page Size Support for Android

## Context

Google Play requires apps to support 16 KB memory page sizes by May 31, 2026. The app targets SDK 36 and uses Flutter 3.38.4, which already supports 16 KB page alignment. No Flutter or NDK version changes are needed.

## Changes

### 1. `mobile/android/gradle.properties`

Add:

```
android.bundle.enableUncompressedNativeLibs=true
```

Ensures native libraries in the AAB are stored uncompressed and 16 KB-aligned.

### 2. `mobile/android/app/build.gradle`

Add `jniLibs.useLegacyPackaging = false` inside the `android` block:

```groovy
packaging {
    jniLibs {
        useLegacyPackaging = false
    }
}
```

Prevents native library extraction at install time, keeping them page-aligned.

### 3. Verification

- Build a release AAB and check ELF alignment with `check_elf_alignment.sh` or `readelf`.
- Test on an Android 15+ emulator with 16 KB page size enabled.

## Out of Scope

- Plugin updates (only if verification reveals alignment issues)
- iOS changes
- Flutter SDK version changes
