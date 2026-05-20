#!/bin/zsh
# shellcheck shell=bash

# crop thumbnails in all mp3 files.
# required: ffmpeg

mkdir -p .old-music
for f in $@; do
  ffmpeg -i "$f" -vf "crop=min(iw\,ih):min(iw\,ih),scale=720:720" -map 0:a -map 0:v -c:a copy -c:v mjpeg -q:v 3 -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (Front)" "${f%.*}.temp.mp3"
  touch -r "$f" "${f%.*}.temp.mp3"
  mv "$f" .old-music
  mv "${f%.*}.temp.mp3" "$f"
done

notify-send "Crop done"
