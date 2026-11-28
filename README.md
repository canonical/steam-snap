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

If you haven't installed the snap before, you may need to manually make the
connections for it to work correctly.

Run

    snap connections steam

Ensure that most plugs are connected. You can manually connect a plug with

    snap connect steam:my-plug-here

Most importantly, ensure `steam-support` is connected. Alternatively, install
the Steam snap from the store and then install a local build over it.

Run with

    snap run steam

After development and testing, be sure to revert to the official version of the Snap:

    snap refresh steam --stable --amend

### Build in a Workshop VM

With [Workshop](https://ubuntu.com/workshop/docs/), you can iterate and build
the snap from within a VM. This is optional, and just provides a more restricted
and reproducible environment.

```shell
workshop launch dev
workshop run dev -- pack
```

Install the resulting `steam_*.snap` from the checkout root manually on the
host, using its filename with `sudo snap install --dangerous`.

To debug the snap, run `.workshop/connect-host.sh` to copy your OpenCode settings
and attach the host Steam snap directories read-only. Review what you share first:
the VM can read the mounted Steam data, and the copied settings may contain credentials.

Run OpenCode with `workshop run dev -- opencode`.

By default, the script does not copy saved OpenCode provider connections. To
pass provider credentials to the Workshop, run:

```shell
.workshop/connect-host.sh --with-provider-connections
```

Shell into the Workshop with `workshop shell dev`.

Remove the Workshop with `workshop remove dev`.

## Documentation

For more information, refer to the [official Steam snap documentation][3].

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://documentation.ubuntu.com/steam/
