#!/usr/bin/env bash

STATE_FILE="/tmp/hypr_caffeine"

if [ -f "$STATE_FILE" ]; then
    hyprctl dispatch exec "hypridle &"
    rm "$STATE_FILE"
    notify-send "Caffeine" "Disabled 😴"
else
    hyprctl dispatch exec "pkill hypridle"
    touch "$STATE_FILE"
    notify-send "Caffeine" "Enabled ☕"
fi
