#!/bin/zsh
# shellcheck shell=bash

# crop thumbnails in all mp3 files.
# required: ffmpeg

mkdir -p .old-music
for i in *.{mp3,MP3}(N); do
  ffmpeg -i "$i" -vf "crop=min(iw\,ih):min(iw\,ih),scale=720:720" -map 0:a -map 0:v -c:a copy -c:v mjpeg -q:v 3 -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (Front)" "${i%.*}.temp.mp3"
  touch -r "$i" "${i%.*}.temp.mp3"
  mv "$i" .old-music
  mv "${i%.*}.temp.mp3" "$i"
  echo "$i done"
done

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
