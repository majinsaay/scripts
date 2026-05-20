#!/bin/zsh
# shellcheck shell=bash

# generate url list from downloaded music (yt-dlp)
# required: python, mutagen

for i in *.{mp3,MP3}(N); do
  echo $(mid3v2 -l "$i" | grep TXXX=purl | cut -d'=' -f3-) >> url-list.txt
done

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
