#!/usr/bin/env bash

source ~/.config/niku/scripts/bash/functions.sh

JSON="$HOME/.config/rofi/scripts/color-scheme-options.json"
ROFI_THEME="$HOME/.config/rofi/applets/color-scheme-option.rasi"
SCHEME_PATH="$HOME/.config/niku/Color-Generator/command/current_command/scheme"
MODE_PATH="$HOME/.config/niku/Color-Generator/command/current_command/mode"

while true; do

    tab=$(jq -r '.tabs | keys[]' "$JSON")

    SELECTED_TAB=$(echo "$tab" | rofi -dmenu \
        -p "Available color options" \
        -config "$ROFI_THEME")

    # Escape on main menu = exit
    [ $? -ne 0 ] && exit

    while true; do

        ENTRIES=$(jq -r --arg tab "$SELECTED_TAB" '
        .tabs[$tab][] | "\(.option) → \(.desc)"
        ' "$JSON")

        SELECTED_ENTRY=$(echo "$ENTRIES" | rofi -dmenu \
            -p "$SELECTED_TAB  [Esc = Back]" \
            -config "$ROFI_THEME")

        # get if exscape is pressed
        exit_code=$?

        # Escape pressed → go back
        if [ "$exit_code" -ne 0 ]; then
            break
        fi

        option=$(echo "$SELECTED_ENTRY" | awk -F' → ' '{print $1}')

        if [[ "$SELECTED_TAB" == "Color Mode" ]]; then
          rm -f "$MODE_PATH"/* &
            ln -sf "$option" "$MODE_PATH" &
              notify_color_update &
                "$HOME/.config/niku/scripts/bash/matugen.sh"

        elif [[ "$SELECTED_TAB" == "Color Scheme" ]]; then
          rm -f "$SCHEME_PATH"/* &
            ln -sf "$option" "$SCHEME_PATH" &
              notify_color_scheme_update &
                "$HOME/.config/niku/scripts/bash/matugen.sh"
        fi

        exit
    done
done
