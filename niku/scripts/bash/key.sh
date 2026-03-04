#!/usr/bin/env bash

JSON="$HOME/.config/rofi/scripts/cheatsheet.json"
ROFI_THEME="$HOME/.config/rofi/applets/keybinds.rasi"

while true; do

    tabs=$(jq -r '.tabs | keys[]' "$JSON")

    SELECTED_TAB=$(echo "$tabs" | rofi -dmenu \
        -p "Niri Cheat Sheet" \
        -config "$ROFI_THEME")

    # Escape on main menu = exit
    [ $? -ne 0 ] && exit

    while true; do

        entries=$(jq -r --arg tab "$SELECTED_TAB" '
        .tabs[$tab][] | "\(.cmd)  →  \(.desc)"
        ' "$JSON")

        SELECTED_ENTEY=$(echo "$entries" | rofi -dmenu \
            -p "$SELECTED_TAB  [Esc = Back]" \
            -config "$ROFI_THEME")

        exit_code=$?

        # Escape pressed → go back
        if [ "$exit_code" -ne 0 ]; then
            break
        fi

        exit
    done

done
