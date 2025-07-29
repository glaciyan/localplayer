#!/bin/bash

NO_BUILD=false

for arg in "$@"; do
  if [ "$arg" == "--no-build" ]; then
    NO_BUILD=true
  fi
done

if [ "$NO_BUILD" = false ]; then
  flutter build apk --release
fi

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ ! -f "$APK_PATH" ]; then
  echo "APK not found at $APK_PATH"
  exit 1
fi

cp "$APK_PATH" "./ABGABE_LocalPlayer_JohnathanGallus_ArturChonov_KevinTrautvetter.apk"
