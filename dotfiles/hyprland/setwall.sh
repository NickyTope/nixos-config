#!/usr/bin/env bash

# Wayland wallpaper setter script for Hyprland
# Uses hyprctl to get monitor info and hyprpaper to set wallpapers

# Kill any existing hyprpaper processes
killall hyprpaper 2>/dev/null

# Get monitor information from hyprctl
monitors=$(hyprctl monitors -j | jq -r '.[].name')

# Create hyprpaper config
config_file="/tmp/hyprpaper.conf"
echo > "$config_file"

# Add preload and wallpaper directives for each monitor
for monitor in $monitors; do
    # Get monitor width to determine wallpaper directory
    width=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor\") | .width")
    
    if [ "$width" -gt "5000" ]; then
        # Ultra-wide monitor - use uwide wallpapers
        pic=$(find ~/Pictures/walls/uwide -name "*.jpg" -o -name "*.png" | shuf -n1)
    else
        # Regular monitor - use current wallpapers  
        pic=$(find ~/Pictures/walls/current -name "*.jpg" -o -name "*.png" | shuf -n1)
    fi
    
    if [ -n "$pic" ] && [ -f "$pic" ]; then
        echo "preload = $pic" >> "$config_file"
        echo "wallpaper = $monitor,$pic" >> "$config_file"
    else
        echo "No wallpaper found for monitor $monitor (width: $width)"
    fi
done

# Add splash to disable hyprpaper splash screen
echo "splash = false" >> "$config_file"

# Start hyprpaper with the generated config
hyprpaper -c "$config_file" &

# Wait a moment for hyprpaper to start
sleep 2