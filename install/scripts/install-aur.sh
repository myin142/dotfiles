#!/bin/sh

[ -z "$1" ] && echo "Package name needed" && exit

PACKAGE="$1"
TEMP="/tmp/install-aur"

[ ! -d "$TEMP" ] && mkdir -p "$TEMP"

git clone "https://aur.archlinux.org/$PACKAGE.git" "$TEMP/$PACKAGE"
cd /tmp/install-aur/$PACKAGE
makepkg -si
