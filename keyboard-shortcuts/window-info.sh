#!/bin/zsh
# shellcheck shell=bash

notify-send "$(xdotool getwindowfocus getwindowgeometry)"
