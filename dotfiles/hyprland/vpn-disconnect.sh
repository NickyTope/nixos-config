#!/usr/bin/env bash

# ISW VPN Disconnect Script

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

# Check if VPN is running
if ! pgrep -f "openvpn.*isw-vpn" > /dev/null; then
    warn "No ISW VPN connection found running"
    exit 0
fi

# Disconnect VPN
log "Disconnecting VPN..."
sudo pkill -f "openvpn.*isw-vpn"

# Wait and verify disconnection
sleep 2
if ! pgrep -f "openvpn.*isw-vpn" > /dev/null; then
    log "VPN disconnected successfully!"
else
    error "Failed to disconnect VPN"
    exit 1
fi