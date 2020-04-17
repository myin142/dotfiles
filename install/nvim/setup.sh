#!/bin/sh

sudo pacman -S neovim

if [ -d ~/.config/nvim ]; then
    rm ~/.config/nvim -rf
fi

ln -sf "$(pwd)/nvim/" ~/.config/nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
