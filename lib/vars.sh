#!/usr/bin/env bash

########################################
# Repository information
########################################

REPO_URL="https://github.com/N1XA-CLI/niku"
REPO_API="https://api.github.com/repos/N1XA-CLI/niku/commits/main"


########################################
# AUR helper
########################################

AUR_HELPER="yay"


########################################
# Config directories
########################################

CONFIG_SOURCE="$SCRIPT_DIR/config"
CONFIG_DEST="$HOME/.config"


########################################
# Package list
########################################

PKG_FILE="$SCRIPT_DIR/packages/pkglist.txt"


########################################
# Fonts
########################################

FONT_SOURCE="$SCRIPT_DIR/fonts"
FONT_DEST="$HOME/.local/share/fonts/niku"


########################################
# Wallpapers
########################################

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_REPO="https://github.com/N1XA-CLI/walls"


########################################
# Backup and logging
########################################

BACKUP_DIR="$HOME/.config.backup/$(date +%Y-%m-%d)"
LOG_FILE="$SCRIPT_DIR/install.log"
