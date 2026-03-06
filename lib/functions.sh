# Ensure git exists
ensure_git() {
    if command -v git >/dev/null; then
        return
    fi

    echo "Git not found. Installing..."
    sudo pacman -S --needed git
}


# Ensure yay exists
check_aur_helper() {
    if command -v "$AUR_HELPER" >/dev/null; then
        return
    fi

    echo "Installing yay-bin..."

    sudo pacman -S --needed git base-devel

    temp_dir=$(mktemp -d)

    git clone https://aur.archlinux.org/yay-bin.git "$temp_dir/yay"

    cd "$temp_dir/yay"
    makepkg -si --noconfirm
}


# Detect missing packages
check_missing_packages() {
    local missing=()
    local pkg

    while read -r pkg; do
        [[ -z "$pkg" ]] && continue

        if ! pacman -Qi "$pkg" &>/dev/null; then
            missing+=("$pkg")
        fi
    done < "$PKG_FILE"

    printf '%s\n' "${missing[@]}"
}


# Install missing packages
install_packages() {
    mapfile -t missing < <(check_missing_packages)

    if (( ${#missing[@]} == 0 )); then
        echo "All packages installed."
        return
    fi

    echo "Installing packages:"
    printf '%s\n' "${missing[@]}"

    "$AUR_HELPER" -S --needed "${missing[@]}"
}


# Link configs
link_configs() {
    mkdir -p "$CONFIG_DEST"

    for dir in "$CONFIG_SOURCE"/*; do
        name=$(basename "$dir")
        ln -sfn "$dir" "$CONFIG_DEST/$name"
    done
}

copy_configs() {
    mkdir -p "$CONFIG_DEST"

    for dir in "$CONFIG_SOURCE"/*; do
        name=$(basename "$dir")
        cp -r "$dir" "$CONFIG_DEST/$name"
    done
}
