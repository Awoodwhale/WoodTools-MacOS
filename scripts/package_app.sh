#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/WoodTools.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
INSTALL=false

if [[ "${1:-}" == "--install" ]]; then
    INSTALL=true
fi

cd "$ROOT_DIR"
swift build -c release

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
cp "$ROOT_DIR/.build/release/WoodTools" "$MACOS_DIR/WoodTools"
chmod +x "$MACOS_DIR/WoodTools"

if [[ -f "$ROOT_DIR/Resources/WoodTools.icns" ]]; then
    cp "$ROOT_DIR/Resources/WoodTools.icns" "$RESOURCES_DIR/WoodTools.icns"
fi

if [[ -f "$ROOT_DIR/Resources/MenuBarTemplate.png" ]]; then
    cp "$ROOT_DIR/Resources/MenuBarTemplate.png" "$RESOURCES_DIR/MenuBarTemplate.png"
fi

if [[ -f "$ROOT_DIR/Resources/AppIconWood.png" ]]; then
    cp "$ROOT_DIR/Resources/AppIconWood.png" "$RESOURCES_DIR/AppIconWood.png"
fi

cat > "$CONTENTS_DIR/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>WoodTools</string>
    <key>CFBundleIdentifier</key>
    <string>com.wood.woodtools</string>
    <key>CFBundleName</key>
    <string>WoodTools</string>
    <key>CFBundleDisplayName</key>
    <string>WoodTools</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>WoodTools</string>
    <key>CFBundleShortVersionString</key>
    <string>0.1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.developer-tools</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
</dict>
</plist>
PLIST

if [[ "$INSTALL" == true ]]; then
    rm -rf "/Applications/WoodTools.app"
    cp -R "$APP_DIR" "/Applications/WoodTools.app"
    echo "/Applications/WoodTools.app"
else
    echo "$APP_DIR"
fi
