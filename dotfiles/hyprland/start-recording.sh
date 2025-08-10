#!/usr/bin/env bash

# Screen recording script using wl-screenrec and slurp for region selection
# Records to ~/Videos with timestamp-based filename

# Create Videos directory if it doesn't exist
mkdir -p ~/Videos

# Generate filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$HOME/Videos/screenrec_${TIMESTAMP}.mp4"

# Use slurp to select region and start recording
GEOMETRY=$(slurp)
if [ $? -eq 0 ]; then
    # Start recording with selected geometry
    echo "Starting screen recording to: $FILENAME"
    echo "Recording region: $GEOMETRY"
    echo "Press Ctrl+C to stop recording, or use: pkill wl-screenrec"
    
    # Notify user that recording started
    notify-send "Screen Recording" "Recording started\nFile: screenrec_${TIMESTAMP}.mp4\nPress Ctrl+C or Super+R to stop" -t 3000
    
    # Try with software encoding first to avoid hardware issues
    wl-screenrec --no-hw --codec avc -g "$GEOMETRY" -f "$FILENAME" -v
    
    # Notify when recording stops
    if [ -f "$FILENAME" ]; then
        notify-send "Screen Recording" "Recording saved to ~/Videos/screenrec_${TIMESTAMP}.mp4" -t 5000
    fi
else
    echo "Region selection cancelled"
    notify-send "Screen Recording" "Recording cancelled" -t 2000
fi