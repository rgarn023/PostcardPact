# Android Build Blockers

Generated from the current cloud development environment while preparing the
Postcard Pact offline prototype for debug APK export.

**Result: APK was NOT created.** No ZIP/PCK file is being presented as an APK.

## Detected toolchain status

| Requirement | Detected value |
|---|---|
| Godot executable | **NOT FOUND** |
| Godot version | **NOT AVAILABLE** |
| Godot 4.7.1 export templates | **NOT FOUND** (`~/.local/share/godot/export_templates/4.7.1.stable` missing) |
| Java | OpenJDK **21.0.10** at `/usr/bin/java` |
| Java SDK / JAVA_HOME | Runtime present; `JAVA_HOME` unset. JDK root: `/usr/lib/jvm/java-21-openjdk-amd64` |
| Preferred OpenJDK 17 | **NOT INSTALLED** |
| Android SDK path | **NOT FOUND** (`ANDROID_HOME` / `ANDROID_SDK_ROOT` empty; no `~/Android/Sdk`) |
| `adb` | **NOT FOUND** |
| Android SDK build-tools / platform-tools | **NOT FOUND** |
| Export preset `Android` | Present in `export_presets.cfg` |
| Target APK path | `build/PostcardPact-0.1.0-debug.apk` — **does not exist** |

## Missing requirements

1. Godot Engine **4.7.1** editor/binary for Linux
2. Godot **4.7.1 Android export templates**
3. Android SDK (command-line tools, platform-tools, build-tools, platform android API)
4. `adb` (usually via platform-tools)
5. OpenJDK **17** preferred (OpenJDK 21 is installed and may work, but Godot docs often recommend 17)

This environment policy forbids downloading/installing system software without
explicit permission, so these components were not installed automatically.

## Precise steps to perform on your machine (Godot 4.7.1)

1. Install Godot 4.7.1 from https://godotengine.org/download
2. Open Godot → **Editor → Manage Export Templates → Download and Install** for 4.7.1
3. Install OpenJDK 17 (recommended) and Android SDK / platform-tools
4. In Godot, open this project folder (contains `project.godot`)
5. **Project → Export…**
6. Select preset **Android**
   - Application / Package: `com.postcardpact.prototype`
   - Name: `Postcard Pact`
   - Version name: `0.1.0`
   - Version code: `1`
   - Orientation: Portrait
   - Use debug export (no release keystore required for debug)
7. Set export path to: `build/PostcardPact-0.1.0-debug.apk`
8. Click **Export Project** (debug), or run the command below

Optional editor one-time Android setup:

- **Editor → Editor Settings → Export → Android**
- Set Android SDK path
- Install/configure debug keystore if prompted (Godot can create a debug keystore)

## Exact command to rerun afterward

From the project root:

```bash
chmod +x scripts/build/check_toolchain.sh scripts/build/export_android.sh
./scripts/build/check_toolchain.sh
./scripts/build/export_android.sh
```

Or directly:

```bash
mkdir -p build
godot --headless --path . --export-debug "Android" build/PostcardPact-0.1.0-debug.apk
```

If your binary is not on `PATH`:

```bash
export GODOT_BIN="/absolute/path/to/Godot_v4.7.1-stable_linux.x86_64"
./scripts/build/export_android.sh
```

## Permission request

If you want this cloud agent to download a portable Godot 4.7.1 binary and/or
Android command-line tools into the workspace and retry the export, reply with
explicit permission to download those tools.
