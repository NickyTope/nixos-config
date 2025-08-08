#!/usr/bin/env bash

# Dropdown terminal toggle script for Hyprland
# This script toggles the visibility of a dropdown terminal

DROPDOWN_CLASS="com.mitchellh.ghostty"
DROPDOWN_SIZE="1200 700"
DROPDOWN_POS="360 50"

# Function to get dropdown terminal window ID
get_dropdown_window() {
    # Look for a floating ghostty window at our specific position and size
    hyprctl clients -j | jq -r ".[] | select(.class == \"$DROPDOWN_CLASS\" and .floating == true and .size[0] == 1200 and .size[1] == 700) | .address"
}

# Function to get window's current workspace
get_window_workspace() {
    local window_id="$1"
    if [ -n "$window_id" ]; then
        hyprctl clients -j | jq -r ".[] | select(.address == \"$window_id\") | .workspace.id"
    fi
}

# Function to get current active workspace
get_current_workspace() {
    hyprctl activeworkspace -j | jq -r '.id'
}

# Function to check if window is on a special workspace (hidden)
is_window_hidden() {
    local window_id="$1"
    if [ -n "$window_id" ]; then
        local workspace_id=$(get_window_workspace "$window_id")
        # If workspace ID is negative, it's a special workspace (hidden)
        [ "$workspace_id" -lt 0 ]
        return $?
    fi
    return 1
}

# Main logic
DROPDOWN_WINDOW=$(get_dropdown_window)
CURRENT_WORKSPACE=$(get_current_workspace)

if [ -n "$DROPDOWN_WINDOW" ]; then
    # Window exists, check its state
    WINDOW_WORKSPACE=$(get_window_workspace "$DROPDOWN_WINDOW")
    
    if is_window_hidden "$DROPDOWN_WINDOW"; then
        # Window is hidden on special workspace, bring it to current workspace
        hyprctl dispatch movetoworkspace $CURRENT_WORKSPACE,address:$DROPDOWN_WINDOW
        hyprctl dispatch focuswindow address:$DROPDOWN_WINDOW
        # notify-send "Dropdown" "Terminal shown" -t 1000
    elif [ "$WINDOW_WORKSPACE" = "$CURRENT_WORKSPACE" ]; then
        # Window is on current workspace, hide it
        hyprctl dispatch movetoworkspacesilent special:dropdown,address:$DROPDOWN_WINDOW
        # notify-send "Dropdown" "Terminal hidden" -t 1000
    else
        # Window is on different workspace, bring it to current workspace
        hyprctl dispatch movetoworkspace $CURRENT_WORKSPACE,address:$DROPDOWN_WINDOW
        hyprctl dispatch focuswindow address:$DROPDOWN_WINDOW
        # notify-send "Dropdown" "Terminal moved to current workspace" -t 1000
    fi
else
    # No dropdown window exists, create one
    hyprctl dispatch exec "[float; size $DROPDOWN_SIZE; move $DROPDOWN_POS] ghostty"
    # notify-send "Dropdown" "Terminal created" -t 1000
fi
