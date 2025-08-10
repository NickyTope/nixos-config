#!/usr/bin/env bash

# Hyprland Dropdown Ghostty Terminal Script

TERMINAL_CLASS="dropdown-ghostty"
WORKSPACE="special:dropdown"

# Check if the dropdown terminal is already running
if hyprctl clients | grep -q "$TERMINAL_CLASS"; then
    # If it's running, toggle the special workspace
    hyprctl dispatch togglespecialworkspace dropdown
else
    # If it's not running, start it
    hyprctl dispatch exec "[workspace $WORKSPACE silent] ghostty --config-file=\"$HOME/.config/ghostty/dropdown.config\""
fi