#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT_DIR/Scripts/build-app.sh"

APP_PATH="$ROOT_DIR/.build/NoNap.app"
DMG_PATH="$ROOT_DIR/.build/NoNap.dmg"
STAGING_DIR="$(mktemp -d "$ROOT_DIR/.build/NoNap-dmg.XXXXXX")"
trap 'rm -rf "$STAGING_DIR"' EXIT

cp -R "$APP_PATH" "$STAGING_DIR/NoNap.app"
ln -s /Applications "$STAGING_DIR/Applications"

hdiutil create \
    -volname "NoNap" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

echo "Created $DMG_PATH"
