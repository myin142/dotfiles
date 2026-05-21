#!/bin/sh

cp sddm.conf /etc/sddm.conf
cp custom /usr/share/sddm/themes/ -r
chmod 711 $HOME/.lockscreen.png