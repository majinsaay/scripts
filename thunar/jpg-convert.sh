#!/bin/zsh
# shellcheck shell=bash

# convert all images to jpg.
# required: imagemagick

mkdir -p .old-image
for f in $@; do
  magick "$f" "${f%.*}.jpg"
  touch -r "$f" "${f%.*}.jpg"
  mv "$f" .old-image
done

notify-send "Conversion done"
