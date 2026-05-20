#!/bin/zsh
# shellcheck shell=bash

# compress all mp4 files. (x265)
# required: ffmpeg

# create empty lists
touch .list-mp4.txt .to-compress-mp4.txt .compressed-mp4.txt

# create mp4 file list
ls *.{mp4,MP4}(N) > .list-mp4.txt

# create to-compress-mp4 list
diff --suppress-common-lines .list-mp4.txt .compressed-mp4.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-mp4.txt

# compress and add to compressed-mp4
tocom=$(cat .to-compress-mp4.txt)
mkdir -p .old-video
for file in $tocom; do
  ffmpeg -i "$file" -map 0 -movflags +faststart -c:v libx265 -preset ultrafast -crf 28 -c:a aac -b:a 160k -vf format=yuv420p "${file%.*}.temp.mp4"
  touch -r "$file" "${file%.*}.temp.mp4"
  mv "$file" .old-video
  mv "${file%.*}.temp.mp4" "$file"
  echo "$file done"
  echo "${file}" >> .compressed-mp4.txt
done

# cleanup
rm -rf .list-mp4.txt .to-compress-mp4.txt

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
