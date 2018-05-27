#!/bin/sh

# Setup Git and get dotfiles
if [ ! -d ~/.dotfiles ]; then
	git config --global user.name "Min Yin"
	git config --global user.email "minyin142p@gmail.com"
	git config --global core.editor vim
	git clone --recurse-submodules -j8 https://github.com/myin142/dotfiles ~/.dotfiles
fi 

# Create Links
ln -sf ~/.dotfiles/config/bashrc ~/.bashrc
ln -sf ~/.dotfiles/config/vimrc ~/.vimrc
ln -sf ~/.dotfiles/config/xinitrc ~/.xinitrc

if [ -d ~/.config/i3 ]; then
	rm ~/.config/i3 -r
fi
ln -sf ~/.dotfiles/config/i3 ~/.config/i3

if [ -d ~/.config/kitty ]; then
	rm ~/.config/kitty -r
fi
ln -sf ~/.dotfiles/config/kitty ~/.config/kitty

if [ -d ~/.fonts ]; then
	rm ~/.fonts -r
fi
ln -sf ~/.dotfiles/fonts ~/.fonts

ln -sf ~/.dotfiles/img/wallpaper.png ~/.wallpaper.png
ln -sf ~/.dotfiles/img/lock.png ~/.lock.png

if [ -d ~/.vim ]; then
	rm ~/.vim -r
fi
ln -sf ~/.dotfiles/vim ~/.vim
