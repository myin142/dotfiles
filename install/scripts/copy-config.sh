#!/bin/sh

[[ -z "$1" ]] && echo "Need User" && exit

USER="$1"
USER_HOME="/home/$USER"

[[ ! -d "$USER_HOME" ]] && echo "Invalid User" && exit

DOTFILES="$USER_HOME/.dotfiles"

linkFile() {
	ln -sf $DOTFILES/$1 $USER_HOME/$2
}

linkFolder() {
	SOURCE="$DOTFILES/$1"
	TARGET="$USER_HOME/$2"

	if [[ ! -d "$TARGET" ]]; then
		ln -sf "$SOURCE" "$TARGET"
	else
		echo "Folder: $TARGET, not copied. It already exists"
	fi
}

linkFile config/Xmodmap .Xmodmap
linkFile config/bashrc .bashrc
linkFile config/vimrc .vimrc

linkFolder config/i3 .config/i3
linkFolder config/kitty .config/kitty
linkFolder config/rofi .config/rofi
linkFolder config/dunst .config/dunst
linkFolder config/compton .config/compton
linkFolder config/redshift .config/redshift

linkFolder config/nvim .config/nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

linkFolder fonts .local/share/fonts
linkFolder vim .vim
linkFolder bin .bin

linkFile img/wallpaper.png .wallpaper.png
