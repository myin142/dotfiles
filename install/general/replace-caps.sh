#!/bin/sh

cp xorg.conf.d/00-keyboard.conf /usr/share/X11/xorg.conf.d/
ln -sf "$(pwd)/Xmodmap" ~/.Xmodmap
