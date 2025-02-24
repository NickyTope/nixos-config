#!/usr/bin/env bash

killall polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
big=$(xrandr --listmonitors | grep 5120/ | wc -l)

polybar main -c $(dirname $0)/config.ini --reload &
[ "$big" == "1" ] && polybar wide -c $(dirname $0)/config.ini --reload &
