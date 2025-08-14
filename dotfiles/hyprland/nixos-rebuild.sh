#!/usr/bin/env bash

# NixOS Rebuild Script with AI Error Interpretation
# Runs nixos-rebuild with notifications and Claude AI error analysis

set -euo pipefail

FLAKE_DIR="/home/nicky/code/nixos-config"
LOG_FILE="/tmp/nixos-rebuild-$(date +%s).log"
CLAUDE_API_KEY_FILE="$HOME/.config/claude/api_key"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[REBUILD]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[REBUILD]${NC} $1"
}

error() {
    echo -e "${RED}[REBUILD]${NC} $1" >&2
}

info() {
    echo -e "${BLUE}[REBUILD]${NC} $1"
}

# Function to send error to Claude for interpretation
interpret_error_with_claude() {
    local error_text="$1"
    
    # Check if Claude API key exists
    if [[ ! -f "$CLAUDE_API_KEY_FILE" ]]; then
        warn "Claude API key not found at $CLAUDE_API_KEY_FILE"
        return 1
    fi
    
    local api_key
    api_key=$(cat "$CLAUDE_API_KEY_FILE")
    
    if [[ -z "$api_key" ]]; then
        warn "Empty Claude API key"
        return 1
    fi
    
    # Prepare the prompt for Claude
    local prompt="Analyze this NixOS rebuild error and provide a concise, actionable solution in 1-2 sentences:

Error:
$error_text

Please focus on the most likely cause and specific steps to fix it."
    
    # Send request to Claude API
    local response
    response=$(curl -s -X POST "https://api.anthropic.com/v1/messages" \
        -H "Content-Type: application/json" \
        -H "x-api-key: $api_key" \
        -H "anthropic-version: 2023-06-01" \
        -d "{
            \"model\": \"claude-3-sonnet-20240229\",
            \"max_tokens\": 200,
            \"messages\": [{
                \"role\": \"user\",
                \"content\": $(printf '%s' "$prompt" | jq -R -s .)
            }]
        }" 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$response" ]]; then
        # Extract the content from Claude's response
        echo "$response" | jq -r '.content[0].text' 2>/dev/null || echo "Failed to parse Claude response"
    else
        echo "Failed to get response from Claude API"
        return 1
    fi
}

# Function to show rofi error dialog
show_error_dialog() {
    local title="$1"
    local message="$2"
    
    # Use rofi to show error with proper text wrapping
    rofi -e "$message" -theme-str '
    window {
        width: 60%;
        height: 40%;
        padding: 20px;
    }
    textbox {
        text-color: rgba(255, 100, 100, 1);
        font: "JetBrains Mono Nerd Font 11";
        padding: 15px;
        margin: 10px;
    }
    '
}

# Main rebuild function
main() {
    # Check if we're in the right directory
    if [[ ! -f "$FLAKE_DIR/flake.nix" ]]; then
        error "Flake directory not found: $FLAKE_DIR"
        show_error_dialog "Rebuild Error" "Flake directory not found: $FLAKE_DIR"
        exit 1
    fi
    
    # Change to flake directory
    cd "$FLAKE_DIR"
    
    # Auto-stage any untracked .nix files
    if git status --porcelain | grep -q "^??.*\.nix$"; then
        log "Auto-staging untracked .nix files..."
        git add *.nix **/*.nix 2>/dev/null || true
        notify-send "NixOS Rebuild" "Auto-staged untracked .nix files, starting rebuild..." -i system-software-update -r 12345
    else
        notify-send "NixOS Rebuild" "Starting system rebuild..." -i system-software-update -r 12345
    fi
    
    log "Starting NixOS rebuild..."
    
    # Run nixos-rebuild and capture output
    if sudo nixos-rebuild switch --flake . > "$LOG_FILE" 2>&1; then
        # Success
        log "Rebuild completed successfully!"
        notify-send "NixOS Rebuild" "System rebuild completed successfully!" -i dialog-information -r 12345
        
        # Show brief summary of what changed
        if grep -q "building the system configuration" "$LOG_FILE"; then
            local built_count
            built_count=$(grep -c "building " "$LOG_FILE" 2>/dev/null || echo "unknown")
            sleep 2
            notify-send "NixOS Rebuild" "Built $built_count packages" -i system-software-update -r 12345
        fi
    else
        # Failure
        error "Rebuild failed!"
        
        # Extract the most relevant error from the log
        local error_summary
        error_summary=$(tail -n 20 "$LOG_FILE" | grep -E "(error:|Error:|failed|Failed)" | head -n 5 | tr '\n' ' ')
        
        if [[ -z "$error_summary" ]]; then
            error_summary=$(tail -n 10 "$LOG_FILE" | tr '\n' ' ')
        fi
        
        notify-send "NixOS Rebuild" "Rebuild failed - checking error..." -i dialog-error -r 12345
        
        # Try to get Claude's interpretation
        info "Analyzing error with Claude AI..."
        local claude_interpretation
        if claude_interpretation=$(interpret_error_with_claude "$error_summary"); then
            local full_message="❌ NixOS Rebuild Failed

🤖 AI Analysis:
$claude_interpretation

📋 Raw Error:
$error_summary

💡 Tip: Check the full log at: $LOG_FILE"
            
            show_error_dialog "Rebuild Failed" "$full_message"
        else
            # Fallback if Claude API fails
            local fallback_message="❌ NixOS Rebuild Failed

📋 Error Summary:
$error_summary

💡 Tips:
• Check for syntax errors in .nix files
• Ensure all imports are valid
• Try 'nix flake check' to validate flake
• Check the full log at: $LOG_FILE"
            
            show_error_dialog "Rebuild Failed" "$fallback_message"
        fi
        
        exit 1
    fi
    
    # Clean up old logs (keep last 5)
    find /tmp -name "nixos-rebuild-*.log" -type f -printf '%T@ %p\n' | sort -n | head -n -5 | cut -d' ' -f2- | xargs -r rm 2>/dev/null || true
}

# Check dependencies
if ! command -v jq &> /dev/null; then
    error "jq is required for Claude API integration"
    show_error_dialog "Missing Dependency" "jq is required for AI error interpretation. Please install it."
    exit 1
fi

# Run main function
main "$@"