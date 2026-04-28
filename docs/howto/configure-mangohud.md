---
relatedlinks: "[MangoHud](https://mangohud.org/)"
myst:
  html_meta:
    "description lang=en":
      "Enable MangoHud in the Steam snap on Ubuntu."
---

(howto::configure-mangohud)=
# Configure MangoHud

[MangoHud](https://mangohud.org/) is an overlay tool for displaying performance metrics in-game.

It is bundled with the Steam {term}`snap` and disabled by default.

```{admonition} Experimental
:class: caution

{term}`MangoHud` support is experimental and will likely only work with **OpenGL**
games. 

Please do not open issues relating solely to {term}`MangoHud` compatibility.
```

## Enable MangoHud

Right-click on the game title in your library and click on {guilabel}`Properties`. 

In the {guilabel}`General` tab, add `mangohud %command%` to the launch options.

```{seealso}
[Normal usage](https://github.com/flightlessmango/MangoHud#normal-usage) in the MangoHud documentation.
```

## Configure MangoHud

MangoHud can be configured directly via environment variables in the Steam launch options of your game, or via 
MangoHud's dedicated config file.

### Environment variable in launch options

To access a game's launch options on Steam, right-click on the game title in your library and click on {guilabel}`Properties`. 
The launch options are in the {guilabel}`General` tab.

Add configuration options to the launch options by specifying the `MANGOHUD_CONFIG` environment variable. 

For example:

```text
MANGOHUD_CONFIG=time mangohud %command%
```

### Configuration file

To use MangoHud's config file:

1. Run `snap run --shell steam`
2. Make the {term}`MangoHud` config directory: `mkdir -p ~/.config/MangoHud`
3. Copy the default config file: `cp $SNAP/usr/share/doc/mangohud/MangoHud.conf.example ~/.config/MangoHud/MangoHud.conf`
4. Edit `~/.config/MangoHud/MangoHud.conf` to your liking
5. Run {term}`MangoHud` like usual

```{seealso}
[Configuration](https://github.com/flightlessmango/MangoHud#hud-configuration) in the MangoHud documentation.
```

