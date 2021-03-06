#!/bin/sh

pacman -S xf86-input-wacom keychain

if [ -d "$HOME/.bin" ]; then
	echo "Deleting existing bin folder"
    rm "$HOME/.bin"
fi
ln -sf $(pwd)/bin ~/.bin

ln -sf $(pwd)/bashrc ~/.bashrc
ln -sf "$(pwd)/xorg.conf.d/00-keyboard.conf" /usr/share/X11/xorg.conf.d/
ln -sf "$(pwd)/Xmodmap" ~/.Xmodmap
