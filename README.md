# Steam Snap

This is a snap of Valve's [Steam client][1]. It is intended to run on any system that supports snapd, providing a consistent environment to
run the games separate from the underlying host operating system.

## Building locally

To build this snap locally, you need [Snapcraft][2].  The project can
be built with the following command:

    snapcraft --use-lxd

Install with

    snap install steam.snap --dangerous

Run with

    snap run steam

# [For questions and troubleshooting, see the wiki][3].

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://github.com/canonical/steam-snap/wiki
