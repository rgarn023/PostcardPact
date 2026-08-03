# Postcard Pact — Offline Foundation (Phase 1 Start)

This document covers **only** the offline project foundation:
main navigation shell, scene setup, stretch settings, script attachment,
signal wiring, and a test checklist.

Do **not** build profile, matching, journey, or trade features until this
foundation passes the checklist below.

---

## 1. Scenes You Must Create Manually

Create these in the Godot editor. Do not ask the coding agent to generate
`.tscn` files.

| Scene path | Purpose | Required now |
|---|---|---|
| `res://scenes/main/Main.tscn` | App root with bottom navigation and page stack | **Yes** |

Optional empty scene folders already exist for later phases. Leave them empty for now:

- `res://scenes/onboarding/`
- `res://scenes/profile/`
- `res://scenes/regions/`
- `res://scenes/matches/`
- `res://scenes/friendships/`
- `res://scenes/trades/`
- `res://scenes/settings/`
- `res://scenes/components/`

After creating `Main.tscn`, set it as the main scene:

**Project → Project Settings → Application → Run → Main Scene**
→ `res://scenes/main/Main.tscn`

---

## 2. Complete Node Tree for `Main.tscn`

Build exactly this tree. Names are case-sensitive and must match.

```
Main (Control)
├── Background (ColorRect)
├── ContentRoot (MarginContainer)
│   └── PageStack (Control)
│       ├── HomePage (Control)
│       │   └── PageLabel (Label)
│       ├── FindPage (Control)
│       │   └── PageLabel (Label)
│       ├── JourneyPage (Control)
│       │   └── PageLabel (Label)
│       ├── TradesPage (Control)
│       │   └── PageLabel (Label)
│       └── ProfilePage (Control)
│           └── PageLabel (Label)
└── BottomNav (PanelContainer)
    └── NavRow (HBoxContainer)
        ├── HomeButton (Button)
        ├── FindButton (Button)
        ├── JourneyButton (Button)
        ├── TradesButton (Button)
        └── ProfileButton (Button)
```

### Node setup details

#### `Main` — Control
- Layout: Full Rect (anchor presets: Full Rect)
- Attach script: `res://scripts/ui/mobile_navigation.gd`

#### `Background` — ColorRect
- Layout: Full Rect
- Color: deep navy, e.g. `Color(0.07, 0.10, 0.20, 1.0)` (`#121A33`)

#### `ContentRoot` — MarginContainer
- Layout: Full Rect
- Theme Overrides → Constants:
  - `margin_left` = 16
  - `margin_top` = 24
  - `margin_right` = 16
  - `margin_bottom` = 88  
    (leaves room for the bottom navigation bar)

#### `PageStack` — Control
- Layout: Full Rect (inside ContentRoot)
- Clip Contents: On (recommended)

#### Page nodes — Control (`HomePage`, `FindPage`, `JourneyPage`, `TradesPage`, `ProfilePage`)
- Layout: Full Rect
- **Enable Unique Name** for each page node (right-click → Access as Unique Name)
- Initially: only `HomePage` visible; others can start visible or hidden (script will manage visibility)

#### Each `PageLabel` — Label
- Layout: Center or Full Rect with horizontal/vertical center alignment
- Text: set distinctly for testing:
  - HomePage → `Home`
  - FindPage → `Find`
  - JourneyPage → `Journey`
  - TradesPage → `Trades`
  - ProfilePage → `Profile`
- Font size: at least 28 (accessible mobile size)

#### `BottomNav` — PanelContainer
- Anchors: bottom stretch
  - Anchor Left = 0, Top = 1, Right = 1, Bottom = 1
  - Grow Horizontal = Both, Grow Vertical = Begin
  - Offset Top = -72, Offset Bottom = 0
  - Offset Left = 0, Offset Right = 0
- Optional panel self-modulate / style: soft violet, e.g. `#3A2F55`

#### `NavRow` — HBoxContainer
- Layout: Full Rect inside BottomNav
- Alignment: Center
- Separation: 8
- Theme Overrides → Constants → separation = 8

#### Nav buttons — Button
| Node name | Text |
|---|---|
| `HomeButton` | `Home` |
| `FindButton` | `Find` |
| `JourneyButton` | `Journey` |
| `TradesButton` | `Trades` |
| `ProfileButton` | `Profile` |

For **each** nav button:
1. Size Flags Horizontal = Expand + Fill
2. Custom minimum size ≈ `Vector2(0, 56)`
3. **Enable Unique Name** (Access as Unique Name)
4. Do **not** enable `Toggle Mode` (script disables the active page button)

---

## 3. Recommended Project Stretch Settings (Portrait Mobile)

Set these in the Godot editor:

**Project → Project Settings → Display → Window**

| Setting | Recommended value |
|---|---|
| Viewport Width | `1080` |
| Viewport Height | `1920` |
| Initial Mode | `Windowed` (editor testing) |
| Stretch → Mode | `canvas_items` |
| Stretch → Aspect | `expand` |
| Stretch → Scale Mode | `fractional` |

Optional while testing on desktop:

| Setting | Value |
|---|---|
| Window Width Override | `390` |
| Window Height Override | `844` |

Orientation for a future Android export can be set to Portrait later.
Do not configure Android export presets in this phase.

---

## 4. Script: `mobile_navigation.gd`

| Item | Value |
|---|---|
| File name | `mobile_navigation.gd` |
| Folder | `res://scripts/ui/` |
| Full path | `res://scripts/ui/mobile_navigation.gd` |
| Attach to node | `Main` (`Control`) in `Main.tscn` |

### Nodes the script expects

All of these must exist and have **Access as Unique Name** enabled:

| Unique name | Node type | Role |
|---|---|---|
| `%HomePage` | `Control` | Home content page |
| `%FindPage` | `Control` | Find content page |
| `%JourneyPage` | `Control` | Journey content page |
| `%TradesPage` | `Control` | Trades content page |
| `%ProfilePage` | `Control` | Profile content page |
| `%HomeButton` | `Button` | Bottom nav: Home |
| `%FindButton` | `Button` | Bottom nav: Find |
| `%JourneyButton` | `Button` | Bottom nav: Journey |
| `%TradesButton` | `Button` | Bottom nav: Trades |
| `%ProfileButton` | `Button` | Bottom nav: Profile |

Child `PageLabel` nodes are display-only for this phase and are **not** referenced by the script.

---

## 5. Exact Script Attachment Instructions

1. Open `res://scenes/main/Main.tscn`.
2. Select the root node `Main`.
3. In the Inspector, click the Script dropdown → Attach Script
   - or use the script icon in the scene toolbar.
4. Choose **Load** existing script (do not create a new one).
5. Select `res://scripts/ui/mobile_navigation.gd`.
6. Confirm the script is attached to `Main` only.
7. Save the scene.

---

## 6. Exact Signal-Connection Instructions

Connect signals **manually in the editor**. Do not rely on the script to auto-connect button presses.

For each row below:

1. Select the button node.
2. Open the **Node** dock → **Signals**.
3. Double-click `pressed()`.
4. Choose receiver node: `Main`.
5. Select / enter the exact method name listed.
6. Connect.

| Button node | Signal | Receiver | Method |
|---|---|---|---|
| `HomeButton` | `pressed()` | `Main` | `_on_home_button_pressed` |
| `FindButton` | `pressed()` | `Main` | `_on_find_button_pressed` |
| `JourneyButton` | `pressed()` | `Main` | `_on_journey_button_pressed` |
| `TradesButton` | `pressed()` | `Main` | `_on_trades_button_pressed` |
| `ProfileButton` | `pressed()` | `Main` | `_on_profile_button_pressed` |

Optional (not required for this phase):

| Emitter | Signal | Notes |
|---|---|---|
| `Main` (`MobileNavigation`) | `page_changed(page_name: String)` | Emitted after a successful page switch. Leave unconnected for now. |

---

## 7. Test Checklist

Run the project (`F5`) after `Main.tscn` is the main scene.

### Boot
- [ ] Project opens without script parse errors.
- [ ] `Main.tscn` appears as the startup scene.
- [ ] Deep navy background is visible.
- [ ] Bottom navigation bar is visible with five buttons: Home, Find, Journey, Trades, Profile.
- [ ] No errors in the Output / Debugger about missing unique-name nodes.

### Default state
- [ ] Home page is visible on launch.
- [ ] Home page label reads `Home`.
- [ ] Home nav button is disabled.
- [ ] Other nav buttons are enabled.
- [ ] Other pages are hidden.

### Navigation
- [ ] Tap **Find** → only Find page visible; Find button disabled; others enabled.
- [ ] Tap **Journey** → only Journey page visible; Journey button disabled; others enabled.
- [ ] Tap **Trades** → only Trades page visible; Trades button disabled; others enabled.
- [ ] Tap **Profile** → only Profile page visible; Profile button disabled; others enabled.
- [ ] Tap **Home** again → returns to Home; Home button disabled.

### Layout / mobile portrait
- [ ] Content is not covered by the bottom bar.
- [ ] Buttons are large enough to tap comfortably.
- [ ] Resizing the window (desktop) keeps the layout usable under `canvas_items` + `expand`.

### Safety / scope guardrails for this phase
- [ ] No Pokémon GO login fields exist.
- [ ] No password fields exist.
- [ ] No GPS / precise location requests exist.
- [ ] No private messaging UI exists yet.
- [ ] No network calls are made by `mobile_navigation.gd`.

When every item above passes, stop and report success. Do not start the next feature until then.

---

## Visual Direction Reminder (for manual editor styling)

Use these colors while building the shell (themes can come later):

| Role | Hex | Notes |
|---|---|---|
| Background | `#121A33` | Deep navy |
| Secondary panel | `#3A2F55` | Soft violet |
| Highlight | `#FFD666` | Warm gold |
| Body text | `#F5F0E6` | Light warm off-white |

Do not use official Pokémon artwork, Poké Balls, creature silhouettes, or copied game UI.
