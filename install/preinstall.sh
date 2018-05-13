#!/bin/sh

# Script does not create Partitions
# They have to be created before starting the script
if [ -z "$1" ]; then
	echo "No Root Directory specified"
	exit 1
elif [ ! -d "$1" ]; then
	echo "Directory does not exist"
	exit 1
fi

# Select Mirror and Install Arch Base System
vim /etc/pacman.d/mirrorlist
pacstrap -i $1 base

# Change into Arch System
wget https://github.com/myin142/dotfiles/raw/master/install/install.sh -O $1/root/install.sh
arch-chroot $1
