#!/bin/zsh

if pgrep -f simplescreenrecorder; then
    exit 0
else
    simplescreenrecorder --start-hidden --start-recording
fi
