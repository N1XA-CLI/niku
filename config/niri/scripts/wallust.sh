#!/usr/bin/env bash
#  ┳┳┓┏┓┏┳┓┳┳┏┓┏┓┳┓  ┳┳┓┏┓┏┓┳┏┓┓┏┓
#  ┃┃┃┣┫ ┃ ┃┃┃┓┣ ┃┃━━┃┃┃┣┫┃┓┃┃ ┃┫
#  ┛ ┗┛┗ ┻ ┗┛┗┛┗┛┛┗  ┛ ┗┛┗┗┛┻┗┛┛┗┛
#

# utility vars
cache_dir="$HOME/.cache/swww/"
current_monitor=$(niri msg -j outputs | jq -r 'keys[0]')
cache_file="$cache_dir$current_monitor"
wallpaper_path=$(tr -d '\0' <"$cache_file" | sed 's/^[A-Za-z0-9_-]\+//')

[ -f "$wallpaper_path" ] || {
    notify-send "MatugenMagick error" "Wallpaper not found: $wallpaper_path"
    exit 1
}

# generate wallust colors
wallust run "$wallpaper_path" 

# set gtk theme
# gsettings set org.gnome.desktop.interface gtk-theme ""
# gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3

#-------Imagemagick magick 👀--------------#
wait $!

# convert and resize the current wallpaper & make it image for rofi with blur
# magick "$wallpaper_path" -strip -resize 1000 -gravity center -extent 1000 -blur "30x30" -quality 90 $HOME/.config/rofi/images/currentWalBlur.thumb

# convert and resize the current wallpaper & make it image for rofi without blur
# magick "$wallpaper_path" -strip -resize 1000 -gravity center -extent 1000 -quality 90 $HOME/.config/rofi/images/currentWal.thumb

# convert and resize the current wallpaper & make it image for rofi with square format
# magick "$wallpaper_path" -strip -thumbnail 500x500^ -gravity center -extent 500x500 $HOME/.config/rofi/images/currentWal.sqre

# convert and resize the square formatted & make it image for rofi with drawing polygon
# magick $HOME/.config/rofi/images/currentWal.sqre \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite $HOME/.config/rofi/images/currentWalQuad.png && mv $HOME/.config/rofi/images/currentWalQuad.png $HOME/.config/rofi/images/currentWalQuad.quad

# copy the wallpaper in current-wallpaper file
wait $!
ln -sf "$wallpaper_path" "$HOME/.local/share/bg"

# send notification after completion
wait $!
notify-send -e -h string:x-canonical-private-synchronous:matugen_notif "WallustMagick" "Wallust & ImageMagick has completed its job" -i $HOME/.local/share/bg
