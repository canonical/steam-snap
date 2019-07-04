# Steam Snap

This is a snap of Valve's [Steam client][1].  It is intended to run on top
of the [SteamOS base snap][2], providing a consistent environment to
run the games separate from the underlying host operating system.

## Building locally

To build this snap locally, you need [Snapcraft][3].  The project can
be built with the following command:

    $ snapcraft

Snapcraft will warn that it is running in legacy mode due to the lack
of the `base` keyword.  This can be safely ignored: we currently need
to trigger legacy mode to build against a custom base snap.

[1]: https://store.steampowered.com/about/
[2]: https://github.com/CanonicalLtd/steamos-base-snap
[3]: https://docs.snapcraft.io/snapcraft-overview
