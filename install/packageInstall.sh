#!/bin/sh

set -e
pacman --noconfirm -S - < core
pacman --noconfirm -S - < specific

pkgfile -u
systemctl enable ntpd
systemctl enable NetworkManager
systemctl enable lightdm

