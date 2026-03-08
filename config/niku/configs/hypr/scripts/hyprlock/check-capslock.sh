#!/bin/env bash

MAIN_KB_CAPS=$(cat /sys/class/leds/input*::capslock/brightness)

if [ "$MAIN_KB_CAPS" = 1 ]; then
    echo "Caps Lock active"
else
    echo ""
fi
