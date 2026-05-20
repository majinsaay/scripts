#!/bin/zsh
# shellcheck shell=bash

# delete some tags in all mp3 files.
# required: python, mutagen

mkdir -p .old-music
for f in $@; do
  cp "$f" .old-music
  mid3v2 --delete-frame="COMM:ID3v1 Comment:eng,TALB,TCON,TDRC,TPE2,TRCK,TSSE,TXXX:comment,TXXX:Cover Artist,TXXX:description,TXXX:synopsis,TYER" "$f"
done

notify-send "Tag deletion done"
