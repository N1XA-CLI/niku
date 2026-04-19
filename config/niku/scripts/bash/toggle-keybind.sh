#!/usr/bin/env bash

# ─────────────────────────────────────────────
#  Niri keybind toggle
#  Toggles config.kdl symlink between:
#    presets/config-keybind.kdl   (.keybind present)
#    presets/config-no-bind.kdl   (.no-keybind present)
# ─────────────────────────────────────────────

NIRI_DIR="$HOME/.config/niri"
CONFIG="$NIRI_DIR/config.kdl"
KEYBIND_PRESET="$NIRI_DIR/presets/config-keybind.kdl"
NOBIND_PRESET="$NIRI_DIR/presets/config-no-bind.kdl"
MARKER_ON="$NIRI_DIR/.keybind"
MARKER_OFF="$NIRI_DIR/.no-keybind"

# ── Helper: echo + notify ──────────────────────
# Usage: notify <urgency> <title> <body>
#   urgency: low | normal | critical
notify() {
    local urgency="$1"
    local title="$2"
    local body="$3"
    echo "  [$title] $body"
    notify-send --urgency="$urgency" --app-name="Niri Keybind Toggle" "$title" "$body"
}

# ── Sanity checks ──────────────────────────────
if [[ ! -f "$KEYBIND_PRESET" ]]; then
    notify critical "ERROR" "Keybind preset not found: $KEYBIND_PRESET"
    exit 1
fi

if [[ ! -f "$NOBIND_PRESET" ]]; then
    notify critical "ERROR" "No-bind preset not found: $NOBIND_PRESET"
    exit 1
fi

# ── Toggle logic ───────────────────────────────
if [[ -f "$MARKER_ON" ]]; then
    # ── Keybinds are ON → switch to no-bind ──────

    rm -f "$CONFIG"
    ln -s "$NOBIND_PRESET" "$CONFIG"

    mv "$MARKER_ON" "$MARKER_OFF"

    echo ""
    notify normal "✔ Keybinds DISABLED" "Niri is now running without keybinds."

elif [[ -f "$MARKER_OFF" ]]; then
    # ── Keybinds are OFF (.no-keybind exists) → switch to keybind ──

    rm -f "$MARKER_OFF"

    if [[ -e "$CONFIG" && ! -L "$CONFIG" ]]; then
        notify normal "WARNING" "config.kdl is a real file — backing up to config.kdl.bak"
        mv "$CONFIG" "$CONFIG.bak"
    else
        rm -f "$CONFIG"
    fi

    ln -s "$KEYBIND_PRESET" "$CONFIG"

    touch "$MARKER_ON"

    echo ""
    notify normal "✔ Keybinds ENABLED" "Niri is now running with keybinds."

else
    # ── No marker at all → first run ─────────────
    notify normal "Niri Keybind Toggle" "No marker file found — first run! Defaulting to keybinds ON."

    if [[ -e "$CONFIG" && ! -L "$CONFIG" ]]; then
        notify normal "WARNING" "config.kdl is a real file — backing up to config.kdl.bak"
        mv "$CONFIG" "$CONFIG.bak"
    else
        rm -f "$CONFIG"
    fi

    ln -s "$KEYBIND_PRESET" "$CONFIG"

    touch "$MARKER_ON"

    echo ""
    notify normal "✔ Keybinds ENABLED" "First run complete — Niri is running with keybinds."
fi
