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
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
	tar -xvzf package-query.tar.gz
	cd package-query
	makepkg -si

	cd ..
	curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
	tar -xvzf yaourt.tar.gz
	cd yaourt
	makepkg -si

	cd ..
	rm package-query -r
	rm yaourt -r
	rm package-query.tar.gz
	rm yaourt.tar.gz
}

# Check if internet connection if available
ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && runProgram \
	|| echo "No Internet Connection" && exit 1
