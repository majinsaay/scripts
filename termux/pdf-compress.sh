#!/bin/zsh
# shellcheck shell=bash

# compress all pdf files.
# required: ghostscript

# create empty lists
touch .list-pdf.txt .to-compress-pdf.txt .compressed-pdf.txt

# create pdf file list
ls *.{pdf,PDF}(N) > .list-pdf.txt

# create to-compress list
diff --suppress-common-lines .list-pdf.txt .compressed-pdf.txt | grep "^<\|^>" | sed "s/^. //g" > .to-compress-pdf.txt

# compress and add to compressed
tocom=$(cat .to-compress-pdf.txt)
mkdir -p .old-pdf
for file in $tocom; do
  gs -dQUIET -dNOPAUSE -dBATCH -dSAFER -dOverPrint=/simulate -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dEmbedAllFonts=true -dSubsetFonts=true -dAutoRotatePages=/None -dColorImageDownsampleType=/Bicubic -dColorImageResolution=150 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=150 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=150 -sOutputFile="${file%.*}.temp.pdf" "$file"
  touch -r "$file" "${file%.*}.temp.pdf"
  mv "$file" .old-pdf
  mv "${file%.*}.temp.pdf" "$file"
  echo "$file done"
  echo "${file}" >> .compressed-pdf.txt
done

# cleanup
rm -rf .list-pdf.txt .to-compress-pdf.txt

echo ""
echo "Done"
echo ""
echo "Press any key to exit..."
read -k 1 -r -s
