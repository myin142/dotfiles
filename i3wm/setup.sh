#!/bin/sh

link() {
	if [ -d "$2" ]; then
		echo "Deleting existing $2"
		rm "$2" -r
	fi
	ln -sf "$(pwd)/$1" "$2"
}

sudo pacman -S i3-gaps i3blocks i3lock picom dunst redshift rofi rofi-calc kitty \
    python-pywal feh net-tools noto-fonts-cjk noto-fonts-emoji ibus ibus-sunpinyin ibus-anthy jq flameshot \
    cronie light

link i3 $HOME/.config/i3
link kitty $HOME/.config/kitty
link dunst $HOME/.config/dunst
link rofi $HOME/.config/rofi
link picom $HOME/.config/picom
link redshift $HOME/.config/redshift
link fonts $HOME/.local/share/fonts

link img/lockscreen.png $HOME/.lock.png
link img/wallpaper.png $HOME/.wallpaper.png
