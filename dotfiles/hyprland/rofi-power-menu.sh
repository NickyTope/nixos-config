#!/usr/bin/env bash

# Modern Rofi Power Menu
# Features: System info, uptime, confirmation dialogs, and icon-based interface

# Get system info
uptime_info=$(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//')
host_info=$(hostname)
user_info=${USER}

# Define icons and options
shutdown_icon="⏻"
reboot_icon=""
suspend_icon="󰒲"
lock_icon="󰌾"
logout_icon="󰈆"

# Create options with only icons
options="${shutdown_icon}\n${reboot_icon}\n${suspend_icon}\n${lock_icon}\n${logout_icon}"

# Display system info in the prompt
system_prompt="󰌢 ${host_info} | 󰅐 ${uptime_info} | 󰊖 ${user_info}"

# Main rofi command with enhanced styling
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Goodbye ${USER}" -mesg "${system_prompt}" -theme-str '
* {
    background-color: rgba(17, 17, 27, 0.95);
    text-color: rgba(192, 202, 245, 1);
    border-color: rgba(180, 142, 255, 0.8);
    selected-normal-background: rgba(180, 142, 255, 0.25);
    selected-normal-foreground: rgba(180, 142, 255, 1);
    font: "JetBrains Mono Nerd Font 14";
}

window {
    transparency: "real";
    location: center;
    anchor: center;
    fullscreen: false;
    height: 220px;
    cursor: "default";
}

message {
    enabled: true;
    border-radius: 8px;
    padding: 5px;
}

dummy {
  background-color: transparent;
}

mainbox {
    enabled: true;
    background-color: transparent;
    spacing: 10px;
    children: [ "inputbar", "listview", "message" ];
}

inputbar {
    enabled: true;
    spacing: 8px;
    border: 0px solid;
    border-radius: 8px;
    background-color: rgba(25, 23, 36, 0.8);
    text-color: rgba(205, 214, 244, 0.9);
    children: [ "prompt" ];
}

prompt {
    enabled: true;
    font: "JetBrains Mono Nerd Font 11";
    background-color: transparent;
    text-color: inherit;
}

listview {
    enabled: true;
    expand: false;
    columns: 5;
    lines: 1;
    cycle: true;
    dynamic: true;
    scrollbar: false;
    reverse: false;
    spacing: 10px;
    background-color: transparent;
}

element {
    enabled: true;
    spacing: 20px;
    margin: 0px;
    padding: 25px 0px 25px -10px;
    background-color: rgba(25, 23, 36, 0.6);
    text-color: rgba(205, 214, 244, 0.8);
    cursor: pointer;
}

element normal.normal {
    background-color: rgba(25, 23, 36, 0.6);
    text-color: rgba(205, 214, 244, 0.8);
}

element selected.normal {
    background-color: rgba(180, 142, 255, 0.3);
    text-color: rgba(180, 142, 255, 1);
    border: 1px solid;
    border-color: rgba(180, 142, 255, 0.7);
}

element-text {
    font: "JetBrains Mono Nerd Font 20";
    background-color: transparent;
    text-color: inherit;
    cursor: inherit;
    vertical-align: 0.5;
    horizontal-align: 0;
}
')

# Confirmation function
confirm_action() {
    local action="$1"
    local message="$2"
    
    result=$(echo -e "󰄬 Yes\n󰜺 No" | rofi -dmenu -i -p "${message}" -theme-str '
    window {
        width: 300px;
        height: 140px;
        border-radius: 8px;
    }
    listview {
        lines: 2;
    }
    element {
        padding: 12px;
        text-color: rgba(205, 214, 244, 1);
    }
    ')
    
    if [[ "$result" == "󰄬 Yes" ]]; then
        case $action in
            "shutdown") systemctl poweroff ;;
            "reboot") systemctl reboot ;;
            "suspend") systemctl suspend ;;
            "logout") hyprctl dispatch exit ;;
        esac
    fi
}

# Handle selection
case $chosen in
    "${shutdown_icon}")
        confirm_action "shutdown" "󰐥 Shutdown system?"
        ;;
    "${reboot_icon}")
        confirm_action "reboot" "󰜉 Restart system?"
        ;;
    "${suspend_icon}")
        systemctl suspend
        ;;
    "${lock_icon}")
        hyprlock
        ;;
    "${logout_icon}")
        confirm_action "logout" "󰍂 End session?"
        ;;
esac
