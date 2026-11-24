# Steam Snap

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/steam)

This is a snap of Valve's [Steam client][1]. It is intended to run on any system that supports snapd, providing a consistent environment to
run the games separate from the underlying host operating system.

## Installing

To install the Snap from the [official store](https://snapcraft.io/steam), run:

```
snap install steam
```

## Building & Installing Locally

To build this snap locally, you need [Snapcraft][2].  The project can
be built with the following command:

    snapcraft pack

Install with

    snap install steam.snap --dangerous

Run with

    snap run steam

After development and testing, be sure to revert to the official version of the Snap:

    snap refresh steam --stable --amend

## Documentation

For more information, refer to the [official Steam snap documentation][3].

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://documentation.ubuntu.com/steam/
