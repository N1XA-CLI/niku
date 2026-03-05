#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/vars.sh"
source "$SCRIPT_DIR/lib/functions.sh"


main() {
    ensure_git

    echo "Fetching latest commit..."
    commit=$(get_latest_commit)
    echo "Latest commit: $commit"

    check_aur_helper
    install_packages
    link_configs

    echo "Setup complete."
}

main
