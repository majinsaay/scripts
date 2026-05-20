#!/bin/zsh
# shellcheck shell=bash

# generate url list for all your music from vimusic backup db (playlists)
# also works for forks, tested on vitune and rimusic
# required: sqlite

# extract sql to csv (playlist)
for db in *.{db,DB}(N); do
  sqlite3 -csv "${db}" "select id,name from Playlist;" > playlist.csv
done

# extract sql to csv (playlist song map)
for db in *.db; do
  sqlite3 -csv "${db}" "select songId,playlistId from SongPlaylistMap;" > playlistmap.csv
done

# playlist id + name
playlists=$(cat playlist.csv)

# replace white space
playlists=${playlists// /_}

# remove double quote symbol
playlists=${playlists//\"/}

# playlist id
playlistid=$(cat playlist.csv | cut -d',' -f1)

# write playlist id + name
for i in $playlists; do
  echo "${i}" >> playlist.txt
done

# write song id
for i in $playlistid; do
  id=$(grep ,$i playlistmap.csv | cut -d',' -f1)
  echo "${id}" >> ${i}.txt
done

# input url
for i in $playlistid; do
  for id in $(cat ${i}.txt); do echo "https://music.youtube.com/watch?v=${id}" >> ${i}-url.txt; done
  rm -f ${i}.txt
done

# rename txt files
for i in $(cat playlist.txt); do
  name=$(grep $i playlist.txt | cut -d',' -f2-)
  id=$(grep $i playlist.txt | cut -d',' -f1)
  mv ${id}-url.txt ${name}.txt
done

# cleanup
rm -rf playlistmap.csv playlist.csv playlist.txt

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
