#!/bin/sh

# Setup Git and get dotfiles
if [ ! -d ~/.dotfiles ]; the

    read -p   "Git Email: "  EMAIL

	git config --global user.name "Min Yin"
	git config --global user.email "$EMAIL"
	git config --global core.editor vim
	git clone --recurse-submodules -j8 https://github.com/myin142/dotfiles ~/.dotfiles
fi 

# Create Links
ln -sf ~/.dotfiles/config/bashrc ~/.bashrc
ln -sf ~/.dotfiles/config/vimrc ~/.vimrc
ln -sf ~/.dotfiles/config/xinitrc ~/.xinitrc

if [ -d ~/.config/i3 ]; then
	rm ~/.config/i3
fi
ln -sf ~/.dotfiles/config/i3 ~/.config/i3

if [ -d ~/.config/kitty ]; then
	rm ~/.config/kitty
fi
ln -sf ~/.dotfiles/config/kitty ~/.config/kitty

if [ -d ~/.fonts ]; then
	rm ~/.fonts
fi
ln -sf ~/.dotfiles/fonts ~/.fonts

ln -sf ~/.dotfiles/img/wallpaper.png ~/.wallpaper.png
ln -sf ~/.dotfiles/img/lock.png ~/.lock.png

if [ -d ~/.vim ]; then
	rm ~/.vim
fi
ln -sf ~/.dotfiles/vim ~/.vim

if [ -d ~/.bin ]; then
	rm ~/.bin
fi
ln -sf ~/.dotfiles/bin ~/.bin

if [ -d ~/Applications ]; then
	rm ~/Applications
fi
ln -sf ~/Data/Applications ~/Applications

if [ -d ~/Documents ]; then
	rm ~/Documents
fi
ln -sf ~/Data/Documents ~/Documents

if [ -d ~/Downloads ]; then
	rm ~/Downloads
fi
ln -sf ~/Data/Downloads ~/Downloads

if [ -d ~/Games ]; then
	rm ~/Games
fi
ln -sf ~/Data/Games ~/Games

if [ -d ~/Programming ]; then
	rm ~/Programming
fi
ln -sf ~/Data/Programming ~/Programming
