#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "❌ Usage: ./scripts/build_apk.sh [dev|staging|prod]"
  exit 1
fi

flutter build apk --release --dart-define=ENV=$ENV
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/app-$ENV-release.apk
echo "✅ Built APK: build/app/outputs/flutter-apk/app-$ENV-release.apk"
