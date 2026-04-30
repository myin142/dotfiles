# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**illogical-impulse (ii)** — a Quickshell-based desktop shell UI for Hyprland (Wayland compositor). Written in QML/Qt Quick with Python/shell helper scripts.

No build step. Quickshell loads QML at runtime.

## Running & Development

```bash
# Format QML files (uses .qmlformat.ini: 4-space indent, max width 110)
qmlformat -i <file.qml>

# Hot reload is supported — Quickshell reloads on file change
# ReloadPopup.qml shows reload notifications

# Run with
qs -c ii
```

Config lives at `~/.config/illogical-impulse/config.json`. Shell watches it and hot-reloads on changes.

## Architecture

### Entry Points

- **`shell.qml`** — root `ShellRoot`; initializes services and loads `panelFamilies/`
- **`settings.qml`** — standalone settings window
- **`GlobalStates.qml`** — singleton; all UI open/close state (`barOpen`, `sidebarLeftOpen`, `overlayOpen`, Super key state, etc.)
- **`panelFamilies/IllogicalImpulseFamily.qml`** — declares all UI panels; `PanelLoader.qml` lazy-loads them after `Config.ready`

### Key Singletons

| File | Role |
|------|------|
| `modules/common/Config.qml` | Central JSON config; `Config.options.*` for reads, `Config.setNestedValue()` for writes |
| `modules/common/Appearance.qml` | Material Design 3 palette, typography, animations, wallpaper-extracted theming |
| `services/HyprlandData.qml` | Window list, workspaces, active window from Hyprland |
| `services/Ai.qml` | LLM abstraction (Gemini, OpenAI, Mistral, OpenRouter) |
| `services/Notifications.qml` | D-Bus notifications + persistence |

### Module Layout

```
modules/
  common/         # Shared utilities and widgets
    Config.qml    # 520-line config system
    Appearance.qml
    functions/    # ColorUtils, StringUtils, Fuzzy, Levendist, etc.
    widgets/      # Reusable UI components + Material shapes
  ii/             # Main shell UI (91 QML files)
    bar/          # Taskbar, workspaces, media, audio, battery, clock, notifications
    sidebarLeft/  # AI chat, translator, clipboard history
    overlay/      # Floating widgets (crosshair, notes, volume mixer, recorder)
    notificationPopup/
    mediaControls/
    polkit/
    cheatsheet/
    screenCorners/
    regionSelector/
  settings/       # Settings app pages
services/         # System integration singletons
scripts/
  ai/             # Gemini API scripts
  colors/         # Wallpaper switching, Material Design color generation (Python)
  hyprland/       # Config management, keybind extraction (Python)
  thumbnails/     # Video thumbnail generation (Python)
  images/         # Region detection (Python)
  kvantum/        # Qt theme adaptation (Python)
panelFamilies/    # Panel declarations and lazy loader
translations/     # en_US, ja_JP, zh_CN JSON files
assets/
  icons/fluent/   # Fluent SVG icon subset
```

### Data Flow

1. **Config** — components bind to `Config.options.*`; writes go through `Config.setNestedValue()` → JSON file → file watcher triggers hot reload
2. **Theming** — `Appearance.qml` runs `ColorQuantizer` on wallpaper → generates M3 palette → all components bind to `Appearance.m3colors.*`
3. **UI state** — components toggle `GlobalStates.*` properties; panels react reactively
4. **System data** — services (Audio, Battery, HyprlandData, etc.) expose properties; UI binds directly
5. **External scripts** — invoked via `Process` QML component for color switching, thumbnails, AI calls, Hyprland config

### QML Conventions

- Singletons accessed by type name directly (e.g., `Config.options.bar.height`)
- `PanelLoader` wraps all top-level panels for lazy instantiation
- Translations via `Translation.get("key")` or `Translation.tr` bindings
- Material Design 3 shapes via `modules/common/widgets/shapes/`
- AI prompts stored as files in `assets/ai/prompts/`
