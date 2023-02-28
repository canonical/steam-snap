#!/bin/bash

set -e

export PATH=$SNAP/bin:$PATH

# If Steam has not bootstrapped, check to see if there is a non-snap
# Steam library we can adopt.
STEAMCONFIG=$HOME/.local/share
if [ ! -L $STEAMCONFIG/Steam/steamapps ]; then
    mkdir -p $STEAMCONFIG/Steam/config
    REALHOME=$(getent passwd $UID | cut -d ':' -f 6)
    if [ -x $REALHOME/.local/share/Steam/steam.sh ]; then
        ln -s $REALHOME/.local/share/Steam/steamapps $STEAMCONFIG/Steam
        ln -s $REALHOME/.local/share/Steam/config/libraryfolders.vdf $STEAMCONFIG/Steam/config/
    elif [ -x $REALHOME/.steam/debian-installation/steam.sh ]; then
        ln -s $REALHOME/.steam/debian-installation/steamapps $STEAMCONFIG/Steam
        ln -s $REALHOME/.steam/debian-installation/config/libraryfolders.vdf $STEAMCONFIG/Steam/config/
    fi
fi

exec "$@"
