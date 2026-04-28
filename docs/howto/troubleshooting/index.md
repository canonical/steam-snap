---
relatedlinks: "[ProtonDB](https://www.protondb.com/)"
myst:
  html_meta:
    "description lang=en":
      "Troubleshoot the Steam snap on Ubuntu."
---

(howto::troubleshooting)=
# Troubleshooting

## Generic workarounds

Give these a try before opening an issue.

- If you can't run a {term}`native game`, try forcing {term}`Proton` Experimental.
- If you can't run a game installed in another storage device, try installing the game on the default storage device instead.
- If you can't run a game with your dedicated GPU and have an integrated GPU, try using your integrated GPU.
- Connect `hardware-observe` and `system-observe`: `snap connect steam:hardware-observe`, `snap connect steam:system-observe`.
- Restart your computer (especially after updating packages or {term}`snaps <snap>` relating to Steam or drivers)

You can still open an issue if one of these workarounds fixes a problem, but please include what you've tried in your issue.

## Troubleshooting specific games

You may check the [reports][reports] discussions for troubleshooting tips with a specific game, and expected results. Also check {term}`ProtonDB` to see if your game *should* work based on other's input. If our [reports][reports] don't contain the game you're experiencing issues with, feel free to add it with the [steam.report tool][steamreport]. Some games may also be listed on the {ref}`known game workarounds page <howto::game-workarounds>`.

You can also check the [PC Gaming Wiki][10] for information on game compatibility, local and cloud game files, and system support.

## Switch/update branch

To test whether the issue has to do with the version of your Steam snap, you can try a different version or branch.

To check your current version/branch:

```shell
snap info steam
```

To switch or update:

```shell
snap refresh steam --<branch>
```

## View logs

### Steam logs

When Steam is run via a command-line interface, **Steam and game-related** logs will be displayed in the same terminal window in real-time.

```shell
snap run steam
```

The most detailed logs can be gathered by compressing the logs found in `~/snap/steam/common/.local/share/Steam/logs` and providing the archive.

### Game logs

To create a file with the output of a specific game, add the following to a game's {ref}`Launch Options <howto::launch-options>`:

```text
%command% > $HOME/game_log 2>&1
```

This will create a text file containing the game's output in `/home/$USER/snap/steam/common/game_log`. (Credit to [*thatLeaflet.*](https://github.com/canonical/steam-snap/issues/49#issuecomment-1294286910))

Alternatively, just copy/paste the logs from running Steam in the terminal starting from pressing the "Play" button in Steam.

### Kernel logs

The `dmesg` command outputs kernel messages from the ring buffer. It includes information about hardware, drivers, and system errors:

```shell
sudo dmesg
```

Particularly, lines with `apparmor="DENIED"` **and** `"snap.steam.steam"` are most useful.

## Enter snap shell

<!--TODO: what's in here that could be helpful for troubleshooting?-->
To enter the snap shell, run

```shell
snap run --shell steam
```

Then, run `cd $SNAP` as most directories you want will be here. Other useful directories may be listed in `env`. 

Type `exit` or press {kbd}`Ctrl`+ {kbd}`D` to exit.

(howto::launch-options)=
## Launch options

You can modify the launch options for a specific game by right-clicking the game in your Library and clicking on {guilabel}`Properties`. The launch options are in the {guilabel}`General` tab. 

Any options should end with `%command%`.

```{seealso}
[Setting Game Launch Options](https://help.steampowered.com/en/faqs/view/7D01-D2DD-D75E-2955) from the Steam Support forum.
```

## Steam run options

Steam UI frozen or not responding? Try running Steam with `snap run steam -vgui` to use the old Steam UI, or try `snap run steam --reset`.

```{seealso}
The following GitHub issues contain information about UI bugs:

* [Steam Snap freezes and Becomes Unresponsive](https://github.com/canonical/steam-snap/issues/266#issuecomment-1605657472)
* [Steam bugs with the new update (new UI)](https://github.com/ValveSoftware/steam-for-linux/issues/9649)
* [New Steam UI only opens after running `steam --reset`](https://github.com/ValveSoftware/steam-for-linux/issues/9692)
```

## Using a dedicated GPU

See: {ref}`How to use a dedicated GPU <howto::dedicated-gpu>`.

## HiDPI

Enable HiDPI support in the Steam client by going to {guilabel}`Settings` > {guilabel}`Interface` and check "Enlarge text and icons based on monitor size".

Restart Steam for the changes to take effect.

With PR [#34][9], Steam should correctly display cursors at their right size (and with the right icons!).

The [Arch wiki][8] also has some information regarding Steam and HiDPI issues.

## Submit a Steam report

Individual games and setups will often face unique issues, which is why it may be useful to report games/your setup to us for review. As of Snap revision 66, a script is included to automatically collect some system data and open a new discussion post for reporting.

As of revision 165, this script has be upgraded to use a GTK-based dialog. To use it, follow the steps below:

1. Ensure `system-observe` and `hardware-observe` are connected with `snap connect steam:system-observe` and `snap connect steam:hardware-observe` respectfully 
2. Right click Steam and select "Report", or run `snap run steam.report` from a terminal window
    - If the necessary connections aren't connected, you'll see a prompt to do so
    - *The report window may take a few seconds to gather information*
3. Copy the resulting report, or use the buttons to open a new issue or discussion with your report information auto-filled

Example report dialog:

<img src="https://github.com/canonical/steam-snap/assets/101582426/3ce372bd-f410-4969-b345-a694faf77f85" width="50%" />

The CLI version of the report tool can still be use;, simply run `snap run steam.report --cli`.

```{admonition} GitHub issues
:class: tip

Game report discussions are NOT a replacement for [issues][issues]. Instead, discussion posts are a way to communicate a game's functionality with your setup and troubleshoot with other users. 

**If the game, your setup, or other users' setups expose a new problem, a [GitHub issue][issues] should be opened.** Game report discussions are meant for reducing issue clutter and to discuss workarounds to specific games.
```

## Open a new issue

Check [existing issues][issues] for information regarding any issue you may have first. If nothing exists, open a new issue describing your problem [here][6]. 

Helpful information to include would be your Steam {term}`Snap` and {term}`snapd` versions, {term}`Proton` version(s), system/GPU information, and any relevant logs. You may use the Steam Report tool described above to gather most of the needed information for you, just run it with `--no-submit`.

## Using unverified builds

```{admonition} Unverified builds are UNTESTED and may not be stable.
:class: warning

You probably shouldn't be doing this unless recommended to, or if you are testing a specific fix. 

**Always revert to a verified branch afterwards**.
```

### Installing

Download the `snap` artifact you need from its Action. They usually can be found on the "Summary" tab of the Action corresponding to the commit/merge. [All action runs can be found here, too](https://github.com/canonical/steam-snap/actions).

Unzip the file you downloaded and open up a terminal. Run `snap install /path/to/your/steam.snap --dangerous`.

Now, run Steam as usual with `snap run steam`.

### Revert to verified

After testing the change, you need to revert to a verified branch to get regular updates again.

Run `snap refresh steam --amend` to switch to a verified branch.

```{toctree}
:titlesonly:
:hidden:

Game workarounds <game-workarounds>
```

[1]: https://store.steampowered.com/about/
[2]: https://docs.snapcraft.io/snapcraft-overview
[3]: https://www.protondb.com/
[4]: https://store.steampowered.com/greatondeck
[6]: https://github.com/canonical/steam-snap/issues/new/choose
[7]: https://en.wikipedia.org/wiki/Tux_(mascot)
[8]: https://wiki.archlinux.org/title/HiDPI#Steam
[9]: https://github.com/canonical/steam-snap/pull/34
[10]: https://www.pcgamingwiki.com/wiki
[issues]: https://github.com/canonical/steam-snap/issues
[reports]: https://github.com/canonical/steam-snap/discussions/categories/game-reports
[steamreport]: https://github.com/canonical/steam-snap/wiki/Troubleshooting#submitting-a-steam-report
[workarounds]: https://github.com/canonical/steam-snap/wiki/Known-Workarounds
