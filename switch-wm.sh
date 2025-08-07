#!/usr/bin/env bash

# NixOS Window Manager Switcher
# Usage: ./switch-wm.sh [xfce|hyprland] [hostname]

set -e

WM=${1:-}
HOSTNAME=${2:-$(hostname)}

if [[ -z "$WM" ]]; then
    echo "Usage: $0 [xfce|hyprland] [hostname]"
    echo ""
    echo "Available window managers:"
    echo "  xfce     - XFCE + bspwm (original configuration)"
    echo "  hyprland - Hyprland (Wayland)"
    echo ""
    echo "Available hostnames:"
    echo "  mininix  - Desktop system"
    echo "  nt-oryx  - Laptop system"
    echo ""
    echo "Current hostname: $HOSTNAME"
    exit 1
fi

case "$WM" in
    "xfce")
        CONFIG="${HOSTNAME}"
        echo "Switching to XFCE + bspwm configuration..."
        ;;
    "hyprland")
        CONFIG="${HOSTNAME}-hyprland"
        echo "Switching to Hyprland configuration..."
        ;;
    *)
        echo "Error: Unknown window manager '$WM'"
        echo "Available options: xfce, hyprland"
        exit 1
        ;;
esac

echo "Building configuration: $CONFIG"
echo "This will switch your system to use $WM on host $HOSTNAME"
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo "Building and switching to configuration..."
sudo nixos-rebuild switch --flake .#$CONFIG

echo ""
echo "✓ Successfully switched to $WM configuration!"
echo ""
if [[ "$WM" == "hyprland" ]]; then
    echo "Important notes for Hyprland:"
    echo "- You'll need to reboot to start using Hyprland"
    echo "- Key bindings have been mapped from your sxhkd config"
    echo "- Screenshot tools now use grim/slurp instead of maim"
    echo "- Clipboard is handled by wl-clipboard"
    echo ""
    echo "To rollback to XFCE + bspwm, run:"
    echo "  ./switch-wm.sh xfce $HOSTNAME"
elif [[ "$WM" == "xfce" ]]; then
    echo "Rolled back to XFCE + bspwm configuration."
    echo "You may need to reboot if you were using Hyprland."
fi