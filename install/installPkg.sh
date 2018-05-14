#!/bin/sh

# Install Core Packages for
sudo pacman -S - < core

sudo systemctl enable ntpd
sudo systemctl enable lightdm

# Fix for Black Screen on SSD, has to be executed as root
su root -c 'printf "[LightDM]\nlogind-check-graphical=true\nrun-directory=/run/lightdm\n\n[Seat:*]\nsession-wrapper=/etc/lightdm/Xsession" > /etc/lightdm/lightdm.conf'

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

# Install Additional Packages
sudo pacman -S - < extra
