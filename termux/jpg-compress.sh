#!/bin/zsh
# shellcheck shell=bash

# compress all jpg files.
# required: imagemagick

# create empty lists
touch .list-jpg.txt .to-compress-jpg.txt .compressed-jpg.txt

# create jpg file list
ls *.{jpg,JPG,jpeg,JPEG}(N) > .list-jpg.txt

# create to-compress-jpg list
diff --suppress-common-lines .list-jpg.txt .compressed-jpg.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-jpg.txt

# compress and add to compressed-jpg
tocom=$(cat .to-compress-jpg.txt)
mkdir -p .old-image
for file in $tocom; do
  magick -sampling-factor 4:2:0 -interlace Plane -quality 80 "$file" "${file%.*}.temp.jpg"
  touch -r "$file" "${file%.*}.temp.jpg"
  mv "$file" .old-image
  mv "${file%.*}.temp.jpg" "$file"
  echo "$file done"
  echo "$file" >> .compressed-jpg.txt
done

# cleanup
rm -f .list-jpg.txt .to-compress-jpg.txt

echo ""
echo "DONE"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
