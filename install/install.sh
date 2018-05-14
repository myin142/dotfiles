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

# Create Locale (Default en_US.UTF-8)
ANS=$(askBinaryQuestion "Locale: en_US.UTF-8? (Y/n)")
echo ""
if [ $ANS -eq 1 ]; then
	vi /etc/locale.gen
	echo LANG=en_US.UTF-8 > /etc/locale.conf
	export LANG=en_US.UTF-8
	locale-gen
else
	echo "Change the locale in this script yourself."
	exit 1
fi

# Set Timezone
while : ; do
	read -p "Timezone (COUNTRY/CITY): " ZONE
	if [ -f "/usr/share/zoneinfo/$ZONE" ]; then
		ln -sf /usr/share/zoneinfo/$ZONE /etc/localtime
		hwclock --systohc --utc
		break
	else
		echo "Timezone does not exist."
	fi
done

# Install Packages for Wireless Connection
ANS=$(askBinaryQuestion "Will you be using wireless connections? (Y/n)")
echo ""
if [ $ANS -eq 1 ]; then
	pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
fi

# Enable Multilib for 64-Bit Systems
ANS=$(askBinaryQuestion "64-Bit System? (Y/n)")
echo ""
if [ $ANS -eq 1 ]; then
	vi /etc/pacman.conf
	pacman -Sy
fi

# Root Password
echo "Root Password..."
passwd

# Setup User
ANS=$(askBinaryQuestion "Add new User? (Y/n)")
if [ $ANS -eq 1 ]; then
	read -p "Username: " NEWUSER
	useradd -m -g users -G wheel,storage,power -s /bin/bash $NEWUSER
	passwd $NEWUSER

	# Setup Root access for User with sudo
	pacman -S sudo
	EDITOR=vi visudo # Uncomment wheel
fi

# Install Bootloader GRUB
echo "Installing Bootloader..."
while : ; do
	if [ $EFI = true ]; then
		read -p "EFI Directory (/boot/efi): " DIR
		if [ -d "$DIR" ]; then
			pacman -S grub efibootmgr
			grub-install --target=x86_64-efi --efi-directory=$DIR --bootloader-id=ARCH
			break
		else
			echo "Invalid Directory"
		fi
	else
		read -p "Device (/dev/sdX): " DEV
		if [ -e "$DEV" ]; then
			pacman -S grub-bios
			grub-install --target=i386-pc --recheck $DEV
			break
		else
			echo "Device does not exist"
		fi
	fi
done

ANS=$(askBinaryQuestion "Dual Booting? (Y/n)")
if [ $ANS -eq 1 ]; then
	pacman -S os-prober
fi
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

# Get Files for Package Installation
ANS=$(askBinaryQuestion "Get Default Package Installer? (Y/n)")
if [ $ANS -eq 1 ]; then
	wget https://github.com/myin142/dotfiles/raw/master/install/installPkg -O /home/$NEWUSER/installPkg
	wget https://github.com/myin142/dotfiles/raw/master/install/core -O /home/$NEWUSER/core
	wget https://github.com/myin142/dotfiles/raw/master/install/extra -O /home/$NEWUSER/extra
	chmod +x /home/$NEWUSER/installPkg
	chown $NEWUSER:users /home/$NEWUSER/installPkg
	chown $NEWUSER:users /home/$NEWUSER/core
	chown $NEWUSER:users /home/$NEWUSER/extra

	# Links for Root User
	ln -sf /home/$NEWUSER/.dotfiles/config/vimrc ~/.vimrc
	ln -sf /home/$NEWUSER/.dotfiles/vim ~/.vim

	# Get Postinstall File for User
	wget https://github.com/myin142/dotfiles/raw/master/install/postinstall.sh -O /home/$NEWUSER/postinstall.sh
	chmod +x /home/$NEWUSER/postinstall.sh
	chown $NEWUSER:users /home/$NEWUSER/postinstall.sh
fi
