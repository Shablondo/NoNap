#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DMG_PATH="$ROOT_DIR/.build/NoNap.dmg"

"$ROOT_DIR/Scripts/build-dmg.sh"

MOUNT_DIR="$(mktemp -d "$ROOT_DIR/.build/NoNap-dmg-test.XXXXXX")"
MOUNTED=0
cleanup() {
    if [[ "$MOUNTED" == "1" ]]; then
        hdiutil detach "$MOUNT_DIR" -quiet || true
    fi
    rmdir "$MOUNT_DIR"
}
trap cleanup EXIT

hdiutil attach -readonly -nobrowse -noautoopen -mountpoint "$MOUNT_DIR" "$DMG_PATH"
MOUNTED=1

[[ -d "$MOUNT_DIR/NoNap.app/Contents" ]]
[[ -x "$MOUNT_DIR/NoNap.app/Contents/MacOS/NoNap" ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIconFile' "$MOUNT_DIR/NoNap.app/Contents/Info.plist")" == "NoNap" ]]
[[ -s "$MOUNT_DIR/NoNap.app/Contents/Resources/NoNap.icns" ]]
[[ -L "$MOUNT_DIR/Applications" ]]
[[ "$(readlink "$MOUNT_DIR/Applications")" == "/Applications" ]]

echo "DMG contains NoNap.app with its icon and an Applications shortcut."
