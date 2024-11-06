#!/usr/bin/env bash

count=0
for monitor in $(bspc query -M); do
  echo $monitor
  let count++
done

if [ "$(hostname)" == "nt-arch-sfc" ]; then
  if [ $count == 1 ]
  then
    bspc monitor ^1 -d term api webfront config five web chat win nine ten
  elif [ $count == 2 ]
  then
    bspc monitor ^1 -d term api webfront config five
    bspc monitor ^2 -d web chat win nine ten 
  elif [ $count == 3 ]
  then
    bspc monitor ^1 -d api webfront config five
    bspc monitor ^2 -d web chat win nine ten
    bspc monitor ^3 -d term
  fi
fi

if [ "$(hostname)" == "mininix" ]; then
  if [ $count == 1 ]
  then
    bspc monitor ^1 -d term api webfront config five web chat win nine ten
  elif [ $count == 2 ]
  then
    bspc monitor ^1 -d term api webfront config five
    bspc monitor ^2 -d web chat win nine ten
  fi
fi

if [ "$(hostname)" == "nt-oryx" ]; then
  echo "Oryx setup with $count monitors"
  if [ $count == 1 ]
  then
    bspc monitor ^1 -d term api webfront config five web chat win nine ten
  elif [ $count == 2 ]
  then
    bspc monitor ^1 -d term 
    bspc monitor ^2 -d api webfront config five web chat win nine ten
  fi
fi

# echo ${#monitors[@]}

