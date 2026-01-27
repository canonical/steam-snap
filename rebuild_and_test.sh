#!/bin/sh
# Runs a rebuild WITHOUT clearing the local rootfs components
./umount.sh
sudo snap remove steam
rm steam_218_arm64.snap
snapcraft
sudo snap install --dangerous steam_218_arm64.snap
./connect.sh
