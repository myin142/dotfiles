#!/bin/sh

WALLPAPER_DIR="${1:-$HOME/Wallpapers}"

if [ ! -d "$WALLPAPER_DIR" ]; then
	echo "Wallpaper directory not found: $WALLPAPER_DIR" >&2
	exit 1
fi

IMAGE="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) | shuf -n1)"

if [ -z "$IMAGE" ]; then
	echo "No image files found in: $WALLPAPER_DIR" >&2
	exit 1
fi

exec gen-wallpaper.sh "$IMAGE"
