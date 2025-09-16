#!/bin/sh
# https://liolok.com/containerize-steam-with-systemd-nspawn/

CONTAINER_NAME="${1%/}"
echo "Starting container $CONTAINER_NAME"

if [ -z $CONTAINER_NAME ]; then
    echo "Container name required"
    exit 1
fi

if [ ! -d "$CONTAINER_NAME" ]; then
    # btrfs subvolume create $CONTAINER_NAME

    CODENAME=${2:-jammy}
    REPO="https://mirror.easyname.at/ubuntu-archive/"
    sudo debootstrap --include=systemd-container --components=main,universe,multiverse $CODENAME $CONTAINER_NAME $REPO
fi

XAUTH="/tmp/${CONTAINER_NAME}_xauth"
xauth nextract - "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -

# xhost +local:

# --bind=$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/wayland.sock --setenv=WAYLAND_DISPLAY=/tmp/wayland.sock \
sudo systemd-nspawn -D $CONTAINER_NAME \
    --user=steam \
    --bind-ro=/etc/resolv.conf \
    --bind=/tmp/.X11-unix --setenv=DISPLAY=$DISPLAY \
    --bind="$XAUTH" --setenv=XAUTHORITY="$XAUTH" \
    --bind=/dev/dri --property=DeviceAllow='char-drm rw' \
    --bind=/home/myin/Documents/games:/home/games
