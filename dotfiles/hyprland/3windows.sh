#!/usr/bin/env bash
set -euo pipefail

# Get active monitor and workspace
active_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
workspace_id=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$active_monitor\") | .activeWorkspace.id")
monitor_width=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$active_monitor\") | .width")

# Get gaps_out (sum left + right gaps)
gaps_out_str=$(hyprctl getoption general:gaps_out -j | jq -r '.custom // "0 0 0 0"')
right_gap=$(echo "$gaps_out_str" | awk '{print $2}')
left_gap=$(echo "$gaps_out_str" | awk '{print $4}')
gaps_out=$(( right_gap + left_gap ))

# Get gaps_in (sum left + right inner gaps if available, else zero)
gaps_in_str=$(hyprctl getoption general:gaps_in -j | jq -r '.custom // "0 0 0 0"')
right_in_gap=$(echo "$gaps_in_str" | awk '{print $2}')
left_in_gap=$(echo "$gaps_in_str" | awk '{print $4}')
gaps_in=$(( right_in_gap + left_in_gap ))

# Get tiled, visible clients on workspace (ignore floating)
clients=$(hyprctl clients -j | jq -c "
  [.[] | select(.workspace.id == $workspace_id and .floating == false and .mapped == true and .size[0] > 0)]
")

count=$(echo "$clients" | jq 'length')

if (( count != 3 )); then
  echo "This script only handles exactly 3 tiled windows. Found $count."
  exit 1
fi

# Find largest window by width
largest_window=$(echo "$clients" | jq -c 'max_by(.size[0])')
largest_addr=$(echo "$largest_window" | jq -r '.address')

# Calculate target width (equal split of available space)
available_width=$(( monitor_width - gaps_out - ( (count - 1) * gaps_in ) ))
target_width=$(( available_width / count ))

if (( target_width <= 0 )); then
  echo "Invalid target width computed: $target_width"
  exit 1
fi

# Resize windows to target width
echo "$clients" | jq -c '.[]' | while read -r win; do
  win_addr=$(echo "$win" | jq -r '.address')
  hyprctl dispatch focuswindow "address:$win_addr" >/dev/null

  # Resize horizontally to target width; -1 means height unchanged
  hyprctl dispatch resizeactive exact $target_width -1 >/dev/null
done

echo "Resized 3 windows to equal widths ($target_width px each)."

