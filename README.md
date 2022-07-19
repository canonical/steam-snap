# Steam Snap

This is a snap of Valve's [Steam client][1]. It is intended to run on any system that supports snapd, providing a consistent environment to
run the games separate from the underlying host operating system.

*Currently in beta.*

## Building locally

To build this snap locally, you need [Snapcraft][2].  The project can
be built with the following command:

    snapcraft --use-lxd

Install with

    snap install steam.snap --dangerous

Run with

    snap run steam

## FAQ

### What games can I play?

[Steam Deck verified games][4] are verified by Valve to work on the Steam Deck (Linux-based) and should work on desktop Linux distributions.

[ProtonDB][3] is a great resource for finding community information about specific games and their playability.

To filter your own library, go to your Steam Library tab and click the penguin ([Tux][7]) to show games that run on Linux. Alternatively, click the *advanced filtering options* button, expand the dropdown under *Hardware Support*, and choose a level of verification level of games to filter by.

### How do I use Steam Play / Proton?

**Enable Proton Globally**

`Steam > Settings > Steam Play`

Enabling Steam Play will automatically download Proton compatability libraries for non-native games.

**Enable Proton Individually**

`Right click the game > Properties > Compatbility > Check 'Force the use of...' > Choose a Proton version`

*Note: it is not always beneficial to use Proton; some games run natively on Linux without compatability tools. Additionally, check [ProtonDB][3] for Linux supported games and tips on running.*

### How do I use my dedicated GPU?

#### NVIDIA

**Enabling a graphics card**  
Switch between graphics modes with `sudo prime-select <mode>` and reboot. For games to use your graphics card, `prime-select` should be set to `nvidia` or `on-demand`. Show your current graphics mode with `sudo prime-select query`. *Note: exlcusively using a disrete graphics card (`nvidia` option) will use more power than normal.*

**GPU stats**  
To view programs using your GPU as well as power usage and other information, run `nvidia-smi`. If a game is correctly using your GPU, a listing should appear in `nvidia-smi` after it has started running.

## Troubleshooting

### Switch/Update Branch

**Beta (recommended)**

    snap refresh steam --beta

**Edge (bleeding edge)**  

    snap refresh steam --edge

### Check Version

    snap info steam

### View Logs

Run Steam with

    snap run steam
    
Steam and game-related logs will be displayed in the same terminal window.

### View Snap Directories

    snap run --shell steam

Then, run `cd $SNAP` as most directories you want will be here. Other useful directories may be listed in `env`.

### HiDPI

Enable HiDPI support in the client by going to `Steam > Settings > Interface` and check *Enlarge text and icons based on monitor size*. Then, restart Steam for the changes to take effect.

With PR [#34][9], Steam should correctly display cursors at their right size (and with the right icons!).

The [Arch wiki][8] also has some information regarding Steam and HiDPI issues.

### Issues

Check [existing issues](5) for information regarding any issue you may have first. If nothing exists, open a new issue describing your problem [here][6]. Helpful information to include would be your Steam snap and Snapd versions, Proton version(s), system/GPU information, and any relevant logs.

### Using Unverified Builds

***Unverified builds are UNTESTED and may not be stable.**  
You probably shouldn't be doing this unless recommended to or are testing a specific fix. **Always** revert back to a verified branch afterwards.*

#### Installing

Download the `snap` artifact you need from its Action. They usually can be found on the "Summary" tab of the Action cooresponding to the commit/merge. [All action runs can be found here, too](https://github.com/canonical/steam-snap/actions).

Unzip the file you downloaded and open up a terminal. Run `snap install /path/to/your/steam.snap --dangerous`.

Now, run Steam as usual with `snap run steam`.

#### Revert to Verified

After testing the change, you need to revert back to a verified branch to get regular updates again.

Run `snap refresh steam --amend` to switch to a verified branch.

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://www.protondb.com/
[4]: https://store.steampowered.com/greatondeck
[5]: https://github.com/canonical/steam-snap/issues
[6]: https://github.com/canonical/steam-snap/issues/new/choose
[7]: https://en.wikipedia.org/wiki/Tux_(mascot)
[8]: https://wiki.archlinux.org/title/HiDPI#Steam
[9]: https://github.com/canonical/steam-snap/pull/34
