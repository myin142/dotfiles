#!/bin/sh
# https://liolok.com/containerize-steam-with-systemd-nspawn/

CONTAINER_NAME="${1%/}"
echo "Starting container $CONTAINER_NAME"

if [ -z $CONTAINER_NAME ]; then
    echo "Container name required"
    exit 1
fi

if [ ! -d "$CONTAINER_NAME" ]; then
    mkdir $CONTAINER_NAME
    sudo pacstrap -K -c $CONTAINER_NAME base steam vulkan-icd-loader vulkan-intel vulkan-radeon pulseaudio
    sudo systemd-nspawn -D $CONTAINER_NAME --bind=$HOME/.bin:/home/bin /home/bin/setup-steam-container
    sudo systemd-nspawn -D $CONTAINER_NAME passwd
fi

XAUTH="/tmp/${CONTAINER_NAME}_xauth"
xauth nextract - "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -

# xhost +local:

HOST_PULSE=/run/user/$UID/pulse
CONTAINER_PULSE=/run/user/host/pulse

# HOST_BUS=/run/user/$UID/bus
# CONTAINER_BUS=/run/user/host/bus
# --bind-ro=$HOST_BUS:$CONTAINER_BUS --setenv=DBUS_SESSION_BUS_ADDRESS=unix:path=$CONTAINER_BUS \

sudo systemd-nspawn -D $CONTAINER_NAME \
    --user=steam \
    --bind-ro=/etc/resolv.conf \
    --bind=/tmp/.X11-unix --setenv=DISPLAY=$DISPLAY \
    --bind=/dev/dri --property=DeviceAllow='char-drm rw' \
    --bind="$XAUTH" --setenv=XAUTHORITY="$XAUTH" \
    --bind=$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/wayland.sock --setenv=WAYLAND_DISPLAY=/tmp/wayland.sock \
    --bind-ro=$HOST_PULSE:$CONTAINER_PULSE --setenv=PULSE_SERVER=unix:$CONTAINER_PULSE/native \
    --bind=$HOME/Documents/games:/home/games
