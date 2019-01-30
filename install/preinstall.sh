#!/bin/sh

confirm(){
	if [ "$1" != "Y" ] && [ "$1" != "y" ] && [ "$1" != "" ] && [ "$1" != "N" ] && [ "$1" != "n" ]
	then
		echo >&2 "Invalid Input. Please Try Again."
		echo -1
	else
		if [ "$1" == "Y" ] || [ "$1" == "y" ] || [ "$1" == "" ]; then
			echo 1
		else
			echo 0
		fi
	fi
}

askBinaryQuestion(){
	while : ; do
		echo >&2 "$1 (Y/n)"
		read -s -n 1 input
		CHECK=$(confirm $input)

		if [ $CHECK -ne -1 ]; then
			echo $CHECK
			break;
		fi
	done
}

# Script does not create Partitions
# They have to be created before starting the script
echo "Starting Preinstall..."

# All disks have to be mounted first
# Enable swap with: mkswap /dev/sdxX & swapon /dev/sdxX
# $1 - root mount folder
ROOT_MOUNT="${1%/}"
if [ -z "$ROOT_MOUNT" ]; then
	echo "No Root Directory specified"
	exit 1
elif [ ! -d "$ROOT_MOUNT" ]; then
	echo "Directory does not exist"
	exit 1
elif [ "$ROOT_MOUNT" = '/' ]; then
	echo "Cannot use '/' as mount point"
	exit 1
elif [ -z $(mount | awk '{print $3}' | grep -w $ROOT_MOUNT) ]; then
	echo "Root Directory is not a mount point"
	exit 1
fi

# Confirm that all partitions are correct
lsblk
ANS=$(askBinaryQuestion "All partitions mounted correctly and swaps enabled?")
if [ $ANS -eq 0 ]; then exit 1; fi

# Select Mirror and Install Arch Base System
vim /etc/pacman.d/mirrorlist
pacstrap -i $ROOT_MOUNT base wget

# Generate Fstab
echo "Generating Fstab..."
genfstab -U -p $ROOT_MOUNT > $ROOT_MOUNT/etc/fstab

# Change into Arch System
echo "Changing Root..."
wget https://github.com/myin142/dotfiles/raw/master/install/install.sh -O $ROOT_MOUNT/install.sh
chmod +x $ROOT_MOUNT/install.sh
arch-chroot $ROOT_MOUNT
