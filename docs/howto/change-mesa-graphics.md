---
myst:
  html_meta:
    "description lang=en":
      "Change the mesa/graphics version for the Steam snap on Ubuntu."
---

(howto::mesa-graphics)=
# Changing the mesa/graphics version

The Snap relies on the [gaming-graphics-core24 Snap](https://github.com/canonical/gaming-graphics/) for
graphics packages (see `snap connections steam`). You may switch
[gaming-graphics-core24](https://github.com/canonical/gaming-graphics/) to a different channel to use
different versions of mesa and other graphics libraries.

Currently, the channels are `oibaf-latest` (bleeding edge), `kisak-fresh` (new,
but stable), and `kisak-turtle` (most stable). Switch between them with the
following:

```shell
snap refresh gaming-graphics-core24 --channel <channel>
```

