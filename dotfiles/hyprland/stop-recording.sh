#!/usr/bin/env bash

# Script to stop wl-screenrec recording

# Check if wl-screenrec is running
if pgrep -x "wl-screenrec" > /dev/null; then
    echo "Stopping screen recording..."
    pkill wl-screenrec
    notify-send "Screen Recording" "Recording stopped" -t 2000
else
    echo "No active screen recording found"
    notify-send "Screen Recording" "No active recording to stop" -t 2000
fi