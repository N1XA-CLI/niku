#!/bin/bash

# Check if Spotify is running
if pgrep -x "spotify" > /dev/null; then
    # Spotify is running → apply only
    spicetify apply
else
    # Spotify is NOT running → apply only, do NOT open Spotify
    spicetify apply && pkill spotify 
fi

