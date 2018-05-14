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

if [ ! -d ~/.vim ]; then
	ln -sf ~/.dotfiles/vim ~/.vim
fi
