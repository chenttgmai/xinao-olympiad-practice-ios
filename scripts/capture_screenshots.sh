#!/usr/bin/env bash
set -euo pipefail

PROJECT="信息奥赛练习大全-信奥准备-标准题型.xcodeproj"
SCHEME="信息奥赛练习大全-信奥准备-标准题型"
BUNDLE_ID="macbookair31f.------------------"
LOCALE="${LOCALE:-zh-Hans}"
APPLE_LOCALE="${APPLE_LOCALE:-zh_Hans}"
IPHONE_UDID="${IPHONE_UDID:-A74117E3-87A2-40DC-9E25-B230EFF5FE54}"
IPAD_UDID="${IPAD_UDID:-A0F9CE56-E666-4C15-953B-51FE85711820}"
DERIVED_DATA="${DERIVED_DATA:-build/ScreenshotDerivedData}"
OUTPUT_DIR="${OUTPUT_DIR:-fastlane/screenshots/${LOCALE}}"

SCREENS=(
  "01-home:dashboard"
  "02-practice:practice"
  "03-review:review"
  "04-reference:reference"
  "05-pitfalls:pitfall"
)

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_DIR"/*.png

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$DERIVED_DATA" \
  build

APP_PATH="$(find "$DERIVED_DATA/Build/Products" -path "*/Debug-iphonesimulator/${SCHEME}.app" -type d -print -quit)"
if [[ -z "$APP_PATH" ]]; then
  echo "Built app not found in $DERIVED_DATA/Build/Products" >&2
  exit 1
fi

capture_device() {
  local udid="$1"
  local prefix="$2"

  xcrun simctl boot "$udid" >/dev/null 2>&1 || true
  xcrun simctl bootstatus "$udid" -b
  xcrun simctl uninstall "$udid" "$BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl install "$udid" "$APP_PATH"

  for screen in "${SCREENS[@]}"; do
    local name="${screen%%:*}"
    local tab="${screen##*:}"
    local output_path
    output_path="$(pwd)/${OUTPUT_DIR}/${prefix}_${name}.png"

    xcrun simctl terminate "$udid" "$BUNDLE_ID" >/dev/null 2>&1 || true
    xcrun simctl launch "$udid" "$BUNDLE_ID" \
      -FASTLANE_SNAPSHOT YES \
      -ScreenshotMode YES \
      -ScreenshotTab "$tab" \
      -AppleLanguages "(${LOCALE})" \
      -AppleLocale "$APPLE_LOCALE"
    sleep 2
    xcrun simctl io "$udid" screenshot "$output_path"
  done
}

capture_device "$IPHONE_UDID" "iPhone"
capture_device "$IPAD_UDID" "iPad"

python3 - <<'PY'
from pathlib import Path
root = Path("fastlane/screenshots/zh-Hans")
png = sorted(root.glob("*.png"))
iphone = [p for p in png if p.name.startswith("iPhone_")]
ipad = [p for p in png if p.name.startswith("iPad_")]
print(f"screenshots={len(png)} iphone={len(iphone)} ipad={len(ipad)}")
if len(png) != 10 or len(iphone) != 5 or len(ipad) != 5:
    raise SystemExit("Expected 5 iPhone and 5 iPad screenshots")
PY
