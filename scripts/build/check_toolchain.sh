#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

echo "=== Postcard Pact toolchain check ==="
echo "Project root: $ROOT"
echo

find_godot() {
  local candidates=(
    "${GODOT_BIN:-}"
    "godot"
    "godot4"
    "Godot"
    "/usr/local/bin/godot"
    "/usr/bin/godot"
    "$HOME/Godot/Godot_v4.7.1-stable_linux.x86_64"
    "$HOME/godot/Godot_v4.7.1-stable_linux.x86_64"
  )
  for c in "${candidates[@]}"; do
    [[ -z "$c" ]] && continue
    if command -v "$c" >/dev/null 2>&1; then
      command -v "$c"
      return 0
    fi
    if [[ -x "$c" ]]; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

GODOT_PATH="$(find_godot || true)"
if [[ -n "${GODOT_PATH}" ]]; then
  echo "Godot executable: $GODOT_PATH"
  set +e
  GODOT_VERSION="$("$GODOT_PATH" --version 2>&1)"
  GODOT_VER_EXIT=$?
  set -e
  echo "Godot version: ${GODOT_VERSION:-unknown} (exit $GODOT_VER_EXIT)"
else
  echo "Godot executable: NOT FOUND"
  echo "Godot version: NOT AVAILABLE"
fi

TEMPLATE_DIR="${HOME}/.local/share/godot/export_templates"
echo "Export templates dir: $TEMPLATE_DIR"
if [[ -d "$TEMPLATE_DIR" ]]; then
  echo "Export templates entries:"
  ls -1 "$TEMPLATE_DIR" 2>/dev/null || true
  if [[ -d "$TEMPLATE_DIR/4.7.1.stable" ]]; then
    echo "Godot 4.7.1 export templates: FOUND ($TEMPLATE_DIR/4.7.1.stable)"
  else
    echo "Godot 4.7.1 export templates: NOT FOUND"
  fi
else
  echo "Godot 4.7.1 export templates: NOT FOUND (templates directory missing)"
fi

echo
if command -v java >/dev/null 2>&1; then
  echo "Java: $(command -v java)"
  java -version 2>&1 | sed 's/^/  /'
else
  echo "Java: NOT FOUND"
fi
echo "JAVA_HOME=${JAVA_HOME:-}"
if [[ -d /usr/lib/jvm/java-17-openjdk-amd64 ]]; then
  echo "Preferred OpenJDK 17 path: /usr/lib/jvm/java-17-openjdk-amd64 (present)"
elif [[ -d /usr/lib/jvm/java-21-openjdk-amd64 ]]; then
  echo "OpenJDK 17 path: NOT FOUND"
  echo "Detected OpenJDK path: /usr/lib/jvm/java-21-openjdk-amd64"
else
  echo "OpenJDK 17 path: NOT FOUND"
fi

echo
echo "ANDROID_HOME=${ANDROID_HOME:-}"
echo "ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-}"
SDK_PATH="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
if [[ -z "$SDK_PATH" && -d "$HOME/Android/Sdk" ]]; then
  SDK_PATH="$HOME/Android/Sdk"
fi
if [[ -n "$SDK_PATH" && -d "$SDK_PATH" ]]; then
  echo "Android SDK path: $SDK_PATH"
else
  echo "Android SDK path: NOT FOUND"
fi

if command -v adb >/dev/null 2>&1; then
  echo "adb: $(command -v adb)"
  adb version 2>&1 | sed 's/^/  /' || true
else
  echo "adb: NOT FOUND"
fi

echo
if [[ -f "$ROOT/export_presets.cfg" ]] && grep -q '^name="Android"$' "$ROOT/export_presets.cfg"; then
  echo "Android export preset named 'Android': PRESENT in export_presets.cfg"
else
  echo "Android export preset named 'Android': MISSING"
fi

echo
echo "APK target: $ROOT/build/PostcardPact-0.1.0-debug.apk"
if [[ -f "$ROOT/build/PostcardPact-0.1.0-debug.apk" ]]; then
  echo "Existing APK: FOUND ($(wc -c < "$ROOT/build/PostcardPact-0.1.0-debug.apk") bytes)"
else
  echo "Existing APK: NOT FOUND"
fi
