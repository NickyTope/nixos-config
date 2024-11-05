#!/usr/bin/env bash

# Fetch the latest update time for the nixos-unstable channel
last_update=$(curl -s https://prometheus.nixos.org/api/v1/query\?query=channel_update_time | jq '.data.result[] | select(.metric.channel=="nixos-unstable") | .value[1] |= tonumber | .value[1]')

# Convert to human-readable format
last_update_readable=$(date -d @$last_update +"%a %e")

# Output the result
echo $last_update_readable

