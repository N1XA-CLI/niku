#!/usr/bin/env bash
set -e

ROFI_DIR="$HOME/.config/rofi"
THEMES_DIR="$ROFI_DIR/themes"
CONFIG="$ROFI_DIR/config.rasi"

# List available themes (without .rasi)
THEMES=$(find "$THEMES_DIR" -maxdepth 1 -type f -name '*.rasi' \
         -exec basename {} .rasi \;)

# Show menu
THEME=$(printf "%s\n" "$THEMES" | rofi -dmenu -p "Rofi Theme" -config "$HOME/.config/rofi/ts.rasi")
[ -z "$THEME" ] && exit 0

# Replace @theme line (modern syntax)
sed -i \
  "s|^@theme \".*\"|@theme \"$THEMES_DIR/$THEME.rasi\"|" \
  "$CONFIG"

notify-send "Rofi Theme" "Switched to $THEME"
