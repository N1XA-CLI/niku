#!/usr/bin/env bash

if pgrep -x wlogout >/dev/null; then
    pkill -x wlogout
    exit
fi

read resolution scale < <(
niri msg -j outputs |
jq -r '.[].logical | "\(.height) \(.scale)"' |
head -n1
)

menu_half=80

T=$(awk "BEGIN {printf \"%.0f\", ($resolution/2 - $menu_half) * $scale}")
B=$T

wlogout \
-C "$HOME/.config/wlogout/style.css" \
-l "$HOME/.config/wlogout/layout" \
--protocol layer-shell \
-b 5 \
-n \
-T "$T" \
-B "$B" &
