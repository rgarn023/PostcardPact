#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

mkdir -p build

GODOT_BIN="${GODOT_BIN:-}"
if [[ -z "$GODOT_BIN" ]]; then
  for c in godot godot4 Godot \
    "$HOME/Godot/Godot_v4.7.1-stable_linux.x86_64" \
    "$HOME/godot/Godot_v4.7.1-stable_linux.x86_64"; do
    if command -v "$c" >/dev/null 2>&1; then
      GODOT_BIN="$(command -v "$c")"
      break
    fi
    if [[ -x "$c" ]]; then
      GODOT_BIN="$c"
      break
    fi
  done
fi

if [[ -z "${GODOT_BIN}" ]]; then
  echo "ERROR: Godot executable not found. Set GODOT_BIN to the Godot 4.7.1 binary."
  echo "See ANDROID_BUILD_BLOCKERS.md"
  exit 1
fi

OUT="build/PostcardPact-0.1.0-debug.apk"
LOG="build/export-android.log"

echo "Using Godot: $GODOT_BIN"
"$GODOT_BIN" --version || true
echo "Exporting debug APK to $OUT"

set +e
"$GODOT_BIN" --headless --path "$ROOT" --export-debug "Android" "$OUT" 2>&1 | tee "$LOG"
EXIT_CODE=${PIPESTATUS[0]}
set -e

echo "Export exit status: $EXIT_CODE"
if [[ -f "$OUT" ]]; then
  echo "APK created: $OUT"
  echo "APK size bytes: $(wc -c < "$OUT")"
  file "$OUT" || true
else
  echo "APK NOT created."
  echo "Last log lines:"
  tail -n 40 "$LOG" || true
  exit 1
fi

exit "$EXIT_CODE"
