#!/usr/bin/env bash

# Kill any existing waybar processes
killall waybar 2>/dev/null

# Wait a moment
sleep 1

# Detect hostname and use appropriate config
HOSTNAME=$(hostname)
CONFIG_BASE="/home/nicky/code/nixos-config/dotfiles/hyprland"

case "$HOSTNAME" in
    "mininix")
        CONFIG_FILE="$CONFIG_BASE/waybar-config-mininix.json"
        ;;
    "nt-oryx")
        CONFIG_FILE="$CONFIG_BASE/waybar-config-nt-oryx.json"
        ;;
    *)
        # Fallback to generic config
        CONFIG_FILE="$CONFIG_BASE/waybar-config.json"
        ;;
esac

# Launch waybar with host-specific config and shared style
waybar -c "$CONFIG_FILE" -s "$CONFIG_BASE/waybar-style.css" &

echo "Waybar launched for $HOSTNAME"