#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/WoodTools.app"
DMG_ROOT="$DIST_DIR/dmg-root"
RW_DMG_PATH="$DIST_DIR/WoodTools-rw.dmg"
DMG_PATH="$DIST_DIR/WoodTools.dmg"
VOLUME_NAME="WoodTools"
BACKGROUND_NAME="DmgBackground.png"

"$ROOT_DIR/scripts/package_app.sh"

rm -rf "$DMG_ROOT" "$RW_DMG_PATH" "$DMG_PATH"
mkdir -p "$DMG_ROOT/.background"
cp -R "$APP_DIR" "$DMG_ROOT/WoodTools.app"
ln -s /Applications "$DMG_ROOT/Applications"
cp "$ROOT_DIR/Resources/$BACKGROUND_NAME" "$DMG_ROOT/.background/$BACKGROUND_NAME"

hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$DMG_ROOT" \
    -ov \
    -format UDRW \
    "$RW_DMG_PATH"

MOUNT_INFO="$(hdiutil attach "$RW_DMG_PATH" -readwrite -noverify -noautoopen)"
VOLUME_PATH="$(printf '%s\n' "$MOUNT_INFO" | grep "/Volumes/$VOLUME_NAME" | sed 's#.*\(/Volumes/.*\)#\1#' | tail -n 1)"

osascript <<APPLESCRIPT
set volumeName to "$VOLUME_NAME"
set backgroundPath to "$VOLUME_PATH/.background/$BACKGROUND_NAME"
tell application "Finder"
    set desktopBounds to bounds of window of desktop
    set windowWidth to 760
    set windowHeight to 500
    set leftEdge to ((item 3 of desktopBounds) - windowWidth) / 2
    set topEdge to ((item 4 of desktopBounds) - windowHeight) / 2
    tell disk volumeName
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set bounds of container window to {leftEdge, topEdge, leftEdge + windowWidth, topEdge + windowHeight}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 112
        set shows item info of viewOptions to false
        set shows icon preview of viewOptions to true
        set background picture of viewOptions to POSIX file backgroundPath
        set position of item "WoodTools.app" of container window to {185, 265}
        set position of item "Applications" of container window to {575, 265}
        update without registering applications
        delay 1
        close
    end tell
end tell
APPLESCRIPT

sync
hdiutil detach "$VOLUME_PATH"
hdiutil convert "$RW_DMG_PATH" -format UDZO -imagekey zlib-level=9 -o "$DMG_PATH"

rm -rf "$DMG_ROOT" "$RW_DMG_PATH"
echo "$DMG_PATH"
