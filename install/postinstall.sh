#!/bin/sh

GIT_USER=$1
GIT_EMAIL=$2
USER=$3
USER_HOME=/home/$USER
DOTFILES=/home/.dotfiles

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
function linkDotFile(){
	ln -sf $DOTFILES/$1 $USER_HOME/$2
	chown $USER:users $USER_HOME/$2
}
function linkDotFolder(){
	linkFolder $DOTFILES/$1 $USER_HOME/$2
	chown $USER:users $USER_HOME/$2
}

grub-mkconfig -o /boot/grub/grub.cfg

# Setup Git and get dotfiles
if [ ! -d /home/.dotfiles ]; then
	git config --global user.name $GIT_USER
	git config --global user.email $GIT_EMAIL
	git config --global core.editor vim
	git clone --recurse-submodules -j$(nproc) https://github.com/myin142/dotfiles $DOTFILES
	chown :users $DOTFILES -R
fi

# Create Config Links
linkDotFile config/bashrc .bashrc
linkDotFile config/vimrc .vimrc
linkDotFile config/xinitrc .xinitrc
linkDotFile config/Xresources .Xresources

if [ ! -d ~/.config ]; then
	mkdir ~/.config
fi

linkDotFolder config/i3 .config/i3
linkDotFolder config/kitty .config/kitty
linkDotFolder config/rofi .config/rofi
linkDotFolder config/dunst .config/dunst
linkDotFolder config/redshift .config/redshift
linkDotFolder config/compton .config/compton

# Create Image Links
ln -sf ~/.dotfiles/img/wallpaper.png ~/.wallpaper.png
ln -sf ~/.dotfiles/img/lockscreen.png /home/.lockscreen.png

# Create Other Links
linkDotFolder fonts .local/share/fonts
linkDotFolder vim .vim
linkDotFolder bin .bin

# Display Manager
ln -sf $DOTFILES/config/lightdm/slick-greeter.conf /etc/lightdm/slick-greeter.conf
ln -sf $DOTFILES/config/lightdm/lightdm.conf /etc/lightdm/lightdm.conf

