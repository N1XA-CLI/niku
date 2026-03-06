#!/usr/bin/env bash
set -euo pipefail

ROFI_CONFIG="$HOME/.config/rofi/applets/system_launcher.rasi"

# --- Define menu options (no icons) ---
MENU_ITEMS=(
    "󱂬   Waybar Layout"
    "󱓞   Rofi Layout"
    "󰏘   Theme Switcher"
    "󰸉   Wallpaper Switcher"
    "󰔎   Toggle Dark/Light"
    "   Clipboard"
    # "   Capture"
    "󰞅   Emoji"
    "󰌌   Cheatsheet"
)

# --- Show rofi menu ---
SELECTED=$(printf "%s\n" "${MENU_ITEMS[@]}" | rofi -dmenu -i -p "Launcher" -config "$ROFI_CONFIG")

[ -z "$SELECTED" ] && exit 0  # Cancelled

# --- Run the corresponding script ---
case "$SELECTED" in
    "󱂬   Waybar Layout")
        "$HOME/.config/niku/scripts/bash/waybar-theme-rofi.sh"
        ;;
    "󱓞   Rofi Layout")
        "$HOME/.config/niku/scripts/bash/rofi-theme-switcher.sh"
        ;;
    "󰏘   Theme Switcher")
        "$HOME/.config/niku/scripts/bash/themepicker.sh"
        ;;
    "󰸉   Wallpaper Switcher")
        "$HOME/.config/niku/scripts/bash/wall_selector.sh"
        ;;
    "󰔎   Toggle Dark/Light")
		"$HOME/.config/niku/scripts/bash/toggle-color-mode.sh"
		;;
    "   Clipboard")
        "$HOME/.config/niku/scripts/bash/clip.sh"
        ;;
    # "   Capture")
		# "$HOME/.config/niku/scripts/bash/screenshotrofi.sh"
		# ;;
	"󰞅   Emoji")
		"$HOME/.config/niku/scripts/bash/emoji.sh"
		;;
    "󰌌   Cheatsheet")
		"$HOME/.config/niku/scripts/bash/key.sh"
		;;
    *)
        echo "Unknown option: $SELECTED"
        ;;
esac
