#!/usr/bin/env bash

# Current wallpaper location
CURRENT_WALL=$(readlink -f "$HOME/.local/share/bg")
SCRIPT="$HOME/.config/niku/Color-Generator/Script/template-processor.py"
CONFIG="$HOME/.config/niku/Color-Generator/matugen/config.toml"
COLOR_SCHEME=$(ls "$HOME/.config/niku/Color-Generator/command/current_command/scheme/")
COLOR_MODE=$(ls "$HOME/.config/niku/Color-Generator/command/current_command/mode/")

[ -f "$CURRENT_WALL" ] || {
    notify-send "Wallpaper not found: $CURRENT_WALL"
    exit 1
}

if [ -z "$COLOR_MODE" ]; then
  COLOR_MODE="both"
fi

if [ -z "$COLOR_SCHEME" ]; then
  COLOR_SCHEME="tonal-spot"
fi

# generate matugen colors using noctalia color scheme generator
if python3 "$SCRIPT" "$CURRENT_WALL" --scheme-type "$COLOR_SCHEME" --config "$CONFIG" --"$COLOR_MODE"; then
  # Set gtk theme
  gsettings set org.gnome.desktop.interface gtk-theme ""
  gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
  # send notification after completion
  notify-send -e -h string:x-canonical-private-synchronous:matugen_notif "Matugen" "Matugen has completed its job!"
else
  notify-send -e -h  string:x-canonical-private-synchronous:matugen_notif "Matugen" "Matugen could not complete its job!"
fi


