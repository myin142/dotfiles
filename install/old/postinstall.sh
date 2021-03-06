#!/bin/sh

set -e

GIT_USER=$1
GIT_EMAIL=$2
USER=$3
USER_HOME=/home/$USER
DOTFILES=/home/$USER/.dotfiles

linkFolder(){
	SOURCE="$1"
	TARGET="$2"

	# Remove target to prevent creating link inside folder
	[ -d "$TARGET" ] && rm "$TARGET" -r

	# Target should not exists when creating link
	[ ! -d "$TARGET" ] && ln -sf "$SOURCE" "$TARGET"
}
linkDotFile(){
	ln -sf $DOTFILES/$1 $USER_HOME/$2
}
linkDotFolder(){
	linkFolder $DOTFILES/$1 $USER_HOME/$2
}

# Setup Git and get dotfiles
if [ ! -d $DOTFILES ]; then
	git config --global user.name $GIT_USER
	git config --global user.email $GIT_EMAIL
	git config --global core.editor vim
	git clone --recurse-submodules -j$(nproc) https://github.com/myin142/dotfiles $DOTFILES
	chown $USER:users $DOTFILES -R
fi

# Create Config Links
linkDotFile config/bashrc .bashrc
linkDotFile config/vimrc .vimrc
linkDotFile config/xinitrc .xinitrc
linkDotFile config/Xresources .Xresources
linkDotFile config/Xmodmap .Xmodmap

if [ ! -d $USER_HOME/.config ]; then
	mkdir $USER_HOME/.config
fi

linkDotFolder config/i3 .config/i3
linkDotFolder config/kitty .config/kitty
linkDotFolder config/rofi .config/rofi
linkDotFolder config/dunst .config/dunst
linkDotFolder config/redshift .config/redshift
linkDotFolder config/compton .config/compton

# Create Image Links
linkDotFile img/wallpaper.png .wallpaper.png
ln -sf $DOTFILES/img/lockscreen.png /usr/share/pixmaps/

# Create Other Links
[ ! -d "$USER_HOME/.local" ] && mkdir -p $USER_HOME/.local/share
linkDotFolder fonts .local/share/fonts
linkDotFolder vim .vim
linkDotFolder bin .bin

# Display Manager
[ -f /etc/lightdm/lightdm-gtk-greeter.conf ] && rm /etc/lightdm/lightdm-gtk-greeter.conf
ln -sf $DOTFILES/config/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/

[ -f /etc/lightdm/lightdm.conf ] && rm /etc/lightdm/lightdm.conf
ln -sf $DOTFILES/config/lightdm/lightdm.conf /etc/lightdm/

ln -sf $DOTFILES/config/xorg.conf.d/ /etc/X11/xorg.conf.d

chown $USER:users $USER_HOME/ -R
rm core specific install.sh packageInstall.sh postinstall.sh settings.values

