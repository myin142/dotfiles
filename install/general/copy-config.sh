#!/bin/sh

DOTFILES="$HOME/.dotfiles"

linkFile() {
	ln -sf $DOTFILES/$1 $HOME/$2
}

linkFolder() {
	SOURCE="$DOTFILES/$1"
	TARGET="$HOME/$2"

	if [[ ! -d "$TARGET" ]]; then
		ln -sf "$SOURCE" "$TARGET"
	else
		echo "Folder: $TARGET, not copied. It already exists"
	fi
}

linkFile config/Xresources .Xresources
linkFile config/xinitrc .xinitrc
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
