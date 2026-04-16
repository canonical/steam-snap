---
relatedlinks: "[Documentation&#32;for&#32;the&#32;debian&#32;package&#32;of&#32;Steam](https://www.ubuntu.com/desktop/wsl)"
myst:
  html_meta:
    "description lang=en":
      "Install the Steam snap on Ubuntu."
---

(howto::install)=
# Installing the Steam snap

Installing Steam using different methods, configuring snap connections, and
uninstalling the snap.

## Install with the App center or the terminal

To install Steam using the graphical **App center**, press the {kbd}`super` key,
search for "app center", and open it.
Find "Steam" in the App Center and click {guilabel}`install`.

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

```{admonition} Disabling snapshots
:class: tip
<!-- TODO: it might be good to explain if there is ever an advantage to taking snapshots, as currently it just seems like a nuisance -->
You should consider disabling
[snapshots](https://snapcraft.io/docs/snapshots#heading--automatic-snapshots)
when uninstalling Steam. Snapshots can be incredibly large and take a long time
to create since they also contain your Steam library.
```

### Uninstalling without creating a snapshot

#### Option 1: remove Steam and its data with no snapshot

```text
snap remove --purge steam
```

#### Option 2: disable snapshots for all snaps then remove Steam

```text
snap set system snapshots.automatic.retention=no
snap remove steam
```

<!-- TODO: if someone uninstalls through the app center, what is the behaviour? -->
