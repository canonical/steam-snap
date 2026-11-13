# Steam Snap

This is a snap of Valve's [Steam client][1]. It is intended to run on any system that supports snapd, providing a consistent environment to
run the games separate from the underlying host operating system.

## Building locally

To build this snap locally, you need [Snapcraft][2].  The project can
be built with the following command:

    sudo snap install snapcraft --classic
    ./build.sh

This branch builds for ARM64 on Ubuntu 26.04 (`core26`) and uses FEX to run
the x86 Steam client. Snapcraft uses an isolated LXD build environment and
downloads the amd64 client and rootfs artifacts specified in
`snap/snapcraft.yaml`; no local tarballs are required.

Builds are incremental. For a fresh build, run `snapcraft clean --use-lxd`
before `./build.sh`. Additional Snapcraft pack options can be passed to
`./build.sh`.

Install with

    sudo snap install ./steam_1.0.0.87_arm64.snap --dangerous

Run with

    snap run steam

## Launcher tests and game diagnostics

Run the launcher regression tests without starting Steam:

    python3 -B -m unittest discover -s tests -p 'test_*.py' -v

The FEX launcher uses bubblewrap to bind the real snap home into the
interpreter root in a private mount namespace. This keeps `.steam` and the
client SDK visible to nested Steam runtimes without changing canonical paths
or deleting old shadow data (which is preserved in `fex-shadow-backup.*`).

To capture a Proton log, first exit any running Steam client, then run:

    PROTON_LOG=1 PROTON_LOG_DIR="$HOME/snap/steam/common" steam -applaunch 1091500 --launcher-skip

For Cyberpunk 2077, the log is written to
`~/snap/steam/common/steam-1091500.log`. A successful snap build alone does
not establish that a particular game runs successfully under FEX.

# [For questions and troubleshooting, see the wiki][3].

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://github.com/canonical/steam-snap/wiki
