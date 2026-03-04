#!/usr/bin/env bash
set -euo pipefail
CONFIG_DIR="$HOME/.config/matugen"
THEME_FILE="$CONFIG_DIR/theme.txt"
SKIP_FILE="$CONFIG_DIR/matugenskiposthook"
echo "dark" >"$THEME_FILE"
echo "1" >"$SKIP_FILE"
# --- Config ---
BASE_WALL_DIR="$HOME/Pictures/Wallpapers/" # Base folder containing theme folders
SYMLINK_PATH="$HOME/.local/share/bg"
ROFI_CONFIG="$HOME/.config/rofi/ts.rasi"

# --- Step 1: List theme folders ---
THEME_FOLDERS=($(find "$BASE_WALL_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"))

# Extract friendly names (last part after dash)
THEME_NAMES=()
for folder in "${THEME_FOLDERS[@]}"; do
    THEME_NAMES+=("${folder##*-}") # last part after dash
done

# --- Step 2: Show rofi menu with friendly names ---
SELECTED_NAME=$(printf "%s\n" "${THEME_NAMES[@]}" | rofi -dmenu -i -p "Select Theme" -config "$ROFI_CONFIG")
[ -z "$SELECTED_NAME" ] && exit 0 # Cancelled

# --- Step 3: Map back to actual folder ---
THEME_DIR=""
for folder in "${THEME_FOLDERS[@]}"; do
    if [[ "${folder##*-}" == "$SELECTED_NAME" ]]; then
        THEME_DIR="$BASE_WALL_DIR/$folder"
        break
    fi
done

if [[ -z "$THEME_DIR" || ! -d "$THEME_DIR" ]]; then
    echo "❌ Theme folder not found"
    exit 1
fi

# --- Step 4: Pick a random wallpaper ---
RANDOM_WALL="$(find "$THEME_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)"

[ -z "$RANDOM_WALL" ] && {
    echo "❌ No wallpapers found in $THEME_DIR"
    exit 1
}

# --- Step 5: Apply wallpaper and colors using matugen ---
matugen image "$RANDOM_WALL"
# swaync-client -rs

# --- Step 6: Update symlink ---
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$RANDOM_WALL" "$SYMLINK_PATH"

echo "✅ Theme switched to '$SELECTED_NAME' with wallpaper '$RANDOM_WALL'"
