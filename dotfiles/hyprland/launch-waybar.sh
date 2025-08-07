#!/usr/bin/env bash

# Kill any existing waybar processes
killall waybar 2>/dev/null

# Wait a moment
sleep 1

# Launch waybar with our config and style
waybar -c ~/code/nixos-config/dotfiles/hyprland/waybar-config.json -s ~/code/nixos-config/dotfiles/hyprland/waybar-style.css &

echo "Waybar launched"