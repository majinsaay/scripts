#!/bin/zsh
# shellcheck shell=bash

# convert all jpg to png.
# required: imagemagick

mkdir -p .old-image
for f in $@; do
  magick "$f" "${f%.*}.png"
  touch -r "$f" "${f%.*}.png"
  mv "$f" .old-image
done

notify-send "Conversion done"
