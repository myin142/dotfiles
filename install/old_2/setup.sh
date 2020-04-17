#!/bin/sh

sudo pacman --noconfirm -S - < packages
sudo pkgfile -u

sudo ./scripts/disable-pcspkr.sh
./scripts/copy-config.sh
./scripts/install-aur.sh yay

#./scripts/setup-lsp.sh
