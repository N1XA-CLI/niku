#!/usr/bin/env bash

choice=$(
  {
    echo -e "CLEAR\t󰆴  Clear clipboard history"
    cliphist list
  } | rofi -dmenu -display-columns 2 -theme ~/.config/rofi/applets/clipboard.rasi
)

[ -z "$choice" ] && exit 0

if [[ "$choice" == CLEAR* ]]; then
  cliphist wipe
  notify-send "Clipboard" "Clipboard history cleared"
else
  echo "$choice" | cliphist decode | wl-copy
fi
