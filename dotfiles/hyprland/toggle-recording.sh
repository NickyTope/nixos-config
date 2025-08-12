#!/usr/bin/env bash

# Toggle screen recording script
# First press: starts recording with region selection
# Second press: stops recording

# Check if wl-screenrec is running
if pgrep -x "wl-screenrec" > /dev/null; then
    # Recording is active, stop it
    pkill wl-screenrec
    notify-send "Screen Recording" "Recording stopped" -t 2000
else
    # No recording active, start one
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
        echo "Press Super+R again to stop recording"
        
        # Notify user that recording started
        notify-send "Screen Recording" "Recording started\nFile: screenrec_${TIMESTAMP}.mp4\nPress Super+R again to stop" -t 3000
        
        # Start recording in background so script can exit
        nohup wl-screenrec --codec auto -g "$GEOMETRY" -f "$FILENAME" > /dev/null 2>&1 &
        
        # Wait a moment then check if recording actually started
        sleep 1
        if pgrep -x "wl-screenrec" > /dev/null; then
            echo "Recording started successfully"
        else
            notify-send "Screen Recording" "Failed to start recording" -t 3000
        fi
    else
        echo "Region selection cancelled"
        notify-send "Screen Recording" "Recording cancelled" -t 2000
    fi
fi