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

# If no color mode present
if [ -z "$COLOR_MODE" ]; then
  # create a mode 
  COLOR_MODE="dark"
fi

# If no color scheme present
if [ -z "$COLOR_SCHEME" ]; then

  COLOR_SCHEME="tonal-spot"
fi

# generate matugen colors using noctalia color scheme generator
if python3 "$SCRIPT" "$CURRENT_WALL" --scheme-type "$COLOR_SCHEME" --config "$CONFIG" --"$COLOR_MODE"; then
  # Set gtk theme
  gsettings set org.gnome.desktop.interface gtk-theme ""
  gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
  # convert and resize the current wallpaper & make it image for rofi with blur
  magick "$CURRENT_WALL" -strip -resize 800x800^ -gravity center -extent 800x800 -blur 40x40 -colors 64 -quality 30 "$HOME/.config/rofi/images/currentWalBlur.webp"
  # convert and resize the current wallpaper & make it image for rofi without blur
  magick "$CURRENT_WALL" -strip -resize 700x700^ -gravity center -extent 700x700 -colors 32 -quality 40 "$HOME/.config/rofi/images/currentWal.webp"
  # send notification after completion
  notify-send -e -h string:x-canonical-private-synchronous:matugen_notif "Matugen" "Matugen has completed its job!"
else
  notify-send -e -h  string:x-canonical-private-synchronous:matugen_notif "Matugen" "Matugen could not complete its job!"
fi


