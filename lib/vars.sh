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
# Backup and logging
########################################

BACKUP_DIR="$HOME/.config.backup/$(date +%Y-%m-%d)"
LOG_FILE="$SCRIPT_DIR/install.log"