#!/bin/zsh
# shellcheck shell=bash

# generate url list from downloaded music (yt-dlp)
# required: python, mutagen

for f in $@; do
  echo $(mid3v2 -l "$f" | grep TXXX=purl | cut -d'=' -f3-) >> url-list.txt
done

notify-send "URL extraction done"
