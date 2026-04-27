---
relatedlinks: "[Documentation&#32;for&#32;the&#32;debian&#32;package&#32;of&#32;Steam](https://wiki.debian.org/Steam)"
myst:
  html_meta:
    "description lang=en":
      "A comparison between the snap and deb version of the Steam client."
---

(explanation::snap-versus-deb)=
# Comparing the snap and deb versions of Steam

Ubuntu supports installing software applications in the snap or deb format.

Both the {term}`snap` and deb versions of Steam provide the full Steam client
experience on Ubuntu. However, they differ in packaging, management, and
bundled features.

```{admonition} Official documentation for the Debian package
:class: important
Using the Debian package may have specific requirements, such as enabling the
i386 architecture and installing dependencies.

If you prefer to use the Debian package, refer to the [Debian wiki
for its Steam documentation](https://wiki.debian.org/Steam).
```

## Key differences

### Packaging and distribution

The deb version is the traditional Debian package available from the official
Steam repositories or as a downloadable `.deb` file.

The snap version bundles Steam and its dependencies in a self-contained package
managed by {term}`snapd`.

### Updates

The deb version requires manual updates or system package manager updates.

The snap version receives automatic updates in the background.

### Confinement and security

The snap runs with {term}`confinement`, restricting access to system resources
unless explicitly granted through {term}`snap connections <snap connection>`.

The deb version has unrestricted system access.

### File locations

The deb version stores game libraries and configuration files in traditional
locations like `~/.steam` and `~/.local/share/Steam`.

The snap version uses confined directories under `~/snap/steam/`.

### Bundled features

The snap includes additional gaming tools, including:

* **{term}`MangoHud`** - performance monitoring overlay (see {ref}`howto::configure-mangohud`)

When using the deb version, these tools must be installed separately.

## Game compatibility

Both versions support broadly the same number of games.

See [What games can I play?](what-games-can-i-play) for more information on game compatibility.

