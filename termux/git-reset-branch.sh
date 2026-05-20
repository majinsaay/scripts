#!/bin/zsh
# shellcheck shell=bash

# reset any branch, deleting all commit history but keeping files.
# required: git

# colors
LG='\e[1;32m' # light green
LB='\e[1;34m' # light blue
R='\e[0m'     # reset color / no color

git checkout --orphan latest_branch
git add -A
echo "${LG}Enter branch name"
echo "${R}Press ENTER for default name (main)"
read BRANCH
if [ $BRANCH ]; then
  sleep 0s
else
  BRANCH="main"
fi
echo "${LG}Enter commit message${R}"
read commit
git commit -m "$commit"
git branch -D $BRANCH
git branch -m $BRANCH
git push -f origin $BRANCH

echo ""
echo "${LB}DONE"
echo ""
echo "${R}Press any key to exit..."
read -k 1 -r -s
