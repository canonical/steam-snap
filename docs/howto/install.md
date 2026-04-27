---
relatedlinks: "[Documentation&#32;for&#32;the&#32;debian&#32;package&#32;of&#32;Steam](https://wiki.debian.org/Steam)"
myst:
  html_meta:
    "description lang=en":
      "Install the Steam snap on Ubuntu."
---

(howto::install)=
# Installing the Steam snap

Installing Steam using different methods, configuring snap connections, and
uninstalling the snap.

## Install via the App Center

To install Steam using the graphical **App Center**, press the {kbd}`super` key,
search for "app center", and open it.

Find "Steam" in the App Center and click {guilabel}`Install`.

```{image} ../assets/app-center-dark.webp
:alt: Installation page for Steam in App Center.
:class: only-dark
:align: center
```

```{image} ../assets/app-center-light.webp
:alt: Installation page for Steam in App Center.
:class: only-light
:align: center
```

## Install via command-line

To install Steam using the **terminal**, run the following command:

```shell
snap install steam
```

## Configure snap connections

Most {term}`snap connections <snap connection>` that you need will be automatically connected for you.

<!-- TODO: why is this not done automatically? -->
It is recommended (but not required) to connect the following manually:

<!-- TODO: is the first observe for software and the second hardware? -->
* `system-observe`: for system compatibility
* `hardware-observe`: also for better compatibility
* `audio-record`: if you use any of Steam's voice chat or recording features

To do so, run the following commands:

```shell
snap connect steam:system-observe
snap connect steam:hardware-observe
snap connect steam:audio-record
```

For more information on the {term}`snap connections <snap connection>`, run

```shell
snap connections steam
```

(howto::uninstall)=
## Uninstall the Steam snap

<!-- TODO: it might be good to explain if there is ever an advantage to taking snapshots, as currently it just seems like a nuisance -->
Snap automatically creates a data snapshot when a snap is removed. They can be incredibly large and take a long time
to create, since they also contain your Steam library.

It is therefore recommended to disable [snapshots](https://snapcraft.io/docs/snapshots#heading--automatic-snapshots)
when uninstalling Steam.

To remove Steam and its data without creating a snapshot, run

```shell
snap remove --purge steam
```

To disable snapshots for **all** snaps, run

```shell
snap set system snapshots.automatic.retention=no
```

Then, Steam can be removed with

```shell
snap remove steam
```

<!-- TODO: if someone uninstalls through the app center, what is the behaviour? -->
