#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="$HOME/Pictures/Wallpapers"
SYMLINK_PATH="$HOME/.local/share/bg"
ROFI_CONFIG="$HOME/.config/rofi/applets/config-wallpaper.rasi"
COLOR_SCHEME_PATH="$HOME/.config/niku/Color-Generator/Script/"
# --- Determine if wallpaper directory exists ---
if [[ ! -d "$WALL_DIR" ]]; then
    echo "❌ Wallpaper directory not found: $WALL_DIR"
    exit 1
fi

SELECTED_WALL=$(
    {
        find "$WALL_DIR" -maxdepth 1 -type f \
            \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) \
            -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2- | 
            while read -r img; do
                name="$(basename "$img")"
                printf "%s\0icon\x1f%s\n" "$name" "$img"
            done
    } |
        rofi -dmenu -i -p "Select Wallpaper" -show-icons -config "$ROFI_CONFIG"
)

[ -z "$SELECTED_WALL" ] && exit 0

SELECTED_PATH="$WALL_DIR/$SELECTED_WALL"

# --- Apply wallpaper only using swww ---
notify-send "Applying Wallpaper" --icon="$HOME/.config/niku/Color-Generator/matugen/assets/paint-brush.webp" & 
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

if swww img "$SELECTED_PATH" --transition-type any --transition-fps 60; then
  "$HOME/.config/niku/scripts/bash/matugen.sh"
  echo "✅ Applied wallpaper: $SELECTED_PATH"
fi
