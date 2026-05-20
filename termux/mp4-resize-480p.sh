#!/bin/zsh
# shellcheck shell=bash

# resize and compress all mp4 files. (x264)
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
  res=$(ffmpeg -i "$file" 2>&1 | grep 'Stream #0:0.*Video' | grep -oP '\d{2,4}x\d{2,4}')
  width=$(echo $res | cut -d'x' -f1)
  height=$(echo $res | cut -d'x' -f2)
  if [ "$width" -gt "$height" ]; then
    ffmpeg -i "$file" -map 0 -movflags +faststart -c:v libx264 -preset veryfast -crf 22 -vf "format=yuv420p,scale=-2:480" -c:a aac -b:a 160k "${file%.*}.temp.mp4"
  else
    ffmpeg -i "$file" -map 0 -movflags +faststart -c:v libx264 -preset veryfast -crf 22 -vf "format=yuv420p,scale=480:-2" -c:a aac -b:a 160k "${file%.*}.temp.mp4"
  fi
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
