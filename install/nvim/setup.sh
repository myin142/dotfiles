#!/bin/sh

sudo pacman -S neovim

cp nvim/ ~/.config/nvim -r
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
