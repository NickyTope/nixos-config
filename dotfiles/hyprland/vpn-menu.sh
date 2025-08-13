#!/usr/bin/env bash

# Modern VPN Rofi Menu
# Features: Icon-based interface, status display, and automatic credential handling

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONNECT_SCRIPT="$SCRIPT_DIR/vpn-connect.sh"
DISCONNECT_SCRIPT="$SCRIPT_DIR/vpn-disconnect.sh"
STATUS_SCRIPT="$SCRIPT_DIR/vpn-status.sh"

# Define icons
connect_icon="󰌆"
disconnect_icon="󰅖"
status_icon="󰖂"

# Check current VPN status
if "$STATUS_SCRIPT" &>/dev/null; then
    VPN_STATUS="Connected"
    vpn_ip=$(ip addr show tun0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1 || echo "Unknown IP")
    system_prompt="󰖂 ISW VPN | 󰩠 Connected | 󰩟 ${vpn_ip}"
    options="${disconnect_icon} Disconnect"
else
    VPN_STATUS="Disconnected"
    system_prompt="󰖂 ISW VPN | 󰩠 Disconnected"
    options="${connect_icon} Connect"
fi

# Main rofi command with enhanced styling matching power menu
chosen=$(echo -e "$options" | rofi -dmenu -i -p "VPN Control" -mesg "${system_prompt}" -theme-str '
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
    height: 200px;
    width: 300px;
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
    children: [ "inputbar", "dummy", "listview", "dummy", "message" ];
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
    columns: 1;
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
    padding: 15px 0px;
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
    font: "JetBrains Mono Nerd Font 10";
    background-color: transparent;
    text-color: inherit;
    cursor: inherit;
    vertical-align: 0.5;
    horizontal-align: 0;
}
')

# Handle selection
case $chosen in
    "${connect_icon} Connect")
        # Connect to VPN with progress indication
        notify-send "VPN" "Connecting..." -i network-vpn
        if "$CONNECT_SCRIPT"; then
            notify-send "VPN" "Connected successfully" -i network-vpn
        else
            notify-send "VPN" "Connection failed" -i dialog-error
        fi
        ;;
    "${disconnect_icon} Disconnect")
        # Disconnect VPN
        if "$DISCONNECT_SCRIPT"; then
            notify-send "VPN" "Disconnected" -i network-vpn-disconnected
        else
            notify-send "VPN" "Disconnect failed" -i dialog-error
        fi
        ;;
    *)
        # Do nothing if escaped or invalid choice
        ;;
esac
