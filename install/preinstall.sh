#!/bin/sh

# Exit on failure
set -e

ROOT_URL="https://github.com/myin142/dotfiles/raw/master/install/"

downloadIfNotExisting(){
	FILE="$1"
	FOLDER="$2"
	LINK="${ROOT_URL}$FILE"
	TARGET="${FOLDER%/}/$FILE"

	[ ! -f "$TARGET" ] && wget $LINK -O $TARGET && chmod +x $TARGET
}
confirm(){
	if [ "$1" != "Y" ] && [ "$1" != "y" ] && [ "$1" != "" ] && [ "$1" != "N" ] && [ "$1" != "n" ]
	then
		echo >&2 "Invalid Input. Please Try Again."
		echo -1
	else
		[ "$1" == "Y" ] || [ "$1" == "y" ] || [ "$1" == "" ] && echo 1 || echo 0
	fi
}
binaryQuestion(){
	while : ; do
		echo >&2 "$1? (Y/n)"
		read -s -n 1 input
		CHECK=$(confirm $input)

		if [ $CHECK -ne -1 ]; then
			echo $CHECK
			break
		fi
	done
}
getPassword(){
	while : ; do
		
		PASSWORD=$(nonEmptyInput "Password" -s)
		echo >&2
		CONFIRM=$(nonEmptyInput "Confirm Password" -s)
		echo >&2

		if [ "$PASSWORD" != "$CONFIRM" ]; then
			echo >&2 "Password not the same"
			continue
		fi

		echo $PASSWORD
		break
	done
}
nonEmptyInput(){
	while : ; do
		read $2 -p "$1: " INPUT

		if [ -z "$INPUT" ]; then
			echo >&2 "Input cannot be empty"
			continue
		fi

		echo $INPUT
		break
	done
}
failure(){
	echo >&2 $1
	exit 1
}

# Script does not create Partitions
# They have to be created before starting the script
echo "Starting Preinstallation..."

# All disks have to be mounted first
# Enable swap with: mkswap /dev/sdxX & swapon /dev/sdxX
# $1 - root mount folder
ROOT_MOUNT="${1%/}"
if [ -z "$ROOT_MOUNT" ]; then
	failure "No Root Directory specified"
elif [ ! -d "$ROOT_MOUNT" ]; then
	failure "Directory does not exist"
elif [ "$ROOT_MOUNT" == '/' ]; then
	failure "Cannot use '/' as mount point"
elif [ -z $(mount | awk '{print $3}' | grep -w $ROOT_MOUNT) ]; then
	failure "Root Directory is not a mount point"
fi

#####################################
# Getting Settings for Installation #
#####################################

declare -A SETTINGS

if [ $(binaryQuestion "Use Locale en_US.UTF-8") -eq 1 ]; then
	SETTINGS[lang]="en_US"
	SETTINGS[encode]="UTF-8"
else
	SETTINGS[lang]=$(nonEmptyInput "Language/Region (LANG_REGION)")
	SETTINGS[encode]=$(nonEmptyInput "Encoding")
fi

SETTINGS[timezone]=$(nonEmptyInput "Timezone (COUNTRY/CITY)")
SETTINGS[gitName]=$(nonEmptyInput "Git Name") \
SETTINGS[gitEmail]=$(nonEmptyInput "Git Email")

[ -e /sys/firmware/efi/efivars ] \
	&& SETTINGS[efi]=$(nonEmptyInput "EFI Directory") \
	|| SETTINGS[dev]=$(nonEmptyInput "Device (/dev/sdX)")

printf "Root "
SETTINGS[rootPassword]=$(getPassword)

[ $(binaryQuestion "Add new User") -eq 1 ] \
	&& SETTINGS[newUser]=$(nonEmptyInput "Username") \
	&& SETTINGS[userPassword]=$(getPassword)

[ -z "${SETTINGS[newUser]}" ] && SETTINGS[user]=$(nonEmptyInput "Using existing User")

SETTINGS[dual]=$(binaryQuestion "Dual Booting")
SETTINGS[wireless]=$(binaryQuestion "Wireless connection")
SETTINGS[64bit]=$(binaryQuestion "64-Bit System")
SETTINGS[speakers]=$(binaryQuestion "Disable PC Speakers")

for x in "${!SETTINGS[@]}"; do
	printf "[%s]=%s\n" "$x" "${SETTINGS[$x]}"
done

[ $(binaryQuestion "Start installation with these SETTINGS") -eq 0 ] && failure

################################
# Installation of Base Package #
################################

ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null \
	&& echo "Start Installation" \
	|| failure "Internet Connection required"

lsblk
[ $(binaryQuestion "All partitions mounted correctly and swaps enabled?") -eq 0 ] && failure
[ $(binaryQuestion "Edit mirrorlist?") -eq 1 ] && vim /etc/pacman.d/mirrorlist

# Validity can only be checked when having basic structure
if [[ ! -d "$ROOT_MOUNT/proc" ]]; then
	echo "Installing Base Package"
	pacstrap -i $ROOT_MOUNT base
	genfstab -U -p $ROOT_MOUNT > $ROOT_MOUNT/etc/fstab
fi

##############################
# Check Validity of Settings #
##############################

INVALID=false

[[ -z $(cat /etc/locale.gen | grep "${SETTINGS[lang]}.${SETTINGS[encode]}") ]] && \
	echo "Invalid Locale ${SETTINGS[lang]}.${SETTINGS[encode]}" && INVALID=true

[[ ! -f "$ROOT_MOUNT/usr/share/zoneinfo/${SETTINGS[timezone]}" ]] && \
	echo "Invalid Timezone ${SETTINGS[timezone]}" && INVALID=true

[[ ! -z ${SETTINGS[efi]} && ! -d "$ROOT_MOUNT/${SETTINGS[efi]}" ]] && \
	echo "Invalid EFI Directory ${SETTINGS[efi]}" && INVALID=true

[[ ! -z ${SETTINGS[dev]} && -z $(ls ${SETTINGS[dev]}) ]] && \
	echo "Invalid Device ${SETTINGS[dev]}" && INVALID=true

[[ ! -z ${SETTINGS[newUser]} && \
	! -z $(cat $ROOT_MOUNT/etc/passwd | cut -d ':' -f1 | grep -w ${SETTINGS[newUser]}) ]] && \
	echo "User ${SETTINGS[newUser]} already exists" && INVALID=true

[[ ! -z ${SETTINGS[user]} && \
	-z $(cat $ROOT_MOUNT/etc/passwd | cut -d ':' -f1 | grep -w ${SETTINGS[user]}) ]] && \
	echo "User ${SETTINGS[user]} does not exist" && INVALID=true

[ $INVALID = true ] && failure

####################################
# Basic Installation with Settings #
####################################

# Getting installation file
downloadIfNotExisting install.sh $ROOT_MOUNT
downloadIfNotExisting packageInstall.sh $ROOT_MOUNT
downloadIfNotExisting postinstall.sh $ROOT_MOUNT
downloadIfNotExisting core $ROOT_MOUNT

arch-chroot $ROOT_MOUNT << EOF
	/install.sh $SETTINGS
EOF
