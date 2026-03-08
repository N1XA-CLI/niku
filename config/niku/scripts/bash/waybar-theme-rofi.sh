#!/usr/bin/env bash

WAYBAR_DIR="$HOME/.config/waybar"
THEMES_DIR="$WAYBAR_DIR/themes"
CURRENT_THEME_FILE="$WAYBAR_DIR/.current_theme"

# Init state
[ -f "$CURRENT_THEME_FILE" ] || echo "default" > "$CURRENT_THEME_FILE"

# Get themes
THEMES=$(ls "$THEMES_DIR")

# Rofi menu
SELECTED=$(printf "%s\n" $THEMES | rofi -dmenu -p "Waybar Theme" -config "$HOME/.config/rofi/applets/waybar_switch.rasi")

# Exit if cancelled
[ -z "$SELECTED" ] && exit 0

# Validate
[ ! -d "$THEMES_DIR/$SELECTED" ] && exit 1

# Update symlinks (THIS IS THE FIX)
ln -sf "$THEMES_DIR/$SELECTED/config.jsonc" "$WAYBAR_DIR/config.jsonc"
ln -sf "$THEMES_DIR/$SELECTED/style.css" "$WAYBAR_DIR/style.css"

# Save state
echo "$SELECTED" > "$CURRENT_THEME_FILE"

# Restart Waybar
pkill waybar
sleep 0.2
waybar & disown

notify-send "Waybar Theme" "Switched to $SELECTED"
