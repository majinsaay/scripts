#!/bin/zsh
# shellcheck shell=bash

# check if any process is using a file and prompts for termination.

# colors
LR='\e[1;31m' # light red
LG='\e[1;32m' # light green
LY='\e[1;33m' # light yellow
LB='\e[1;34m' # light blue
R='\e[0m'     # reset color / no color

# variables
PID=$(lsof -t $1)

if [ -z "$PID" ]; then
  echo "${LG}No process using the file ${R}$1"
  echo ""
  echo "Press any key to exit."
  read -k 1 -r -s
  exit
fi

echo "$1 is being used"
lsof $1
echo ""
echo "${LG}Kill process? ${R}(${LY}y${R}/${LY}n${R})"
read -k 1 response
echo ""

if [[ "$response" = y ]]; then
  echo "$PID" | xargs kill -9
  echo "${LB}Process killed."
else
  echo "${LR}Operation canceled."
fi

echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
