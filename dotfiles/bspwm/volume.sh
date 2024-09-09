#!/usr/bin/env bash

if [ $# -eq 1 ]; then
  pw-volume change "$1"
fi

NOTIFY_ID=1337

VOLUME=$(pw-volume status | jq .percentage)

ICON=audio-volume-low
if [ "$VOLUME" -ge "70" ]; then
  ICON=audio-volume-high
elif [ "$VOLUME" -ge "33" ]; then
  ICON=audio-volume-medium
fi

BAR=""
for ((i = 0 ; i < 101 ; i+=10)); do
  if [ "$VOLUME" -eq 0 ]; then
    BAR="$BAR"
  elif [ "$VOLUME" -ge "$i" ]; then
    BAR="$BAR█"
  elif [ "$VOLUME" -ge $(($i-5)) ]; then
    BAR="$BAR▌"
  else
    BAR="$BAR "
  fi
done
BAR="$BAR\\n▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"


notify-send  "volume - ${VOLUME}" "${BAR}" --print-id --replace-id=${NOTIFY_ID} --icon=${ICON} --urgency=low --expire-time=1000

# echo $NEW_ID > /tmp/vol

