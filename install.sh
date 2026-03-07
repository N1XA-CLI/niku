#!/usr/bin/env bash

set -euo pipefail

########################################
# Get script directory
########################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

########################################
# Load modules
########################################

source "$SCRIPT_DIR/lib/vars.sh"
source "$SCRIPT_DIR/lib/functions.sh"

########################################
# Logging
########################################

mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1

########################################
# Error handling
########################################

trap 'error "Installer encountered an error."' ERR
trap 'echo; warn "Installation cancelled."; exit 1' INT

########################################
# Start installer
########################################

clear
print_banner

info "Installation log: $LOG_FILE"
info "Config backups: $BACKUP_DIR"

main() {

    check_repo_updates

    while true
    do
        show_menu

        read -rp "Enter choice: " user_choice

        case "$user_choice" in

            1)
                full_install
                ;;

            2)
                install_packages
                ;;

            3)
                link_configs
                ;;

            4)
                copy_configs
                ;;

            5)
                info "Exiting installer"
                exit 0
                ;;

            *)
                warn "Invalid option"
                ;;
        esac

        echo
        read -rp "Press Enter to return to menu..."
        clear
        print_banner

    done
}

main