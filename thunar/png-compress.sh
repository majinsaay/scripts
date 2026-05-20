#!/bin/zsh
# shellcheck shell=bash

# compress all png files.
# required: oxipng

mkdir -p .old-image
for f in $@; do
  oxipng -q -o 2 --out="${f%.*}.temp.png" "$f"
  touch -r "$f" "${f%.*}.temp.png"
  mv "$f" .old-image
  mv "${f%.*}.temp.png" "$f"
done

notify-send "Compression done"
