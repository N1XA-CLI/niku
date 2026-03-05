#!/usr/bin/env bash

spotify_player=$(playerctl -l | awk '/spotify/ {print; exit}')

if [ -n "$spotify_player" ]; then
    player="$spotify_player"
else
    player=$(playerctl -l | head -n1)
fi

[ -z "$player" ] && exit 0

playerctl -p "$player" previous
sleep 0.3

title=$(playerctl -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
art=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)
art="${art#file://}"

if [ -n "$title" ]; then
    notify-send -i "$art" "⏮ Previous Track" "$title - $artist"
else
    notify-send "Previous Track" "Player: $player"
fi
