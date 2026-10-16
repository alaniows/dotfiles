#!/bin/bash

# Usamos @DEFAULT_AUDIO_SINK@ para que siempre tome el que marcamos como default

vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')

vol=${vol%.*}

if [ "$vol" -ge 100 ]; then

    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1
else
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+

fi
