#!/bin/zsh
# shellcheck shell=bash

# convert all jpg to png.
# required: imagemagick

# convert
mkdir -p .old-image
for i in *.{jpg,JPG,jpeg,JPEG}(N); do
  convert "$i" "${i%.*}.png"
  touch -r "$i" "${i%.*}.png"
  mv "$i" .old-image
  echo "${i%.*}.png done"
done

echo ""
echo "DONE"
echo ""
echo "Press any key to exit..."
