# Postcard Pact

Independent community companion app for manual postcard exchanges, friendship tracking, and future remote-trade planning.

Built with **Godot 4.7.1** and **GDScript**. Offline prototype first. Never connects to Pokémon GO.

## Features in this offline prototype

- Five-tab navigation: Home, Find, Journey, Trades, Profile
- Local profile save/load/reset (`user://profile.json`)
- Region + needed-regions selection
- Prototype match cards from local JSON
- Manual friendship journey checkboxes (saved locally)
- Offline trade-request notes (saved locally; never performs trades)

## Open in Godot

1. Install Godot 4.7.1
2. Import this folder (`project.godot`)
3. Press **F5**

## Android debug export

Preset name: `Android`  
Target: `build/PostcardPact-0.1.0-debug.apk`

```bash
./scripts/build/check_toolchain.sh
./scripts/build/export_android.sh
```

If export cannot run in the current environment, see [`ANDROID_BUILD_BLOCKERS.md`](ANDROID_BUILD_BLOCKERS.md).

## Safety

- No Pokémon GO login
- No passwords
- No precise GPS
- No payments / ads / third-party SDKs
- Matching, friendship, and trade content labeled as prototype / user-reported
