#!/bin/sh

. ./shared-functions.sh

#systemctl enable fstrim.timer

# TODO: automate ssd steps
UUIDS=($(findDeviceUUID sda))
