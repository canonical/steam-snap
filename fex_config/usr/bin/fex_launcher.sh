#!/bin/bash
mkdir -p /home/$USER/snap/steam/common/.fex-emu/
#mkdir -p /home/$USER/.fex-emu/
export FEX_SERVERSOCKETPATH=/home/$USER/snap/steam/common/.fex-emu/FEXServer.Socket
export FEX_APP_CONFIG_LOCATION=/snap/steam/current/fex_config/
export FEX_ROOTFS=$SNAP_USER_COMMON/x86_rootfs/

mkdir -p /home/$USER/snap/steam/common/.fex-emu/nvidia_ngx_config
export FEX_STEAM_NGX_LIB_VERSION_FILE=/home/$USER/snap/steam/common/.fex-emu/nvidia_ngx_config/ngx_lib_version.txt
touch $FEX_STEAM_NGX_LIB_VERSION_FILE

# Refresh the rootfs from the snap if it mismatches (except the nvidia parts, which we expect to mismatch
# due to the copied NGX DLL)
SNAP_ROOTFS_HASH="$(sha256sum /snap/steam/current/x86_rootfs.tar.gz | cut -d ' ' -f 1)"
HOME_ROOTFS_HASH="$(sha256sum $SNAP_USER_COMMON/x86_rootfs.tar.gz | cut -d ' ' -f 1)"

if [ "$SNAP_ROOTFS_HASH" != "$HOME_ROOTFS_HASH" ]; then
	zenity --info --text="Your x86 compatibility libraries are being updated. It may take up to 10 minutes for Steam to launch. The Steam login screen will display when this is complete." --title="Updating x86 components" &
	echo "Refreshing rootfs - difference detected"
	echo "SNAP_ROOFTS: $SNAP_ROOTFS_HASH"
	echo "HOME_ROOTFS: $HOME_ROOTFS_HASH"
	cp -f /snap/steam/current/x86_rootfs.tar.gz $SNAP_USER_COMMON
	rm -rf $SNAP_USER_COMMON/x86_rootfs
	tar -xvf $SNAP_USER_COMMON/x86_rootfs.tar.gz -C $SNAP_USER_COMMON
	echo "" > $FEX_STEAM_NGX_LIB_VERSION_FILE
fi

nvidia_driver_version=$(cat /sys/module/nvidia/version 2>/dev/null || true)

# Check if the NGX library needs updates, and install if so.
if [ "$(cat "$FEX_STEAM_NGX_LIB_VERSION_FILE" 2>/dev/null || true)" != "$nvidia_driver_version" ]; then
	zenity --info --text="Your NVIDIA NGX components require an upgrade to enable DLSS functionality. This may take up to 10 minutes (or potentially longer with poor internet connectivity). The Steam login screen will display when this is complete." --title="Updating NVIDIA NGX components" &
	#if [ -z "$nvidia_driver_version" ]; then
	#	if zenity --question --text="Could not detect NVIDIA driver version. DLSS libraries will not be installed. (This is expected if you are not using an NVIDIA GPU.)" --title="Launch Steam without DLSS?"; then
	#		echo "Continuing without DLSS"
	#	else
	#		exit 1
	#	fi
	#fi

	echo "Installing NVIDIA NGX libs..."
	ORIG_DIR=$(pwd)
	TEMP_DIR=$(mktemp -d)
	cleanup() {
	  cd "$ORIG_DIR"
	  rm -rf "$TEMP_DIR"
	  echo "Cleaned up temporary directory: $TEMP_DIR"
	}

	trap cleanup EXIT

	cd $TEMP_DIR
	echo "Working in temporary directory: $TEMP_DIR"

	nvidia_driver_version=$(cat /sys/module/nvidia/version)
	/snap/steam/current/usr/bin/wget https://download.nvidia.com/XFree86/Linux-x86_64/$nvidia_driver_version/NVIDIA-Linux-x86_64-$nvidia_driver_version.run

	rootfs="$FEX_ROOTFS"
	 
	runfile=$(realpath ./NVIDIA-Linux-x86_64-$nvidia_driver_version.run)
	runfilename=$(basename $runfile)
	 
	/snap/steam/current/usr/bin/FEXBash "$runfile -x" # || return -1

	pushd . >/dev/null
	cd ${runfilename%.run}
	 
	# Copy NGX .dlls for DLSS support in Proton
	mkdir -p $rootfs/usr/lib/x86_64-linux-gnu/nvidia/wine
	cp *.dll $rootfs/usr/lib/x86_64-linux-gnu/nvidia/wine/

	# The Proton script uses the location of the libGLX_nvidia.so.0 DSO to locate
	# the NGX dlls. It does this by calling dlopen on the library and then obtains
	# its location in the filesystem using dlinfo. Once it has the location of the
	# DSO the relative offset of the NGX dlls is always the same. If libGLX_nvidia.so
	# cant be successfully dlopend the NGX dlls will not be installed into the
	# application Wine prefix.
	#
	# Because the proton script is using dlopen it is necessary to also have all
	# of the dependencies of libGLX_nvidia.so installed as well. The safest way
	# to do this is to just copy all of the library files.
	#
	# See find_nvidia_wine_dll_dir in https://github.com/ValveSoftware/Proton/blob/proton_10.0/proton
	# for all of the details. 

	# Copy 64 bit libraries
	for dso in *.so.$nvidia_driver_version; do
	cp -vf ./$dso $rootfs/lib/x86_64-linux-gnu/$dso
	pushd $rootfs/lib/x86_64-linux-gnu >/dev/null
	ln -sf $dso $(echo $dso | cut -d'.' -f1-2).0
	ln -sf $dso $(echo $dso | cut -d'.' -f1-2).1
	ln -sf $dso $(echo $dso | cut -d'.' -f1-2).2
	popd >/dev/null
	done
	 
	# Copy 32 bit libraries
	cd 32
	for dso in *.so.$nvidia_driver_version; do
	cp -vf ./$dso $rootfs/lib/i386-linux-gnu/$dso
	pushd $rootfs/lib/i386-linux-gnu >/dev/null
	ln -sf $dso $(echo $dso | cut -d'.' -f1-2).0
	ln -sf $dso $(echo $dso | cut -d'.' -f1-2).1
	ln -sf $dso $(echo $dso | cut -d'.' -f1-2).2
	popd >/dev/null
	done

	popd >/dev/null
	chmod +r $rootfs/usr/lib/x86_64-linux-gnu/nvidia/wine/*

	echo $nvidia_driver_version > $FEX_STEAM_NGX_LIB_VERSION_FILE
	cp /var/lib/snapd/lib/vulkan/icd.d/nvidia_icd.json $rootfs/usr/share/vulkan/icd.d/nvidia_icd.json
fi




/snap/steam/current/usr/bin/FEXBash /snap/steam/current/bin/desktop-launch
