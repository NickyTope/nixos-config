#!/usr/bin/env bash

system76-power profile | grep "Power Profile" | awk '{ print $3; }'
