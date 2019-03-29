#!/bin/sh

ROOT_URL="https://github.com/myin142/dotfiles/raw/master/install/"

downloadIfNotExisting(){
	FILE="$1"
	FOLDER="$2"
	LINK="${ROOT_URL}$FILE"
	TARGET="${FOLDER%/}/$FILE"

	if [ ! -f "$TARGET" ]; then
		wget $LINK -O $TARGET
	fi
}

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
echo "Starting Installation..."

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

lsblk
ANS=$(askBinaryQuestion "All partitions mounted correctly and swaps enabled?")
if [ $ANS -eq 0 ]; then exit 1; fi

ANS=$(askBinaryQuestion "Edit mirrorlist?")
if [ $ANS -eq 1 ]; then
	vim /etc/pacman.d/mirrorlist;
fi

ANS=$(askBinaryQuestion "Install base package to ${ROOT_MOUNT}?")
if [ $ANS -eq 1 ]; then
	pacstrap -i $ROOT_MOUNT base wget
fi

ANS=$(askBinaryQuestion "Generating Fstab?")
if [ $ANS -eq 1 ]; then
	genfstab -U -p $ROOT_MOUNT > $ROOT_MOUNT/etc/fstab
fi

# Getting next installation file
if [ ! -f $ROOT_MOUNT/install.sh ]; then
	downloadIfNotExisting install.sh $ROOT_MOUNT/install.sh
	chmod +x $ROOT_MOUNT/install.sh
fi

# Change into Arch System
ANS=$(askBinaryQuestion "Continue with second install file?")
if [ $ANS -eq 1 ]; then
	arch-chroot $ROOT_MOUNT << EOF
		export $ROOT_URL
		export -f confirm
		export -f askBinaryQuestion
		export -f downloadIfNotExisting
		/install.sh
	EOF
fi
