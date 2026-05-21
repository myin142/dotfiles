#!/bin/sh

INPUT="${1:-$HOME/.wallpaper.png}"

if [ -z "$INPUT" ]; then
    echo "Usage: blur.sh <image-path>" >&2
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: file not found: $INPUT" >&2
    exit 1
fi

magick convert -filter Gaussian -resize 20% -blur 0x2.5 -resize 500% "$INPUT" /tmp/lockscreen-blur.png
magick convert /tmp/lockscreen-blur.png \( +clone -fill "rgba(0,0,0,0.5)" -draw "color 0,0 reset" \) -composite $HOME/.lockscreen.png