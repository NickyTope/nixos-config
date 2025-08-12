#!/usr/bin/env bash

# Hyprland Keybind Viewer - Shows all current keybinds in rofi and executes selected commands
# This script displays keybinds and can execute the selected command

# Create associative array to map display text to commands
declare -A COMMANDS

# Create temporary file for keybinds
TEMP_FILE=$(mktemp)

# Function to add keybind with command
add_keybind() {
    local display="$1"
    local command="$2"
    echo "$display" >> "$TEMP_FILE"
    COMMANDS["$display"]="$command"
}

# Create keybinds list
: > "$TEMP_FILE"

# Add keybinds with their commands
{
    echo "📋 WINDOW MANAGEMENT"
    add_keybind "Super + Return          | Open terminal" "ghostty"
    add_keybind "Super + Space           | Run launcher" "rofi -show run"
    add_keybind "Super + d               | App launcher" "rofi -show drun"
    add_keybind "Super + w               | Kill active window" "hyprctl dispatch killactive"
    add_keybind "Super + Alt + w         | Force kill active window" "kill -9 \$(hyprctl activewindow -j | jq -r '.pid')"
    add_keybind "Super + t               | Toggle floating" "hyprctl dispatch togglefloating"
    add_keybind "Super + f               | Fullscreen" "hyprctl dispatch fullscreen 0"
    add_keybind "Super + Shift + f       | Fake fullscreen" "hyprctl dispatch fullscreen 1"
    echo ""
    
    echo "💻 WORKSPACES"
    add_keybind "Super + 1               | Switch to workspace 1" "hyprctl dispatch workspace 1"
    add_keybind "Super + 2               | Switch to workspace 2" "hyprctl dispatch workspace 2"
    add_keybind "Super + 3               | Switch to workspace 3" "hyprctl dispatch workspace 3"
    add_keybind "Super + 4               | Switch to workspace 4" "hyprctl dispatch workspace 4"
    add_keybind "Super + 5               | Switch to workspace 5" "hyprctl dispatch workspace 5"
    add_keybind "Super + 6               | Switch to workspace 6" "hyprctl dispatch workspace 6"
    add_keybind "Super + 7               | Switch to workspace 7" "hyprctl dispatch workspace 7"
    add_keybind "Super + 8               | Switch to workspace 8" "hyprctl dispatch workspace 8"
    add_keybind "Super + 9               | Switch to workspace 9" "hyprctl dispatch workspace 9"
    add_keybind "Super + 0               | Switch to workspace 10" "hyprctl dispatch workspace 10"
    echo ""
    
    echo "🎯 SPECIAL FUNCTIONS"
    add_keybind "Super + u               | Terminal dropdown" "/home/nicky/code/nixos-config/dotfiles/hyprland/dropdown-toggle.sh"
    add_keybind "Super + i               | Notes dropdown" "/home/nicky/code/nixos-config/dotfiles/hyprland/affine-dropdown-toggle.sh"
    add_keybind "Super + o               | File manager dropdown" "/home/nicky/code/nixos-config/dotfiles/hyprland/thunar-dropdown-toggle.sh"
    add_keybind "Super + v               | Clipboard history" "cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    echo ""
    
    echo "🚀 APPLICATIONS"
    add_keybind "Super + e               | Emoji picker" "rofi -modi emoji -show emoji"
    add_keybind "Super + c               | Calculator" "rofi -modi calc -show calc -no-sort -no-show-match"
    add_keybind "Super + Tab             | Window switcher" "rofi -show window"
    add_keybind "Super + r               | Toggle screen recording" "/home/nicky/code/nixos-config/dotfiles/hyprland/toggle-recording.sh"
    echo ""
    
    echo "🎨 UTILITIES"
    add_keybind "Super + Shift + w       | Change wallpaper" "/home/nicky/code/nixos-config/dotfiles/hyprland/setwall.sh"
    add_keybind "Super + Alt + c         | Color picker" "hyprpicker -a"
    add_keybind "Super + Alt + p         | Screenshot (fullscreen)" "grim ~/Pictures/screens/Screenshot_\$(date +%s).png"
    add_keybind "Super + Shift + p       | Screenshot to clipboard" "grim -g \"\$(slurp)\" - | wl-copy"
    add_keybind "Super + Ctrl + p        | Screenshot (selection)" "grim -g \"\$(slurp)\" ~/Pictures/screens/Screenshot_\$(date +%s).png"
    echo ""
    
    echo "🔐 SYSTEM"
    add_keybind "Ctrl + Alt + l          | Lock screen" "hyprlock"
    add_keybind "Super + Alt + q         | Power menu" "/home/nicky/code/nixos-config/dotfiles/hyprland/rofi-power-menu.sh"
    add_keybind "Super + Alt + r         | Reload Hyprland" "hyprctl reload"
    echo ""
    
    echo "💡 LAYOUT HELPERS"
    add_keybind "Super + =               | Reset split ratios" "hyprctl dispatch splitratio exact 1"
    add_keybind "Super + -               | Make focused window smaller" "hyprctl dispatch splitratio -0.1"
    add_keybind "Super + +               | Make focused window larger" "hyprctl dispatch splitratio +0.1"
    add_keybind "Super + \\               | Resize to 1/3 width" "hyprctl dispatch resizewindowpixel exact 1706 1440"
    add_keybind "Super + s               | Toggle split direction" "hyprctl dispatch layoutmsg togglesplit"
    add_keybind "Super + x               | Swap split" "hyprctl dispatch layoutmsg swapsplit"
    add_keybind "Super + m               | Move window to root" "hyprctl dispatch layoutmsg movetoroot"
    echo ""
}

# Show in rofi with custom formatting and execute selected command
SELECTED=$(rofi -dmenu \
    -i \
    -p "Keybinds" \
    -theme-str "window { width: 85%; height: 80%; }" \
    -theme-str "listview { columns: 2; lines: 30; spacing: 5px; }" \
    -theme-str "element { padding: 3px 5px; }" \
    -theme-str "element-text { horizontal-align: 0.0; font: \"monospace 12\"; }" \
    -theme-str "inputbar { margin: 2px; }" \
    -no-custom \
    < "$TEMP_FILE")

# Clean up temp file
rm "$TEMP_FILE"

# Execute the selected command if one was chosen
if [[ -n "$SELECTED" && -n "${COMMANDS[$SELECTED]}" ]]; then
    # Replace escaped characters for proper execution
    COMMAND="${COMMANDS[$SELECTED]}"
    COMMAND="${COMMAND//\\\$/\$}"  # Replace \$ with $
    COMMAND="${COMMAND//\\\"/\"}"  # Replace \" with "
    
    # Execute the command
    eval "$COMMAND" &
fi