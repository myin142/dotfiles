#!/bin/sh

sudo pacman -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth manjaro-pulse pulseaudio-zeroconf pavucontrol bluez-utils xf86-input-wacom

#sudo pacman -S pipewire lib32-pipewire wireplumber pipewire-audio bluez-utils xf86-input-wacom

pacmd load-module module-bluetooth-policy
pacmd load-module module-bluetooth-discover
