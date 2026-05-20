#!/bin/zsh
# shellcheck shell=bash

# resize and compress all mp4 files. (x264)
# required: ffmpeg

mkdir -p .old-video
for f in $@; do
  res=$(ffmpeg -i "$f" 2>&1 | grep 'Stream #0:0.*Video' | grep -oP '\d{2,4}x\d{2,4}')
  width=$(echo $res | cut -d'x' -f1)
  height=$(echo $res | cut -d'x' -f2)
  if [ "$width" -gt "$height" ]; then
    ffmpeg -i "$f" -map 0 -movflags +faststart -c:v libx264 -preset veryfast -crf 23 -vf "format=yuv420p,scale=-2:720" -c:a aac -b:a 160k "${f%.*}.temp.mp4"
  else
    ffmpeg -i "$f" -map 0 -movflags +faststart -c:v libx264 -preset veryfast -crf 23 -vf "format=yuv420p,scale=720:-2" -c:a aac -b:a 160k "${f%.*}.temp.mp4"
  fi
  touch -r "$f" "${f%.*}.temp.mp4"
  mv "$f" .old-video
  mv "${f%.*}.temp.mp4" "$f"
done

notify-send "Compression done"
