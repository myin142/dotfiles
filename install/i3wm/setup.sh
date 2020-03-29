#!/bin/sh

link() {
	if [ -f "$2" ]; then
		rm "$2"
	fi
	ln -s "$(pwd)/$1" "$2"
}

sudo pacman -S i3-gaps i3blocks i3lock compton dunst redshift rofi kitty python-pywal feh

link i3 $HOME/.config/i3
link kitty $HOME/.config/kitty
link dunst $HOME/.config/dunst
link rofi $HOME/.config/rofi
link compton $HOME/.config/compton
link redshift $HOME/.config/redshift
link fonts $HOME/.local/share/fonts

link img/lockscreen.png $HOME/.lock.png
link img/wallpaper.png $HOME/.wallpaper.png
