#!/usr/bin/env bash
set -e

AUR_HELPER="yay"
PACKAGES=(rsync fastfetch kitty niri neovim obs-studio yazi waybar rofi swww unzip curl matugen btop cava nwg-look swaync adw-gtk-theme rmpc-git mpd)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
SOURCE_DIR="$SCRIPT_DIR/config/"
DEST_DIR="$HOME/.config/"

echo "Checking for missing packages..."
if ! command -v "$AUR_HELPER" &>/dev/null; then
    echo "AUR helper '$AUR_HELPER' not found. Install it first."; exit 1
fi

missing=()
for pkg in "${PACKAGES[@]}"; do
    "$AUR_HELPER" -Q "$pkg" &>/dev/null || missing+=("$pkg")
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "Missing packages: ${missing[*]}"
    read -p "Install them? (y/N): " ans
    [[ $ans =~ ^[Yy]$ ]] && "$AUR_HELPER" -S --noconfirm "${missing[@]}"
else
    echo "All packages installed."
fi


echo "Syncing dotfiles..."
rsync -av "$SOURCE_DIR" "$DEST_DIR"

# Left this part
echo "Applying GTK and icon themes..."
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk-theme"
gsettings set org.gnome.desktop.interface icon-theme "" || true


echo "Base ricing done."
sleep 1

echo "Done. Themes and extras applied."
