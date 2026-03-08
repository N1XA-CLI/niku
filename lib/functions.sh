#!/usr/bin/env bash

########################################
# Colors
########################################

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
RESET="\033[0m"


########################################
# Pretty Printing
########################################

section() {
    echo -e "\n${MAGENTA}==> $1${RESET}"
}

info() {
    echo -e "${BLUE}• $1${RESET}"
}

success() {
    echo -e "${GREEN}✔ $1${RESET}"
}

warn() {
    echo -e "${YELLOW}⚠ $1${RESET}"
}

error() {
    echo -e "${RED}✖ $1${RESET}"
}


########################################
# Banner
########################################

print_banner() {

    echo -e "${BLUE}"
    echo "███╗   ██╗██╗██╗  ██╗██╗   ██╗"
    echo "████╗  ██║██║██║ ██╔╝██║   ██║"
    echo "██╔██╗ ██║██║█████╔╝ ██║   ██║"
    echo "██║╚██╗██║██║██╔═██╗ ██║   ██║"
    echo "██║ ╚████║██║██║  ██╗╚██████╔╝"
    echo "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝"
    echo "Dotfiles Installer"
    echo -e "${RESET}"

}


########################################
# Dependency Checks
########################################

ensure_git() {

    if command -v git >/dev/null 2>&1; then
        success "Git is installed"
        return
    fi

    section "Installing Git"

    sudo pacman -S --needed git

    success "Git installed"

}


ensure_aur_helper() {

    if command -v "$AUR_HELPER" >/dev/null 2>&1; then
        success "$AUR_HELPER is installed"
        return
    fi

    section "Installing AUR helper ($AUR_HELPER)"

    sudo pacman -S --needed git base-devel

    temp_dir="$(mktemp -d)"

    git clone https://aur.archlinux.org/yay-bin.git "$temp_dir/yay"

    cd "$temp_dir/yay"

    makepkg -si --noconfirm

    success "$AUR_HELPER installed"

}


########################################
# Repository Update Check
########################################

check_repo_updates() {

    section "Checking repository updates"

    if ! command -v curl >/dev/null; then
        warn "curl not installed, skipping update check"
        return
    fi

    if ! command -v jq >/dev/null; then
        warn "jq not installed, skipping update check"
        return
    fi

    latest_commit=$(curl -s "$REPO_API" | jq -r '.sha' | head -c 7)

    if [[ -z "$latest_commit" ]]; then
        warn "Could not check updates"
        return
    fi

    info "Latest repository commit: $latest_commit"

}


########################################
# Menu
########################################

show_menu() {

    section "Niku Dotfiles Installer"

    echo
    echo "1) Full Install"
    echo "2) Install Packages"
    echo "3) Link Config Files"
    echo "4) Copy Config Files"
    echo "5) Exit"
    echo

}


########################################
# Package Installation (Parallel AUR)
########################################

install_packages() {

    section "Preparing package installation"

    info "Using AUR helper: $AUR_HELPER"

    if [[ ! -f "$PKG_FILE" ]]; then
        error "Package list not found: $PKG_FILE"
        return
    fi

    # Read package list and remove duplicates + comments
    mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PKG_FILE" | sort -u)

    missing_packages=()

    ########################################
    # Detect packages not installed
    ########################################

    for pkg in "${packages[@]}"
    do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            missing_packages+=("$pkg")
        fi
    done

    ########################################
    # If everything is installed
    ########################################

    if [[ ${#missing_packages[@]} -eq 0 ]]; then
        success "All packages are already installed"
        return
    fi

    ########################################
    # Show packages to install
    ########################################

    section "Packages to install"

    for pkg in "${missing_packages[@]}"
    do
        echo " - $pkg"
    done

    ########################################
    # Install packages
    ########################################

    section "Installing packages"

    "$AUR_HELPER" -S --needed --noconfirm "${missing_packages[@]}"

    success "Package installation finished"

}

########################################
# Backup existing configs
########################################

backup_config() {

    local config_name="$1"
    local source_path="$CONFIG_DEST/$config_name"
    local backup_path="$BACKUP_DIR/$config_name"

    if [[ -e "$source_path" ]]; then

        mkdir -p "$BACKUP_DIR"

        info "Backing up $config_name"

        mv "$source_path" "$backup_path"

        success "Backup created: $backup_path"

    fi

}

########################################
# Config Management
########################################

link_configs() {

    section "Linking config files"

    mkdir -p "$CONFIG_DEST"

    for directory in "$CONFIG_SOURCE"/*
    do

        config_name="$(basename "$directory")"
        target_path="$CONFIG_DEST/$config_name"

        if [[ -e "$target_path" ]]; then

            backup_config "$config_name"

        fi

        ln -s "$directory" "$target_path"

        success "Linked $config_name"

    done

}


copy_configs() {

    section "Copying config files"

    mkdir -p "$CONFIG_DEST"

    for directory in "$CONFIG_SOURCE"/*
    do

        config_name="$(basename "$directory")"
        target_path="$CONFIG_DEST/$config_name"

        if [[ -e "$target_path" ]]; then

            backup_config "$config_name"

        fi

        cp -r "$directory" "$target_path"

        success "Copied $config_name"

    done

}

########################################
# Font Installation
########################################

install_fonts() {

    section "Installing fonts"

    if [[ ! -d "$FONT_SOURCE" ]]; then
        warn "Font directory not found: $FONT_SOURCE"
        return
    fi

    mkdir -p "$FONT_DEST"

    # Sync fonts recursively
    rsync -av --include='*/' \
        --include='*.ttf' \
        --include='*.otf' \
        --include='*.ttc' \
        --exclude='*' \
        "$FONT_SOURCE/" "$FONT_DEST/"

    section "Updating font cache"
    fc-cache -fv >/dev/null

    success "Fonts installed successfully"

}


########################################
# Wallpaper Installation
########################################

install_wallpapers() {

    section "Wallpaper Setup"

    read -rp "Do you want to install wallpapers? [y/N]: " answer

    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
        info "Skipping wallpaper installation"
        info "Place wallpapers in: $WALLPAPER_DIR"
        return
    fi

    ensure_git

    mkdir -p "$HOME/Pictures"

    if [[ -d "$WALLPAPER_DIR/.git" ]]; then
        info "Updating wallpapers..."
        git -C "$WALLPAPER_DIR" pull
        success "Wallpapers updated"
        return
    fi

    section "Installing wallpapers"

    git clone "$WALLPAPER_REPO" "$WALLPAPER_DIR"

    success "Wallpapers installed to $WALLPAPER_DIR"
}

########################################
# Full Installer
########################################

full_install() {

    section "Starting Full Installation"

    ensure_git
    ensure_aur_helper

    install_packages
    link_configs
    install_fonts
    install_wallpapers


    success "Full installation finished"

}

########################################
# Installation completion message
########################################

installation_complete() {

    section "Installation Complete"

    success "Niku installation finished."

    info "Config backups: $BACKUP_DIR"
    info "Installation log: $LOG_FILE"

    echo
    warn "A reboot is recommended before starting Niri."

    echo
    info "Enjoy your new setup!"

}
