#!/bin/sh

IMAGE="$1"

if [ -z "$IMAGE" ]; then
	echo "Usage: $0 <image|directory>" >&2
	exit 2
fi

if [ -d "$IMAGE" ]; then
	IMAGE="$(find "$IMAGE" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n1)"
	if [ -z "$IMAGE" ]; then
		echo "No png/jpg/jpeg files found in directory: $1" >&2
		exit 1
	fi
fi

FULL_PATH="$(realpath "$IMAGE")"
echo "Setting wallpaper to: $FULL_PATH"

ln -sf "$FULL_PATH" "$HOME/.wallpaper.png"
swaymsg output "*" bg "$HOME/.wallpaper.png" fill
create-lock.sh "$FULL_PATH"
matugen image --source-color-index 0 "$FULL_PATH"
