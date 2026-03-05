#!/usr/bin/env bash

# Prefer Spotify if available
spotify_player=$(playerctl -l | awk '/spotify/ {print; exit}')

if [ -n "$spotify_player" ]; then
    player="$spotify_player"
else
    player=$(playerctl -l | head -n1)
fi

# Exit if no player exists
[ -z "$player" ] && exit 0

# Get current loop status
current=$(playerctl -p "$player" loop 2>/dev/null)

# Toggle logic
if echo "$player" | grep -q "spotify"; then
    # Spotify: Track <-> Playlist
    if [ "$current" = "Track" ]; then
        new_mode="Playlist"
    else
        new_mode="Track"
    fi
else
    # Other players: Track <-> None
    if [ "$current" = "Track" ]; then
        new_mode="None"
    else
        new_mode="Track"
    fi
fi

# Apply new loop mode
playerctl -p "$player" loop "$new_mode"

# Small delay for metadata
sleep 0.2

# Get metadata for notification
title=$(playerctl -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
art=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)

# Remove file:// prefix if present
art="${art#file://}"

# Send notification
if [ -n "$title" ]; then
    notify-send -i "$art" "Loop: $new_mode" "$title - $artist"
else
    notify-send "Loop: $new_mode" "Player: $player"
fi
