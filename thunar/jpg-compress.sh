#!/bin/zsh
# shellcheck shell=bash

# compress all jpg files.
# required: imagemagick

mkdir -p .old-image
for f in $@; do
  magick -sampling-factor 4:2:0 -interlace Plane -quality 80 "$f" "${f%.*}.temp.jpg"
  touch -r "$f" "${f%.*}.temp.jpg"
  mv "$f" .old-image
  mv "${f%.*}.temp.jpg" "$f"
done

notify-send "Compression done"
