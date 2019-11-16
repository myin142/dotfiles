#!/bin/sh

findDeviceUUID() {
    [ -z "$1" ] && echo "Need Device Name (example: sda1)" && exit
	DEV="$1"
	UUID=$(blkid | grep "$DEV" | awk -F ' UUID=' '{print $2}' | awk '{print $1}' | tr -d '"')
	echo "$UUID"
}

backupFile() {
	[ -z "$1" ] && echo "Need file to backup" && exit

	FILE="$1"
	MAX_BACKUP="${2:-1}"

	if [ ! -f "$FILE" ]; then
		echo "File: $FILE does not exist"
		exit
	fi

	# INDEX=0
	# CURR_FILE="$FILE"
	# while true:
	# 	if [ -f "$CURR_FILE" ]; then
	# 		BACKUP_FILE="$FILE.BAK"
	# 		if [ -f "$BACKUP_FILE" ] && [ $INDEX < $MAX_BACKUP ]; then
	# 			_backupFile $
				
	# 		fi
	# 		cp "$FILE" "$FILE.BAK"
	# 	fi

	# 	INDEX++
	# done

}

_backupFile() {
	FILE="$1"
	DEST="$2"

	if [ -f "$FILE" ]; then
		if [ ! -f "$DEST" ]; then
			cp $FILE $DEST
			echo 0
		else
			echo 1
		fi
	else
		echo 1
	fi
}
