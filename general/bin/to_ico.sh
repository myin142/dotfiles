#!/bin/sh

SOURCE="${1:-icon.png}"
magick convert -background transparent -define 'icon:auto-resize=256,128,64,48,32,16' "$SOURCE" icon.ico
