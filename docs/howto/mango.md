---
myst:
  html_meta:
    "description lang=en":
      "Enable MangoHUD in the Steam snap on Ubuntu."
---

(howto::mango)=
# Enabling MangoHud

{term}`MangoHud` is bundled with the Steam {term}`snap` and can be enabled.

```{admonition} Experimental
:class: important
{term}`MangoHUD` support is experimental and will likely only work with **OpenGL**
games. Please do not open issues relating solely to {term}`MangoHUD` compatibility.
```

## Using MangoHud

Add `mangohud %command%` to your game launch options.

```{seealso}
[Normal usage](https://github.com/flightlessmango/MangoHud#normal-usage) in the MangoHud documentation.
```

## Configuring MangoHud

### Environment variables

You may add configuration options to your launch options by specifying the
`MANGOHUD_CONFIG` environment variable in your launch options.

For example, `MANGOHUD_CONFIG=time mangohud %command%`.

### Configuration files

1. Run `snap run --shell steam`
2. Make the {term}`MangoHud` config directory: `mkdir -p ~/.config/MangoHud`
3. Copy the default config file: `cp $SNAP/usr/share/doc/mangohud/MangoHud.conf.example ~/.config/MangoHud/MangoHud.conf`
4. Edit `~/.config/MangoHud/MangoHud.conf` to your liking
5. Run {term}`MangoHud` like usual

```{seealso}
[Configuration](https://github.com/flightlessmango/MangoHud#hud-configuration) in the MangoHud documentation.
```

