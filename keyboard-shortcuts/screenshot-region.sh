#!/bin/zsh
# shellcheck shell=bash

# screenshot
FILE="$HOME/Pictures/Screenshots/S_$(date +%Y%m%d_%H%M%S%3N).png"
xfce4-screenshooter -s "$FILE" -cr
