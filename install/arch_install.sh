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

# Start of Installation Script
echo "Starting Arch Linux Installation..."

# Check for UEFI Boot Mode
if [ -e /sys/firmware/efi/efivars ]; then
	EFI=true
	echo "UEFI is enabled"
else
	EFI=false
	echo "UEFI is disabled"
fi

# Check what type of drive
HDD=$(cat /sys/block/sda/queue/rotational)
if [ $HDD -eq 1 ]; then
	echo "Using HDD Drive"
else
	echo "Using SSD Drive"
fi

# First Step Information
echo ""
echo "First of all, you need to partition your disk."
echo "If you want to dual-boot with Windows, we highly recommend installing Windows first."
echo "Otherwise Windows will override the Linux bootloader."
echo ""

lsblk

ANS=$(askBinaryQuestion "Do you want us to do the partitioning of the disk?")

echo ""
if [ $ANS -eq  1 ]; then
	echo "Partitioning your Disk..."
else
	if [ $EFI ]; then
		echo "Using gdisk for Partitioning"
	else
		echo "Using fdisk for Partitioning"
	fi

	echo "If you prefer to use a different program, exit the script and open your program."
	echo "Then reopen this script and choose manual partitioning. And do not change anything."
	sleep 4

	if [ $EFI ]; then
		gdisk /dev/sda
	else
		fdisk /dev/sda
	fi
fi
