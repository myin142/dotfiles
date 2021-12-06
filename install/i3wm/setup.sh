#!/bin/sh

link() {
	if [ -d "$2" ]; then
        echo "Deleting existing $2"
		rm "$2"
	fi
	ln -sf "$(pwd)/$1" "$2"
}

sudo pacman -Syy i3-gaps i3blocks i3lock compton dunst redshift rofi rofi-calc kitty \
    python-pywal feh net-tools noto-fonts-emoji ibus ibus-rime ibus-anthy jq flameshot

link i3 $HOME/.config/i3
link kitty $HOME/.config/kitty
link dunst $HOME/.config/dunst
link rofi $HOME/.config/rofi
link picom $HOME/.config/picom
link redshift $HOME/.config/redshift
link fonts $HOME/.local/share/fonts

link img/lockscreen.png $HOME/.lock.png
link img/wallpaper.png $HOME/.wallpaper.png
