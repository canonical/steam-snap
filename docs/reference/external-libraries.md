---
myst:
  html_meta:
    "description lang=en":
      "Useful links for Steam users on Ubuntu."
---

(ref::external-libs)=
# Locations for external libraries

The default install directory will be listed as `/var/lib/modules`, which
actually points to `~/snap/steam/common/.local/share/steam`.

You can add external storage libraries as you normally would through `Steam
settings > Storage`, but the snap is restricted to libraries located in `/home/<user>`,
`/media`, `/run/media`, or `/mnt`.

This same restriction applies when adding non-Steam games.
