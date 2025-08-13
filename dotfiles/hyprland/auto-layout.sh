#!/usr/bin/env bash

# Script to automatically resize windows when there are exactly 3 windows on the current workspace
# Finds the single window in the binary tree and resizes it to 1/3 of the screen width

# Get current workspace
current_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id')

# Get all windows on current workspace
windows=$(hyprctl clients -j | jq --argjson ws "$current_workspace" '[.[] | select(.workspace.id == $ws and .floating == false)]')

# Count windows
window_count=$(echo "$windows" | jq 'length')

# Handle different window counts
if [ "$window_count" -eq 2 ] || [ "$window_count" -eq 4 ]; then
    # For 2 or 4 windows, reset split ratio to equal (50/50)
    hyprctl dispatch splitratio exact 1
    exit 0
elif [ "$window_count" -ne 3 ]; then
    # Exit if not 2, 3, or 4 windows
    exit 0
fi

# Get monitor info for the current workspace
monitor_info=$(hyprctl monitors -j | jq --argjson ws "$current_workspace" '.[] | select(.activeWorkspace.id == $ws)')
monitor_width=$(echo "$monitor_info" | jq -r '.width')
monitor_height=$(echo "$monitor_info" | jq -r '.height')

# Account for gaps: gaps_out = 10 (left and right), gaps_in = 5 (between windows)
# For 1/3 layout: target_width = (monitor_width - 2*gaps_out - gaps_in) / 3
# But we need to account for the fact that the other 2/3 will have gaps between them too
# So: 1/3 section gets (monitor_width - 2*gaps_out - 2*gaps_in) / 3
gaps_out=10
gaps_in=5
usable_width=$((monitor_width - 2 * gaps_out - gaps_in))
target_width=$((usable_width / 3))

# Get window sizes to identify the layout structure
window_widths=$(echo "$windows" | jq -r '.[].size[0]')
window_addresses=$(echo "$windows" | jq -r '.[].address')

# Find the window that's closest to being alone (widest window)
# In a 3-window binary tree, the single window will typically be wider
max_width=0
single_window_address=""

while IFS= read -r address && IFS= read -r width <&3; do
    if [ "$width" -gt "$max_width" ]; then
        max_width=$width
        single_window_address=$address
    fi
done < <(echo "$window_addresses") 3< <(echo "$window_widths")

# Alternative approach: find the window with a significantly different width
# This handles cases where the widest window might not be the single one
declare -a widths_array
declare -a addresses_array

while IFS= read -r address && IFS= read -r width <&3; do
    addresses_array+=("$address")
    widths_array+=("$width")
done < <(echo "$window_addresses") 3< <(echo "$window_widths")

# Count occurrences of similar widths (within 50px tolerance)
for i in "${!widths_array[@]}"; do
    current_width=${widths_array[$i]}
    similar_count=0
    
    for j in "${!widths_array[@]}"; do
        other_width=${widths_array[$j]}
        diff=$((current_width - other_width))
        diff=${diff#-}  # absolute value
        
        if [ "$diff" -le 50 ]; then
            ((similar_count++))
        fi
    done
    
    # If this window has only 1 similar width (itself), it's likely the single window
    if [ "$similar_count" -eq 1 ]; then
        single_window_address=${addresses_array[$i]}
        break
    fi
done

# If we found a single window, resize it
if [ -n "$single_window_address" ]; then
    # Calculate the exact size including gaps
    # The window should be 1/3 of the usable width
    hyprctl dispatch resizewindowpixel exact "${target_width}" "${monitor_height}",address:"${single_window_address}"
fi