#!/bin/sh

[ -z "$1" -o -z "$2" ] && echo "Name and Email required" && exit

NAME="$1"
EMAIL="$2"

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
git config --global core.editor nvim
