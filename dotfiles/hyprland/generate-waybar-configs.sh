#!/usr/bin/env bash

# Generate host-specific waybar configs from template
CONFIG_DIR="/home/nicky/code/nixos-config/dotfiles/hyprland"
TEMPLATE="$CONFIG_DIR/waybar-config-template.json"

# Function to generate config for a specific host
generate_config() {
    local hostname="$1"
    local output="$2"
    local modules_right="$3"
    local target_file="$CONFIG_DIR/waybar-config-${hostname}.json"
    
    # Replace placeholders in template
    sed -e "s/{{OUTPUT}}/[\"${output}\"]/g" \
        -e "s/{{MODULES_RIGHT}}/${modules_right}/g" \
        "$TEMPLATE" > "$target_file"
    
    echo "Generated config for $hostname -> $target_file"
}

# Desktop modules (no battery)
DESKTOP_MODULES='[
    "memory",
    "cpu", 
    "temperature",
    "pulseaudio",
    "network",
    "tray"
  ]'

# Laptop modules (includes battery)
LAPTOP_MODULES='[
    "memory",
    "cpu",
    "temperature", 
    "battery",
    "pulseaudio",
    "network",
    "tray"
  ]'

# Generate configs for each host
generate_config "mininix" "DP-2" "$DESKTOP_MODULES"
generate_config "nt-oryx" "eDP-1" "$LAPTOP_MODULES"

echo "All waybar configs generated from template"