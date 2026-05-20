#!/bin/zsh
# shellcheck shell=bash

# convert all jpg to jpg.
# required: imagemagick

# convert
mkdir -p .old-image
for i in *.{png,PNG}(N); do
  convert "$i" "${i%.*}.jpg"
  touch -r "$i" "${i%.*}.jpg"
  mv "$i" .old-image
  echo "${i%.*}.jpg done"
done

echo ""
echo "DONE"
echo ""
echo "Press any key to exit..."
