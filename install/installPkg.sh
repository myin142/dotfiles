#!/bin/sh

runProgram(){
	# Install Packages
	sudo pacman -S - < core
	sudo pacman -S - < sound
	sudo pacman -S - < fonts
	sudo pacman -S - < graphic
	sudo pacman -S - < desktop
	sudo pacman -S - < programming

	sudo pkgfile -u
	sudo systemctl enable ntpd
	sudo systemctl enable NetworkManager

	# Install Yaourt
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz
	tar -xvzf aurman.tar.gz
	cd aurman
	makepkg -si

	cd ..
	rm aurman -r
	rm aurman.tar.gz
}

# Check if internet connection if available
ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && runProgram \
	|| echo "No Internet Connection" && exit 1
