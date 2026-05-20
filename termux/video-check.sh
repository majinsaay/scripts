#!/bin/zsh
# shellcheck shell=bash

# check integrity of all mp4 and mkv files.
# required: ffmpeg

# variables
total=0
errors=0

# colors
LR='\e[1;31m' # light red
LG='\e[1;32m' # light green
LB='\e[1;34m' # light blue
R='\e[0m'     # reset color / no color

for i in *.{mp4,MP4,mkv,MKV}(N); do
  total=$((total + 1))
  echo "${LG}Verifying: ${R}$i"
  ffmpeg -v error -i "$i" -f null - 2>"${i}.log"
  if [[ -s "${i}.log" ]]; then
    errors=$((errors + 1))
    echo "${LR}ERROR"
    echo "=== $i ===" >> error.log
    cat "${i}.log" >> error.log
    echo "" >> error.log
    rm -f "${i}.log"
  else
    echo "${LB}OK"
    rm -f "${i}.log"
  fi
done

echo ""
echo "${R}================================"
echo "Verification done!"
echo "Files: $total"
echo "Errors: $errors"
echo "OK: $((total - errors))"

if [[ $errors -gt 0 ]]; then
  echo ""
  echo "${LR}See details in: ${R}error.log"
else
  echo ""
  echo "${LB}All files are OK!"
  rm -f error.log
fi

echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
