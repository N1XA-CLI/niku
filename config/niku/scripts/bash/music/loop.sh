#!/usr/bin/env bash

# Detect spotify instance properly (handles flatpak etc.)
spotify_player=$(playerctl -l | grep spotify | head -n1)

if [ -n "$spotify_player" ]; then
    current=$(playerctl -p "$spotify_player" loop)
    if [ "$current" = "Track" ]; then
        playerctl -p "$spotify_player" loop Playlist
    else
        playerctl -p "$spotify_player" loop Track
    fi
else
    current=$(playerctl loop)
    if [ "$current" = "Track" ]; then
        playerctl loop None
    else
        playerctl loop Track
    fi
fi
