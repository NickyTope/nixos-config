#!/usr/bin/env bash

# ISW VPN Auto-Connect Script
# Retrieves credentials from pass and connects using SOPS config

set -euo pipefail

VPN_PASS_PATH="isw/vpn"
VPN_CONFIG_FILE="/run/secrets/isw-vpn"
TEMP_AUTH_FILE="/tmp/openvpn-auth-$$"

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

cleanup() {
    if [[ -f "$TEMP_AUTH_FILE" ]]; then
        rm -f "$TEMP_AUTH_FILE"
    fi
}

trap cleanup EXIT

# Check if pass is available
if ! command -v pass &> /dev/null; then
    error "pass command not found. Please install pass."
    exit 1
fi

# Check if oathtool is available for TOTP
if ! command -v oathtool &> /dev/null; then
    error "oathtool command not found. Please install oath-toolkit."
    exit 1
fi

# Check if VPN config exists
if [[ ! -f "$VPN_CONFIG_FILE" ]]; then
    error "OpenVPN config file not found at $VPN_CONFIG_FILE"
    error "SOPS secret may not be available or accessible"
    exit 1
fi

# Check if VPN is already running
if pgrep -f "openvpn.*isw-vpn" > /dev/null; then
    warn "VPN appears to already be running"
    exit 0
fi

# Retrieve credentials from pass
log "Retrieving credentials from pass..."
PASS_OUTPUT=$(pass show "$VPN_PASS_PATH")
PASSWORD=$(echo "$PASS_OUTPUT" | head -n1)
USERNAME=$(echo "$PASS_OUTPUT" | grep "user:" | cut -d' ' -f2)
TOTP_SECRET=$(echo "$PASS_OUTPUT" | grep "otpauth:" | sed 's/.*secret=\([^&]*\).*/\1/')

if [[ -z "$PASSWORD" || -z "$USERNAME" || -z "$TOTP_SECRET" ]]; then
    error "Failed to retrieve credentials from pass"
    exit 1
fi

# Generate TOTP code
log "Generating TOTP code..."
TOTP_CODE=$(oathtool --totp --base32 "$TOTP_SECRET")

# Create auth file with username and password (no TOTP here)
echo "$USERNAME" > "$TEMP_AUTH_FILE"
echo "$PASSWORD" >> "$TEMP_AUTH_FILE"
chmod 600 "$TEMP_AUTH_FILE"

# Connect to VPN using expect to handle the TOTP challenge
log "Connecting to VPN..."
sudo expect -c "
set timeout 60
spawn openvpn --config \"$VPN_CONFIG_FILE\" --auth-user-pass \"$TEMP_AUTH_FILE\" --daemon
expect {
    \"CHALLENGE: Enter Authenticator Code\" { 
        send \"$TOTP_CODE\r\"
        exp_continue
    }
    \"Initialization Sequence Completed\" { 
        expect eof
        exit 0 
    }
    \"AUTH_FAILED\" { 
        exit 1 
    }
    timeout { 
        exit 1 
    }
}
" > /dev/null 2>&1 &

# Wait a moment and check if connection succeeded
sleep 3
if pgrep -f "openvpn.*isw-vpn" > /dev/null; then
    log "VPN connection established successfully!"
else
    error "VPN connection failed. Check logs with: journalctl -f"
    exit 1
fi