#!/usr/bin/env bash

# Hyprland Keybind Viewer - Shows all current keybinds in rofi
# This script extracts keybinds from Hyprland and displays them in a searchable rofi menu

# Function to format keybind for display
format_keybind() {
    local bind="$1"
    local command="$2"
    
    # Replace common key names for better readability
    bind=$(echo "$bind" | sed 's/SUPER/Super/g' | sed 's/ALT/Alt/g' | sed 's/CTRL/Ctrl/g' | sed 's/SHIFT/Shift/g')
    
    # Format the output
    printf "%-25s | %s\n" "$bind" "$command"
}

# Create temporary file for keybinds
TEMP_FILE=$(mktemp)

# Header
echo "=== HYPRLAND KEYBINDS ===" > "$TEMP_FILE"
echo "" >> "$TEMP_FILE"

# Get all keybinds from hyprctl and parse them
{
    echo "📋 WINDOW MANAGEMENT"
    echo "Super + Return          | Open terminal (ghostty)"
    echo "Super + Space           | Run launcher (rofi)"
    echo "Super + d               | App launcher (rofi drun)"
    echo "Super + w               | Kill active window"
    echo "Super + Alt + w         | Force kill active window"
    echo "Super + t               | Toggle floating"
    echo "Super + f               | Fullscreen"
    echo "Super + Shift + f       | Fake fullscreen"
    echo ""
    
    echo "🔄 FOCUS & MOVEMENT"
    echo "Super + h/j/k/l         | Focus left/down/up/right"
    echo "Super + Shift + h/j/k/l | Move window left/down/up/right"
    echo "Super + Alt + h/j/k/l   | Resize window"
    echo "Super + Arrow keys      | Move floating window"
    echo ""
    
    echo "💻 WORKSPACES"
    echo "Super + 1-9,0           | Switch to workspace 1-10"
    echo "Super + Shift + 1-9,0   | Move window to workspace 1-10"
    echo "Super + v               | Next workspace"
    echo "Super + Shift + v       | Previous workspace"
    echo ""
    
    echo "🎯 SPECIAL FUNCTIONS"
    echo "Super + u               | Terminal dropdown (ghostty)"
    echo "Super + i               | Notes dropdown (Affine)"
    echo "Super + o               | File manager dropdown (Thunar)"
    echo "Super + p               | Pin window"
    echo ""
    
    echo "🚀 APPLICATIONS"
    echo "Super + e               | Emoji picker (rofi)"
    echo "Super + c               | Calculator (rofi)"
    echo "Super + Tab             | Window switcher (rofi)"
    echo "Super + r               | Screen ruler"
    echo ""
    
    echo "🎨 UTILITIES"
    echo "Super + Alt + c         | Color picker"
    echo "Super + Alt + p         | Screenshot (fullscreen)"
    echo "Super + Shift + p       | Screenshot to clipboard"
    echo "Super + Ctrl + p        | Screenshot (selection)"
    echo "Super + Shift + w       | Change wallpaper"
    echo "Ctrl + Alt + v          | Clipboard history"
    echo ""
    
    echo "🔐 SYSTEM"
    echo "Ctrl + Alt + l          | Lock screen"
    echo "Super + Alt + q         | Power menu"
    echo "Super + Alt + r         | Reload Hyprland"
    echo ""
    
    echo "🎵 MEDIA"
    echo "XF86AudioMute           | Toggle mute"
    echo "XF86AudioRaise/Lower    | Volume up/down"
    echo "XF86MonBrightnessUp/Down| Brightness up/down"
    echo ""
    
    echo "💡 LAYOUT HELPERS"
    echo "Super + g/y             | Swap with master"
    echo "Super + m               | Next orientation"
    echo "Super + '               | Reset layout"
    echo "Super + Ctrl + =        | Reset split ratios"
    echo "Super + Ctrl + 1/2      | Adjust split ratio"
    echo ""
    
} >> "$TEMP_FILE"

# Show in rofi with custom formatting
rofi -dmenu \
    -i \
    -p "Keybinds" \
    -theme-str "window { width: 80%; height: 70%; }" \
    -theme-str "listview { columns: 1; lines: 20; }" \
    -theme-str "element { padding: 5px; }" \
    -no-custom \
    < "$TEMP_FILE"

# Clean up
rm "$TEMP_FILE"