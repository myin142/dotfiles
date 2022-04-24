#!/bin/sh

sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=0/' /etc/default/grub

echo 'GRUB_FORCE_HIDDEN_MENU="true"' >> /etc/default/grub
ln -s "$(pwd)/31_hold_shift" /etc/grub.d/31_hold_shift

update-grub
