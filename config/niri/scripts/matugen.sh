#!/usr/bin/env bash

# Current wallpaper location
CURRENT_WALL=$(readlink -f "$HOME/.local/share/bg")

[ -f "$CURRENT_WALL" ] || {
    notify-send "MatugenMagick error" "Wallpaper not found: $CURRENT_WALL"
    exit 1
}

# generate matugen colors
if matugen image "$CURRENT_WALL"; then
  # Set gtk theme
  gsettings set org.gnome.desktop.interface gtk-theme ""
  gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
  # send notification after completion
  notify-send -e -h string:x-canonical-private-synchronous:matugen_notif "MatugenMagick" "Matugen & ImageMagick has completed its job!"
else
    notify-send "Matugen" "Color generation failed!"
    exit 1
fi


