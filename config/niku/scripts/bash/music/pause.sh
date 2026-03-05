#!/usr/bin/env bash

spotify_player=$(playerctl -l | awk '/spotify/ {print; exit}')
[ -n "$spotify_player" ] && player="$spotify_player" || player=$(playerctl -l | head -n1)
[ -z "$player" ] && exit 0

playerctl -p "$player" pause
sleep 0.2

title=$(playerctl -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
art=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)
art="${art#file://}"

notify-send -i "$art" "Paused" "$title - $artist"
