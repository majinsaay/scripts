#!/bin/zsh
# shellcheck shell=bash

# resize and compress all mkv files. (x264)
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
  res=$(ffmpeg -i "$file" 2>&1 | grep 'Stream #0:0.*Video' | grep -oP '\d{2,4}x\d{2,4}')
  width=$(echo $res | cut -d'x' -f1)
  height=$(echo $res | cut -d'x' -f2)
  if [ "$width" -gt "$height" ]; then
    ffmpeg -i "$file" -map 0 -c:v libx264 -preset veryfast -crf 24 -vf "format=yuv420p,scale=-2:1080" -c:a libopus -b:a 128k -c:s copy "${file%.*}.temp.mkv"
  else
    ffmpeg -i "$file" -map 0 -c:v libx264 -preset veryfast -crf 24 -vf "format=yuv420p,scale=1080:-2" -c:a libopus -b:a 128k -c:s copy "${file%.*}.temp.mkv"
  fi
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
