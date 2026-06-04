#!/bin/bash

# Refuse to launch if the kernel has a 64k page size
PAGE_SIZE=$(getconf PAGESIZE)

if [ "$PAGE_SIZE" -eq 4096 ]; then
    echo "Confirmed: Running a 4k page size kernel."
else
    echo "Unsupported page size: $PAGE_SIZE bytes."
    zenity --info --text="This application requires a 4k page size kernel. If your hardware supports a 4k page-size kernel, please install and boot that kernel and re-launch." --title="Kernel page size not supported"
    exit 1
fi

custom_nvdriver_url=""
desktop_launch_args=()

while [[ $# -gt 0 ]]; do
	case "$1" in
		--nvdriver)
			if [[ -z "$2" ]]; then
				echo "Error: --nvdriver requires a URL argument" >&2
				exit 1
			fi
			custom_nvdriver_url="$2"
			shift 2
			;;
		*)
			desktop_launch_args+=("$1")
			shift
			;;
	esac
done

mkdir -p $SNAP_USER_COMMON/.fex-emu/
#mkdir -p /home/$USER/.fex-emu/
export FEX_SERVERSOCKETPATH=$SNAP_USER_COMMON/.fex-emu/FEXServer.Socket
export FEX_APP_CONFIG_LOCATION=$SNAP_USER_COMMON/fex_config/
export FEX_ROOTFS=$SNAP_USER_COMMON/x86_rootfs/

mkdir -p $SNAP_USER_COMMON/.fex-emu/nvidia_ngx_config
export FEX_STEAM_NGX_LIB_VERSION_FILE=$SNAP_USER_COMMON/.fex-emu/nvidia_ngx_config/ngx_lib_version.txt
touch $FEX_STEAM_NGX_LIB_VERSION_FILE

# Refresh the rootfs from the snap if it mismatches (except the nvidia parts, which we expect to mismatch
# due to the copied NGX DLL)
SNAP_ROOTFS_HASH="$(sha256sum $SNAP/x86_rootfs.tar.gz | cut -d ' ' -f 1)"
HOME_ROOTFS_HASH="$(sha256sum $SNAP_USER_COMMON/x86_rootfs.tar.gz | cut -d ' ' -f 1)"

if [ "$SNAP_ROOTFS_HASH" != "$HOME_ROOTFS_HASH" ]; then
	zenity --info --text="Your x86 compatibility libraries are being updated. It may take up to 10 minutes for Steam to launch. The Steam login screen will display when this is complete." --title="Updating x86 components" &
	echo "Refreshing rootfs - difference detected"
	echo "SNAP_ROOFTS: $SNAP_ROOTFS_HASH"
	echo "HOME_ROOTFS: $HOME_ROOTFS_HASH"
	cp -f $SNAP/x86_rootfs.tar.gz $SNAP_USER_COMMON
	rm -rf $SNAP_USER_COMMON/x86_rootfs
	tar -xvf $SNAP_USER_COMMON/x86_rootfs.tar.gz -C $SNAP_USER_COMMON
	echo "" > $FEX_STEAM_NGX_LIB_VERSION_FILE
	rm $SNAP_USER_COMMON/prefer_custom_user_config # Also ask the user again if they want to update their config, if it differs
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
	nvidia_runfile_url="https://download.nvidia.com/XFree86/Linux-x86_64/$nvidia_driver_version/NVIDIA-Linux-x86_64-$nvidia_driver_version.run"
	if [[ -n "$custom_nvdriver_url" ]]; then
		nvidia_runfile_url="$custom_nvdriver_url"
	fi
	nvidia_runfile_name="$(basename "${nvidia_runfile_url%%\?*}")"
	if [[ -z "$nvidia_runfile_name" || "$nvidia_runfile_name" == "/" || "$nvidia_runfile_name" == "." ]]; then
		echo "Error: could not determine NVIDIA runfile name from URL: $nvidia_runfile_url" >&2
		exit 1
	fi
	$SNAP/usr/bin/wget -O "$nvidia_runfile_name" "$nvidia_runfile_url"

	rootfs="$FEX_ROOTFS"

	runfile=$(realpath "./$nvidia_runfile_name")
	runfilename=$(basename $runfile)

	$SNAP/usr/bin/FEXBash "$runfile -x" # || return -1

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

# Copy Config.json if it differs. (If it doesn't yet exist, don't prompt - just copy) 
if [ -d $FEX_APP_CONFIG_LOCATION ]; then
	echo "Your local FEX configuration differs from the latest version provided by the Steam snap. This can happen if, for example, you enabled thunking or other features. Would you like to update your config to the snap-provided config? Diff below: " > $SNAP_USER_COMMON/user_config_diff.txt
	diff -ruN $FEX_APP_CONFIG_LOCATION $SNAP/fex_config >> $SNAP_USER_COMMON/user_config_diff.txt
	if ! diff -ruN "$FEX_APP_CONFIG_LOCATION" "$SNAP/fex_config" > /dev/null && [[ ! -f "$SNAP_USER_COMMON/prefer_custom_user_config" ]]; then
		echo "Configs differ!"
		if zenity --text-info --title="Use config from latest update?" --filename="$SNAP_USER_COMMON/user_config_diff.txt" --ok-label="Use default config" --cancel-label="Use my config" --width=640 --height=480; then
			# Use default config selected
			rm -r "$FEX_APP_CONFIG_LOCATION"
			cp -r "$SNAP/fex_config" "$FEX_APP_CONFIG_LOCATION"
		else
			# Keep user config
			touch "$SNAP_USER_COMMON/prefer_custom_user_config"
		fi
	fi
else
	echo "Copying default FEX config to $FEX_APP_CONFIG_LOCATION"
	cp -r $SNAP/fex_config $FEX_APP_CONFIG_LOCATION
fi

	

# Make FEX thunk libraries visible to pressure-vessel containers
# Also expose hostfs paths for Vulkan ICDs and graphics drivers that the snap can access
export PRESSURE_VESSEL_FILESYSTEMS_RO="/snap/steam/current/usr/share/fex-emu:/snap/steam/current/usr/lib/aarch64-linux-gnu/fex-emu:/var/lib/snapd/hostfs:/var/lib/snapd/lib"

# Enable library loading debug
#export LD_DEBUG=libs,files
#export LD_DEBUG_OUTPUT=$SNAP_USER_COMMON/ld-debug

$SNAP/usr/bin/FEXBash $SNAP/bin/desktop-launch "${desktop_launch_args[@]}"
