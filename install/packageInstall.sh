#!/bin/sh

set -e
pacman -Sy
pacman -S - < core

while : ; do
	vim specific
	[ -z $(cat specific | grep "#") ] && break
done
pacman -S - < specific

pkgfile -u
systemctl enable ntpd
systemctl enable NetworkManager
systemctl enable lightdm

