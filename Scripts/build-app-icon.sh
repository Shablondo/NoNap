#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/.build"
WORK_DIR="$(mktemp -d "$BUILD_DIR/NoNap-icon.XXXXXX")"
trap 'rm -rf "$WORK_DIR"' EXIT

ICONSET_DIR="$WORK_DIR/NoNap.iconset"
MASTER_PNG="$ICONSET_DIR/icon_512x512@2x.png"
ICON_PATH="$BUILD_DIR/NoNap.icns"
mkdir -p "$ICONSET_DIR"

swift "$ROOT_DIR/Scripts/render-app-icon.swift" "$MASTER_PNG"

for spec in 16x16:16 16x16@2x:32 32x32:32 32x32@2x:64 128x128:128 128x128@2x:256 256x256:256 256x256@2x:512 512x512:512; do
    name="${spec%%:*}"
    pixels="${spec##*:}"
    sips -z "$pixels" "$pixels" "$MASTER_PNG" --out "$ICONSET_DIR/icon_${name}.png" >/dev/null
done

iconutil -c icns "$ICONSET_DIR" -o "$ICON_PATH"
echo "Created $ICON_PATH"
