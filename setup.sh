#!/bin/sh

sudo ./scripts/disable-pcspkr.sh

./scripts/setup-git.sh myin minyin142p@gmail.com

sudo ./general/setup.sh

./devices/setup.sh

./i3wm/setup.sh

wmReload -f

./nvim/setup.sh

sudo pacman -Syu

sudo pacman -S - < programs.txt
sudo pkgfile -u

./yay/setup.sh

sudo systemctl enable ntpd
sudo systemctl enable fstrim.timer
