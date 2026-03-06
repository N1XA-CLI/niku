#!/usr/bin/env bash

if pgrep -x hyprpicker >/dev/null; then
    pkill -x hyprpicker
    exit
else
    hyprpicker -a &
fi
