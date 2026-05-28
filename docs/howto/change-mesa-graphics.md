---
myst:
  html_meta:
    "description lang=en":
      "Change the mesa/graphics version for the Steam snap on Ubuntu."
---

(howto::change-mesa-graphics)=
# Change the mesa/graphics version

The Steam snap relies on the [gaming-graphics-core24 snap](https://github.com/canonical/gaming-graphics/) for
graphics packages. You can verify this by running `snap connections steam`.  

You may switch
[gaming-graphics-core24](https://github.com/canonical/gaming-graphics/) to a different channel to use
different versions of mesa and other graphics libraries.

Currently, the channels are:
* `kisak-turtle` (most stable)
* `kisak-fresh` (new, but stable)
* `oibaf-latest` (bleeding edge)

Switch between them with the following command:

```shell
snap refresh gaming-graphics-core24 --channel <channel>
```

To find what version of the [gaming-graphics-core24](https://github.com/canonical/gaming-graphics/) Snap you have, use the following command:

```shell
snap info gaming-graphics-core24
```
