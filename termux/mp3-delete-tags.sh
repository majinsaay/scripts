#!/bin/zsh
# shellcheck shell=bash

# delete some tags in all mp3 files.
# required: python, mutagen

for i in *.{mp3,MP3}(N); do
  mid3v2 --delete-frame="COMM:ID3v1 Comment:eng,TXXX:comment,TXXX:description,TXXX:synopsis" "$i"
  echo "$i done"
done
