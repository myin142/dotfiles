#!/bin/sh

runProgram(){
	# Install Packages
	sudo pacman -S - < core

	if [ -z $(pacman -Q | grep pkgfile) ]; then
		echo "Error during Installation"
		exit 1
	fi

	# Install Aurman
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz
	tar -xvzf aurman.tar.gz
	cd aurman
	makepkg -si

	cd ..
	rm aurman -rf
	rm aurman.tar.gz
}

pacman -S - < core

# CPU Microcode
[ ! -z $(lscpu | grep "Vendor" | grep "AMD") ] && pacman --noconfirm -S amd-ucode
[ ! -z $(lscpu | grep "Vendor" | grep "Intel") ] && pacman --noconfirm -S intel-ucode

# GPU Driver
[ ! -z $(lspci | grep "VGA" | grep "AMD") ] \
	&& pacman --noconfirm -S xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon

pkgfile -u
systemctl enable ntpd
systemctl enable NetworkManager

