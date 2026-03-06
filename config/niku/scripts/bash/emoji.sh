#!/usr/bin/env bash


if pgrep -x rofi >/dev/null; then
    pkill -x rofi
    exit
else
  rofi -modi emoji -show emoji -theme ~/.config/rofi/applets/emoji.rasi # this is a theme so can be used anywhere
fi
