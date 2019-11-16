#!/bin/sh

[ -z "$1" ] && echo "User required" && exit
USER="$1"

sudo pacman --noconfirm -S - < packages
sudo pkgfile -u

./scripts/disable-pcspkr.sh
./scripts/copy-config.sh "$1"
./scripts/install-aur.sh yay
