#!/bin/bash

set -e

export PATH=$SNAP/bin:$PATH

# If Steam has not bootstrapped, check to see if there is a non-snap
# Steam library we can adopt.
STEAMCONFIG=$HOME/.steam
if [ ! -L $STEAMCONFIG/steam ]; then
    mkdir -p $STEAMCONFIG
    REALHOME=$(getent passwd $UID | cut -d ':' -f 6)
    if [ -x $REALHOME/.local/share/Steam/steam.sh ]; then
        ln -s $REALHOME/.local/share/Steam $STEAMCONFIG/steam
    elif [ -x $REALHOME/Steam/steam.sh ]; then
        ln -s $REALHOME/Steam $STEAMCONFIG/steam
    fi
fi

exec $SNAP/bin/steam "$@"
