#!/bin/zsh
# shellcheck shell=bash

# sound
pw-play /usr/share/sounds/freedesktop/stereo/camera-shutter.oga &

# screenshot
FILE="$HOME/Pictures/Screenshots/S_$(date +%Y%m%d_%H%M%S%3N).png"
xfce4-screenshooter -s "$FILE" -cmf
