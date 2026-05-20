#!/bin/zsh
# shellcheck shell=bash

# compress all png files.
# required: oxipng

# create empty lists
touch .list-png.txt .to-compress-png.txt .compressed-png.txt

# create png file list
ls *.{png,PNG}(N) > .list-png.txt

# create to-compress-png list
diff --suppress-common-lines .list-png.txt .compressed-png.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-png.txt

# compress and add to compressed-png
tocom=$(cat .to-compress-png.txt)
mkdir -p .old-image
for file in $tocom; do
  oxipng -q -o 2 --out="${file%.*}.temp.png" "$file"
  touch -r "$file" "${file%.*}.temp.png"
  mv "$file" .old-image
  mv "${file%.*}.temp.png" "$file"
  echo "$file done"
  echo "${file}" >> .compressed-png.txt
done

# cleanup
rm -rf .list-png.txt .to-compress-png.txt

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
