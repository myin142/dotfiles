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

skip(){
	if [ "$1" == "n" ] || [ "$1" == "N" ] || [ "$1" == "skip" ] || [ "$1" == "s" ]; then
		echo 1
	else
		echo 0
	fi
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

# Create Locale (Default en_US.UTF-8)
ANS=$(askBinaryQuestion "Set Locale: en_US.UTF-8? (Y/n)")
if [ $ANS -eq 1 ]; then
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	echo LANG=en_US.UTF-8 > /etc/locale.conf
	export LANG=en_US.UTF-8
	locale-gen
else
	while : ; do
		read -p "Language/Region (LANG_REGION): " LANG

		SKIP=$(skip $LANG)
		if [ $SKIP -eq 1 ]; then
			break
		fi

		read -p "Encoding: " ENCODE

		LOCALE="${LANG}.${ENCODE}"
		echo "${LOCALE} ${ENCODE}" > /etc/locale.gen
		echo "LANG=${LOCALE}" > /etc/locale.conf
		export LANG="${LOCALE}"
		break
	done
fi

# Set Timezone
while : ; do
	read -p "Timezone (COUNTRY/CITY): " ZONE

	SKIP=$(skip $ZONE)
	if [ $SKIP -eq 1 ]; then
		break
	fi

	if [ -f "/usr/share/zoneinfo/$ZONE" ]; then
		ln -sf /usr/share/zoneinfo/$ZONE /etc/localtime
		hwclock --systohc --utc
		break
	elif [ -d "/usr/share/zoneinfo/$ZONE" ]; then
		echo "City missing."
		ls "/usr/share/zoneinfo/$ZONE"
	else
		echo "Timezone does not exist."
		ls /usr/share/zoneinfo/
	fi
done

# Install Packages for Wireless Connection
ANS=$(askBinaryQuestion "Will you be using wireless connections?")
if [ $ANS -eq 1 ]; then
	pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
fi

# Enable Multilib for 64-Bit Systems
ANS=$(askBinaryQuestion "64-Bit System?")
if [ $ANS -eq 1 ]; then
	echo "[multilib]" >> /etc/pacman.conf
	echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
	pacman -Sy
fi

# Root Password
ANS=$(askBinaryQuestion "Set Root Password?")
if [ $ANS -eq 1 ]; then
	echo "Root Password: "
	passwd
fi

# Setup User
ANS=$(askBinaryQuestion "Add new User?")
if [ $ANS -eq 1 ]; then
	read -p "Username: " NEWUSER

	if [ -z $(cat /etc/passwd | cut -d ':' -f1 | grep $NEWUSER) ]; then
		useradd -m -g users -G wheel,storage,power -s /bin/bash $NEWUSER
		passwd $NEWUSER

		# Setup Root access for User with sudo
		if [ -z $(pacman -Q | grep sudo) ]; then
			pacman -S sudo
			echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
		fi
	fi
fi

# Install Bootloader GRUB
echo "Installing Bootloader..."
while : ; do
	if [ $EFI = true ]; then
		read -p "EFI Directory (/boot/efi): " DIR

		SKIP=$(skip $DIR)
		if [ $SKIP -eq 1 ];  then
			break
		fi

		if [ -z "$DIR" ]; then
			DIR="/boot/efi"
		fi

		if [ -d "$DIR" ]; then
			pacman -S grub efibootmgr
			grub-install --target=x86_64-efi --efi-directory=$DIR --bootloader-id=ARCH
			break
		else
			echo "Invalid Directory"
		fi
	else
		read -p "Device (/dev/sdX): " DEV

		SKIP=$(skip $DEV)
		if [ $SKIP -eq 1 ];  then
			break
		fi

		if [ -e "$DEV" ] && [ "$DEV" != "/dev" ] && [ "$DEV" != "/dev/" ]; then
			pacman -S grub-bios
			grub-install --target=i386-pc --recheck $DEV
			break
		else
			echo "Device does not exist"
			lsblk
		fi
	fi
done

ANS=$(askBinaryQuestion "Dual Booting?")
if [ $ANS -eq 1 ]; then
	pacman -S os-prober
fi

if [ ! -f "/boot/grub/locale/en.mo" ]; then
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
fi

ANS=$(askBinaryQuestion "Make grub config?")
if [ $ANS -eq 1 ]; then
	grub-mkconfig -o /boot/grub/grub.cfg
fi

ANS=$(askBinaryQuestion "Disable PC Speakers?")
if [ $ANS -eq 1 ]; then
	echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
fi

# Get Files for Package Installation
ANS=$(askBinaryQuestion "Get Default Package Installer?")
if [ $ANS -eq 1 ]; then
	if [ -z "$NEWUSER" ]; then
		while : ; do
			read -p "User for installation: " NEWUSER

			if [ -z $(cat /etc/passwd | cut -d ':' -f1 | grep $NEWUSER) ]; then
				echo "User does not exist"
			else
				break
			fi
		done
	fi
	
	# Get Package Installer
	downloadIfNotExisting installPkg.sh /home/$NEWUSER
	chmod +x /home/$NEWUSER/installPkg.sh
	chown $NEWUSER:users /home/$NEWUSER/installPkg.sh

	downloadIfNotExisting core /home/$NEWUSER
	chown $NEWUSER:users /home/$NEWUSER/core

	# Links for Root User
	ln -sf /home/$NEWUSER/.dotfiles/config/vimrc ~/.vimrc
	ln -sf /home/$NEWUSER/.dotfiles/vim ~/.vim

	# Get Postinstall File for User
	downloadIfNotExisting postinstall.sh /home/$NEWUSER
	chmod +x /home/$NEWUSER/postinstall.sh
	chown $NEWUSER:users /home/$NEWUSER/postinstall.sh

	chown $NEWUSER:users /home/$NEWUSER/ -R
	cd /home/$NEWUSER
	su $NEWUSER
fi
