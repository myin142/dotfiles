#!/bin/sh
# Deps: yazi, matugen, pywal

FILE="$1"
if [[ -z $FILE ]]; then
    yazi --chooser-file=temp ~/Wallpapers
    FILE="$(cat ~/Wallpapers/temp)"
fi

FILE="$(realpath $1)"
if [[ ! -f $FILE ]]; then
    echo "Invalid file"
    exit 1
fi

if [[ -z $(file $FILE | grep -e JPEG -e PNG -e JPG) ]]; then
    echo "Not an image file"
    exit 1
fi


echo $FILE
matugen image $FILE --source-color-index 0
wal -i $FILE

pkill -f -9 hyprpaper && nohup hyprpaper >/dev/null 2>&1 &
