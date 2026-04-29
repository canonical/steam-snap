---
myst:
  html_meta:
    "description lang=en":
      "Contribute Steam game reports for Ubuntu."
---

(contribute::reports)=
# Game reports

Individual games and setups may have unique issues, and we welcome
reports on how games function on your setup.

{bdg-secondary}`Tool added in revision 66`

We bundled a tool with the Steam snap that makes it easy for you to collect
system information and open a discussion or issue about a game.

## Reports and issues

Discussion posts are a way to communicate a game's functionality with your
setup. They can be used to discuss workarounds with other users of the Steam
snap and troubleshoot common issues.

If the game, your setup, or other users' setups exposes a new problem, an issue
should be opened.

The maintainers of the Steam Snap try to fix issues quickly. Discussions help
reduce issue clutter, so the maintainers can focus on new issues. 

## Submit reports and issues from the Steam snap

Reports and issues can be created using a graphical dialog.

{bdg-secondary}`Graphical dialog added in revision 165`

To use it, follow the steps below:

1. Ensure `system-observe` and `hardware-observe` are connected:

   ```shell
   snap connect steam:system-observe
   snap connect steam:hardware-observe
   ```

2. Right click Steam and select {guilabel}`Report`, or run
   `snap run steam.report` from a terminal.
3. If the necessary snap connections aren't enabled, you'll be prompted to connect them.
4. The report tool may take a few seconds to gather information.
5. Copy the resulting report, or use the buttons to open a new issue or
   discussion with your report information auto-filled.

```{image} ../assets/troubleshoot-report-dialog-dark.png
:alt: Example Steam report dialog.
:class: only-dark
:align: center
```

```{image} ../assets/troubleshoot-report-dialog-light.png
:alt: Example Steam report dialog.
:class: only-light
:align: center
```

### Reporting from the terminal

The CLI version of the report tool can still be used:

```shell
snap run steam.report --cli
```

## File an issue

Check [existing issues](https://github.com/canonical/steam-snap/issues) for
information regarding any issue you may have first. 

If nothing exists,
[open a new issue](https://github.com/canonical/steam-snap/issues/new) describing
your problem. 

Here is some helpful information that you can include with your issue:

* Steam Snap and snapd versions
* Proton version(s)
* System/GPU information
* Any relevant logs

You may use the Steam Report tool to gather most of this
information automatically, by running:


```shell
snap run steam.report --cli --no-submit
```
