#!/bin/sh

linkFolder(){
	SOURCE="$1"
	TARGET="$2"

	# Remove target to prevent creating link inside folder
	if [ -d "$TARGET" ]; then
		rm "$TARGET" -ri
	fi

	# Target should not exists when creating link
	if [ ! -d "$TARGET" ]; then
		ln -sf "$SOURCE" "$TARGET"
	fi
}

# Setup Git and get dotfiles
if [ ! -d ~/.dotfiles ]; then

	read -p "Git Email: " EMAIL
	read -p "Name: " NAME

	git config --global user.name "$NAME"
	git config --global user.email "$EMAIL"
	git config --global core.editor vim
	git clone --recurse-submodules -j$(nproc) https://github.com/myin142/dotfiles ~/.dotfiles
fi 

# Create Config Links
ln -sf ~/.dotfiles/config/bashrc ~/.bashrc
ln -sf ~/.dotfiles/config/vimrc ~/.vimrc
ln -sf ~/.dotfiles/config/xinitrc ~/.xinitrc
ln -sf ~/.dotfiles/config/gtkrc-2.0 ~/.gtkrc-2.0
ln -sf ~/.dotfiles/config/Xresources ~/.Xresources

if [ ! -d ~/.config ]; then
	mkdir ~/.config
fi

linkFolder ~/.dotfiles/config/i3 ~/.config/i3
linkFolder ~/.dotfiles/config/kitty ~/.config/kitty
linkFolder ~/.dotfiles/config/rofi ~/.config/rofi
linkFolder ~/.dotfiles/config/dunst ~/.config/dunst
linkFolder ~/.dotfiles/config/redshift ~/.config/redshift

# Create Image Links
ln -sf ~/.dotfiles/img/wallpaper.png ~/.wallpaper.png
ln -sf ~/.dotfiles/img/lock.png ~/.lock.png

# Create Other Links
linkFolder ~/.dotfiles/fonts ~/.fonts
linkFolder ~/.dotfiles/vim ~/.vim
linkFolder ~/.dotfiles/bin ~/.bin
