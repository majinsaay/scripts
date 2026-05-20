#!/bin/zsh
# shellcheck shell=bash

# compress all pdf files.
# required: ghostscript

mkdir -p .old-pdf
for f in $@; do
  gs -dQUIET -dNOPAUSE -dBATCH -dSAFER -dOverPrint=/simulate -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dEmbedAllFonts=true -dSubsetFonts=true -dAutoRotatePages=/None -dColorImageDownsampleType=/Bicubic -dColorImageResolution=150 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=150 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=150 -sOutputFile="${f%.*}.temp.pdf" "$f"
  touch -r "$f" "${f%.*}.temp.pdf"
  mv "$f" .old-pdf
  mv "${f%.*}.temp.pdf" "$f"
done

notify-send "Compression done"
