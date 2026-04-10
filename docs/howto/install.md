---
myst:
  html_meta:
    "description lang=en":
      "Install the Steam snap on Ubuntu."
---

(howto::install)=
# Install the Steam snap

## App store

Hit the {kbd}`super` key, search for "app center" and open it.

Find "Steam" in the App Center and click {guilabel}`install`.

## Terminal

Install Steam using the terminal with:

```shell
snap install steam
```

````{dropdown} Alternative: Install the Steam deb
:icon: terminal

If you would prefer to install the deb, go to the [Steam
website](https://store.steampowered.com/about/) and click {guilabel}`INSTALL
STEAM`.

This will install `steam_latest.deb` to your Downloads directory.

Change into downloads:

```shell
cd ~/Downloads/
```

Then install the deb with:

```shell
sudo apt install ./steam_latest.deb 
```

---

You can also install `steam-installer` as a deb.

```shell
sudo apt install steam-installer
```

This requires enabling the i386 architecture and installing additional
libraries, which is outlined in more detail in the [Debian documentation for
Steam](https://wiki.debian.org/Steam).
````

## Snap connections

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

```{note}
If you want to uninstall the snap, read the [dedicated guide](/howto/uninstall).
```
