#!/usr/bin/env bash

# ISW VPN Status Script

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[VPN]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[VPN]${NC} $1"
}

error() {
    echo -e "${RED}[VPN]${NC} $1" >&2
}

# Check VPN status
if pgrep -f "openvpn.*isw-vpn" > /dev/null; then
    log "VPN is connected"
    
    # Try to get more details
    VPN_PID=$(pgrep -f "openvpn.*isw-vpn")
    log "VPN PID: $VPN_PID"
    
    # Check if tun interface exists
    if ip link show | grep -q "tun"; then
        TUN_INTERFACE=$(ip link show | grep "tun" | head -n1 | cut -d: -f2 | tr -d ' ')
        log "Tunnel interface: $TUN_INTERFACE"
        
        # Show IP if available
        if ip addr show "$TUN_INTERFACE" 2>/dev/null | grep -q "inet "; then
            VPN_IP=$(ip addr show "$TUN_INTERFACE" | grep "inet " | awk '{print $2}' | cut -d/ -f1)
            log "VPN IP: $VPN_IP"
        fi
    fi
    
    exit 0
else
    warn "VPN is not connected"
    exit 1
fi