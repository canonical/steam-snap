---
myst:
  html_meta:
    "description lang=en":
      "Uninstall the Steam snap on Ubuntu."
---

(howto::uninstall)=

# Uninstall the Steam snap

## Note on snapshotting

<!-- TODO: it might be good to explain if there is ever an advantage to snapshotting, as currently it just seems like a nuisance -->
You should consider disabling
[snapshotting](https://snapcraft.io/docs/snapshots#heading--automatic-snapshots)
when uninstalling Steam. Snapshots can be incredibly large and take a long time
to create since they also contain your Steam library.

## Uninstalling without creating a snapshot

### Option 1: remove Steam and its data with no snapshot

```shell
snap remove --purge steam
```

### Option 2: disable snapshots for all snaps then remove Steam

```shell
snap set system snapshots.automatic.retention=no
snap remove steam
```

<!-- TODO: if someone uninstalls through the app center, what is the behaviour? -->
