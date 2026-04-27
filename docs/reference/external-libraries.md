---
myst:
  html_meta:
    "description lang=en":
      "Locations of external libraries for the Steam snap."
---

(reference::external-libraries)=
# Locations for external libraries

The default install directory could be misleadingly listed as
`/usr/lib/modules`, but this actually points to
`~/snap/steam/common/.local/share/steam`.

You can verify the actual install directory by opening the Steam client and navigating to 
{guilabel}`Settings` > {guilabel}`Storage`.

Note the full path listed above the storage space indicator:

![Finding the install directory in Steam storage settings.](../assets/external-libs.png)

You can add external storage libraries as you normally would through Steam
{guilabel}`Settings` > {guilabel}`Storage`, but the snap is restricted to libraries located in `~`,
`/media`, `/run/media`, or `/mnt`.

This same restriction applies to adding non-Steam games.
