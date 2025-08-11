#!/usr/bin/env bash

# Rofi Screen Recording Menu
# Based on the Sherlock screen recording functionality

options="󰹑 Start Recording\n󰙧 Stop Recording"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "  " -theme-str '
window {
    width: 350px;
    height: 200px;
}
listview {
    lines: 2;
}
element {
    padding: 12px 16px;
}
')

case $chosen in
    "󰹑 Start Recording")
        /home/nicky/code/nixos-config/dotfiles/hyprland/start-recording.sh
        ;;
    "󰙧 Stop Recording")
        /home/nicky/code/nixos-config/dotfiles/hyprland/stop-recording.sh
        ;;
esac
