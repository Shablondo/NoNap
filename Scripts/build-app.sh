#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

swift build -c release --product NoNap
BUILD_DIR="$(swift build -c release --show-bin-path)"
APP_DIR="$ROOT_DIR/.build/NoNap.app"

"$ROOT_DIR/Scripts/build-app-icon.sh"

mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cp "$BUILD_DIR/NoNap" "$APP_DIR/Contents/MacOS/NoNap"
cp "$ROOT_DIR/Resources/Info.plist" "$APP_DIR/Contents/Info.plist"
cp "$ROOT_DIR/.build/NoNap.icns" "$APP_DIR/Contents/Resources/NoNap.icns"

# Ad-hoc sign the whole bundle so Gatekeeper sees a valid, sealed
# signature instead of treating the copied binary as damaged.
codesign --force --sign - --timestamp=none "$APP_DIR"
codesign --verify --strict "$APP_DIR"
