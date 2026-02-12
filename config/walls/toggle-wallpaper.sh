#!/bin/sh

set_wallpaper_hyprland() {
    dir="${HOME}/.config/walls"
    BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
    trans_type="grow"

    # Start swww-daemon if not running
    if ! pgrep -x "swww-daemon" >/dev/null; then
        echo "Starting swww-daemon..."
        swww-daemon & 
        sleep 0.5  # give it a moment to init
    fi

    # Set wallpaper with transition
    swww img "$BG" --transition-fps 240 --transition-type "$trans_type" --transition-duration 0.5
}

set_wallpaper_hyprland
