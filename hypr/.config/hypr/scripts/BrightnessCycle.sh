#!/bin/bash
current=$(brightnessctl get)
max=$(brightnessctl max)
percent=$((current * 100 / max))

if [ "$percent" -ge 90 ]; then
    brightnessctl set 20%
else
    brightnessctl set +20%
fi
