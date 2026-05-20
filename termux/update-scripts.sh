#!/bin/zsh
# shellcheck shell=bash

# update scripts and add new ones to zsh alias.
# required: git

# remove old repo dir
rm -rf ~/.scripts

# clone repo
git clone --single-branch --branch main https://github.com/majinsaay/scripts.git ~/.scripts

# change working dir
cd ~/.scripts || exit 1

# make executable
chmod u+x *

# scripts aliases block variables
BEGIN_MARKER="# === SCRIPTS ALIASES - BEGIN ==="
END_MARKER="# === SCRIPTS ALIASES - END ==="

# delete old block
sed -i "/$BEGIN_MARKER/,/$END_MARKER/d" ~/.zshrc

# generate new block beginning
echo "" >> ~/.zshrc
echo "$BEGIN_MARKER" >> ~/.zshrc
echo "" >> ~/.zshrc

# make alias for each script
for i in *.sh; do
  echo -e "alias ${i%.sh}='. ~/.scripts/$i'" >> ~/.zshrc
done

# close block
echo "" >> ~/.zshrc
echo "$END_MARKER" >> "$ZSHRC"

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
