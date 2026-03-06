#!/usr/bin/env bash

source ~/.config/niku/scripts/bash/functions.sh 

MODE_DIR="$HOME/.config/niku/Color-Generator/command/current_command/mode"
CURRENT_MODE=$(ls "$MODE_DIR")

LIGHT_MODE="light"
DARK_MODE="dark"

if [[ $CURRENT_MODE == "dark" ]]; then
  rm "$MODE_DIR"/* &
    ln -sf "$LIGHT_MODE" "$MODE_DIR" &
      notify_color_update
        "$HOME/.config/niku/scripts/bash/matugen.sh"

elif [[ $CURRENT_MODE == "both" ]]; then
  rm "$MODE_DIR"/* &
    ln -sf "$LIGHT_MODE" "$MODE_DIR" &
      notify_color_mode_update
        "$HOME/.config/niku/scripts/bash/matugen.sh"

elif [[ $CURRENT_MODE == "light" ]]; then 
  rm "$MODE_DIR"/* &
    ln -sf "$DARK_MODE" "$MODE_DIR" &
      notify_color_mode_update
        "$HOME/.config/niku/scripts/bash/matugen.sh"

else
   notify-send "No Color mode found!" "Going with dark" 
  ln -sf "$DARK_MODE" "$MODE_DIR" &
    notify_color_mode_update
      "$HOME/.config/niku/scripts/bash/matugen.sh"
 fi
