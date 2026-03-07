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

    mapfile -t packages < "$PKG_FILE"

    repo_packages=()
    aur_packages=()

    for pkg in "${packages[@]}"
    do
        if pacman -Si "$pkg" &>/dev/null; then
            repo_packages+=("$pkg")
        else
            aur_packages+=("$pkg")
        fi
    done


    ########################################
    # Install repo packages
    ########################################

    if [[ ${#repo_packages[@]} -gt 0 ]]; then

        section "Installing repository packages"

        sudo pacman -S --needed --noconfirm "${repo_packages[@]}"

        success "Repository packages installed"

    fi


    ########################################
    # Install AUR packages in parallel
    ########################################

    if [[ ${#aur_packages[@]} -gt 0 ]]; then

        section "Installing AUR packages"

        max_jobs=4
        running_jobs=0

        for pkg in "${aur_packages[@]}"
        do

            echo "Installing $pkg"

            "$AUR_HELPER" -S --needed --noconfirm "$pkg" &

            ((running_jobs++))

            if (( running_jobs >= max_jobs )); then
                wait -n
                ((running_jobs--))
            fi

        done

        wait

        success "AUR packages installed"

    fi

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
# Full Installer
########################################

full_install() {

    section "Starting Full Installation"

    ensure_git
    ensure_aur_helper

    install_packages
    link_configs

    success "Full installation finished"

}