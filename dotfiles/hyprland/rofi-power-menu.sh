#!/usr/bin/env bash

# Rofi Power Menu
# Based on the Sherlock power menu functionality

options="󰐥 Shutdown\n󰤄 Sleep\n󰍃 Lock\n󰜉 Reboot\n󰍂 Logout"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme-str '
window {
    width: 300px;
    height: 250px;
}
listview {
    lines: 5;
}
element {
    padding: 12px 16px;
}
')

case $chosen in
    "󰐥 Shutdown")
        systemctl poweroff
        ;;
    "󰤄 Sleep")
        systemctl suspend
        ;;
    "󰍃 Lock")
        hyprlock
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰍂 Logout")
        hyprctl dispatch exit
        ;;
esac