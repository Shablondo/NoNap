#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT_DIR/Scripts/build-app.sh"

APP_CONTENTS="$ROOT_DIR/.build/NoNap.app/Contents"
ICON_NAME="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIconFile' "$APP_CONTENTS/Info.plist")"
[[ "$ICON_NAME" == "NoNap" ]]

ICON_PATH="$APP_CONTENTS/Resources/$ICON_NAME.icns"
[[ -s "$ICON_PATH" ]]

WORK_DIR="$(mktemp -d "$ROOT_DIR/.build/NoNap-icon-test.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT

iconutil -c iconset "$ICON_PATH" -o "$WORK_DIR/NoNap.iconset"
[[ -s "$WORK_DIR/NoNap.iconset/icon_512x512@2x.png" ]]

echo "App bundle contains a valid 1024px NoNap.icns icon."
