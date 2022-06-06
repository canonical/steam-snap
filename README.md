# Steam Snap

This is a snap of Valve's [Steam client][1].  It is intended to run on any system that supports snapd, providing a consistent environment to
run the games separate from the underlying host operating system.

## Building locally

To build this snap locally, you need [Snapcraft][2].  The project can
be built with the following command:

    $ snapcraft --use-lxd
    
## Troubleshooting

### What games can I play?

[Steam Deck verified games][4] are verified by Valve to work on the Steam Deck (Linux-based) and should work on desktop Linux distributions.

[ProtonDB][3] is a great resource for finding community information about specific games and their playability.

To filter your own library, go to your Steam Library tab and click the penguin ([Tux][7]) to show games that run on Linux. Alternatively, click the *advanced filtering options* button, expand the dropdown under *Hardware Support*, and choose a level of verification level for games to filter by.

### Steam Play / Proton

**Enable Proton Globally**  
`Steam > Settings > Steam Play`

Enabling Steam Play will automatically download Proton compatability libraries for non-native games.

**Enable Proton Individually**  
`Right click the game > Properties > Compatbility > Check 'Force the use of...' > Choose a Proton version`

*Note: it is not always beneficial to use Proton; some games run natively on Linux without compatability tools. Additionally, check [ProtonDB][3] for Linux supported games and tips on running.*

### NVIDIA GPUs

**Enabling a graphics card**  
Switch between graphics modes with `sudo prime-select <mode>` and reboot. For games to use your graphics card, `prime-select` should be set to `nvidia` or `on-demand`. Show your current graphics mode with `sudo prime-select query`. *Note: exlcusively using a disrete graphics card (`nvidia` option) will use more power than normal.*

**GPU stats**  
To view programs using your GPU as well as power usage and other information, run `nvidia-smi`. If a game is correctly using your GPU, a listing should appear in `nvidia-smi` after it has started running.

### Viewing Logs

Logs will be output to the terminal if Steam is started from the terminal. Run Steam with `snap run steam`; Steam and game-related logs will be displayed in the same window.

### Issues

Check [existing issues](5) for information regarding any issue you may have first. If nothing exists, open a new issue describing your problem [here][6]. Helpful information to include would be your Steam snap and Snapd versions, Proton version(s), system/GPU information, and any relevant logs.

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://www.protondb.com/
[4]: https://store.steampowered.com/greatondeck
[5]: https://github.com/canonical/steam-snap/issues
[6]: https://github.com/canonical/steam-snap/issues/new/choose
[7]: https://en.wikipedia.org/wiki/Tux_(mascot)
