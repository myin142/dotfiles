#!/bin/sh

sudo pacman -S fakeroot binutils make gcc

TEMP="/tmp/install-yay"

[ ! -d "$TEMP" ] && mkdir -p "$TEMP"

git clone "https://aur.archlinux.org/yay.git" "$TEMP"
cd $TEMP
makepkg -si

rm $TEMP -r
