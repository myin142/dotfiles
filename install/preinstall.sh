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

# Generate Fstab
echo "Generating Fstab..."
genfstab -U -p $1 >> $1/etc/fstab

# Change into Arch System
echo "Changing Root..."
wget https://github.com/myin142/dotfiles/raw/master/install/install.sh -O $1/install.sh
arch-chroot $1
