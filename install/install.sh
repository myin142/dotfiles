#!/bin/sh

SETTINGS=$1
keyExists(){
	[ ! -z "${SETTINGS[$1]}" ] && echo true || echo false
}

# Start of Installation Script
echo "Starting Arch Linux Installation..."

# Set Locale
LOCALE="${SETTINGS[lang]}.${SETTINGS[encode]}"
echo "$LOCALE ${SETTINGS[encode]}" > /etc/locale.gen
echo "LANG=$LOCALE" > /etc/locale.conf
export LANG="$LOCALE"
locale-gen

# Set Timezone
ln -sf /usr/share/zoneinfo/$ZONE /etc/localtime
hwclock --systohc --utc

# Other optional fields
[ $(keyExists wireless) = true ] && pacman --noconfirm -S wireless_tools wpa_supplicant wpa_actiond dialog
[ $(keyExists 64Bit) = true ] \
	&& echo "[multilib]" >> /etc/pacman.conf \
	&& echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf \
	&& pacman -Sy
[ $(keyExists dual) = true ] && pacman --noconfirm -S os-prober
[ $(keyExists speakers) = true ] && echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# Root Password
echo "${SETTINGS[rootPassword]}\n${SETTINGS[rootPassword]}" | passwd

# Setup User
[ $(keyExists newUser) = true ] \
	&& useradd -m -g users -G wheel,storage,power -s /bin/bash ${SETTINGS[newUser]} \
	&& echo "${SETTINGS[userPassword]}\n${SETTINGS[userPassword]}" | passwd ${SETTINGS[newUser]} \
	&& pacman --noconfirm -S sudo \
	&& echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Bootloader
pacman --noconfirm -S grub
[ $(keyExists 64Bit) = true ] && TARGET=x86_64 || TARGET=i386
[ $(keyExists efi) = true ] \
	&& pacman --noconfirm -S efibootmgr \
	&& grub-install --target=$TARGET-efi --efi-directory=${SETTINGS[efi]} --bootloader-id=ARCH

[ $(keyExists dev) = true ] && grub-install --target=i386-pc --recheck ${SETTINGS[dev]}

if [ ! -f "/boot/grub/locale/en.mo" ]; then
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
fi
grub-mkconfig -o /boot/grub/grub.cfg

# Post Install with Packages
[ $(keyExists package) = true ] \
	&& /postInstall.sh ${SETTINGS[gitUser]} ${SETTINGS[gitPassword]}
