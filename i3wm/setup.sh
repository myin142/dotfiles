#!/bin/sh

link() {
	if [ -d "$2" ]; then
		echo "Deleting existing $2"
		rm "$2" -r
	fi
	ln -sf "$(pwd)/$1" "$2"
}

sudo pacman -S dunst rofi rofi-calc kitty \
    matugen feh net-tools noto-fonts-cjk noto-fonts-emoji jq \
    cronie brightnessctl \
    sway swaylock swayidle swaybg waybar gammastep \
    fcitx5 fcitx5-rime fcitx5-anthy fcitx5-hangul \
    xdg-desktop-portal xdg-desktop-portal-wlr grim

link kitty $HOME/.config/kitty
link dunst $HOME/.config/dunst
link rofi $HOME/.config/rofi
link fonts $HOME/.local/share/fonts

# Wayland stuff
link sway $HOME/.config/sway
link waybar $HOME/.config/waybar
link gammastep $HOME/.config/gammastep

