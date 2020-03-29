#!/bin/sh

if [ ! -d "$HOME/.bin" ]; then
	ln -s $(pwd)/bin ~/.bin
else
	echo "~/.bin already exists"
fi


if [ ! -f "$HOME/.bashrc" ]; then
	ln -s $(pwd)/bashrc ~/.bashrc
else
	echo "~/.bashrc already exists"
fi


