#!/bin/zsh
# shellcheck shell=bash

# compress all mkv files. (x265)
# required: ffmpeg

# create empty lists
touch .list-mkv.txt .to-compress-mkv.txt .compressed-mkv.txt

# create mkv file list
ls *.{mkv,MKV}(N) > .list-mkv.txt

# create to-compress-mkv list
diff --suppress-common-lines .list-mkv.txt .compressed-mkv.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-mkv.txt

# compress and add to compressed-mkv
tocom=$(cat .to-compress-mkv.txt)
mkdir -p .old-video
for file in $tocom; do
  ffmpeg -i "$file" -map 0 -c:v libx265 -preset ultrafast -crf 28 -c:a libopus -b:a 128k -c:s copy -vf format=yuv420p "${file%.*}.temp.mkv"
  touch -r "$file" "${file%.*}.temp.mkv"
  mv "$file" .old-video
  mv "${file%.*}.temp.mkv" "$file"
  echo "$file done"
  echo "${file}" >> .compressed-mkv.txt
done

# cleanup
rm -rf .list-mkv.txt .to-compress-mkv.txt

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
