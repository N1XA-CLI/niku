#!/usr/bin/env bash

spotify_player=$(playerctl -l | awk '/spotify/ {print; exit}')

if [ -n "$spotify_player" ]; then
    player="$spotify_player"
else
    player=$(playerctl -l | head -n1)
fi

[ -z "$player" ] && exit 0

# Get current shuffle state
current=$(playerctl -p "$player" shuffle 2>/dev/null)

if [ "$current" = "On" ]; then
    new_state="Off"
else
    new_state="On"
fi

playerctl -p "$player" shuffle "$new_state"
sleep 0.2

title=$(playerctl -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
art=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)
art="${art#file://}"

if [ -n "$title" ]; then
    notify-send -i "$art" "Shuffle: $new_state" "$title - $artist"
else
    notify-send "Shuffle: $new_state" "Player: $player"
fi
