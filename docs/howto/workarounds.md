---
myst:
  html_meta:
    "description lang=en":
      "Workarounds when using the Steam snap with certain games."
---

(howto::workarounds)=
# Workarounds

Known workarounds for various games that may have trouble running in a snap
environment. Take care when applying these fixes, as they often require
manually running potentially destructive shell commands.

(howto::workarounds-deus-ex)=
## Deus Ex: Revision

[Deus Ex: Revision on Steam](https://store.steampowered.com/app/397550/Deus_Ex_Revision)

Source: https://github.com/canonical/steam-snap/issues/78#issuecomment-1334686442

---

This "game" is actually a mod over [Deus
Ex](https://store.steampowered.com/app/6910/Deus_Ex_Game_of_the_Year_Edition/),
you **must** have the base [Deus Ex
GOTY](https://store.steampowered.com/app/6910/Deus_Ex_Game_of_the_Year_Edition/)
game installed as well as Deus Ex: Revision for it to work.

(howto::workarounds-factorio)=
## Factorio

[Factorio on Steam](https://store.steampowered.com/app/427520/Factorio)

Source: https://github.com/canonical/steam-snap/discussions/91#discussioncomment-5398406*

Further context: https://wiki.factorio.com/Application_directory

---

Factorio will try to write to `~/.factorio` to save game data, but this isn't
allowed for snaps. Follow these steps to fix this:

1. Open
   `~/snap/steam/common/.steam/steam/steamapps/common/Factorio/config-path.cfg`
2. Change `use-system-read-write-data-directories=true` to
   `use-system-read-write-data-directories=false`
3. Change `config-path=__PATH__system-write-data__/config` to
   `config-path=__PATH__executable__/../../config`

This will cause Factorio to use the config file at `~/snap/steam/common/.steam/steam/steamapps/common/Factorio/config/config.ini`, so, let's create the `config.ini` file:

1. Ensure the `config` directory exists, e.g. `mkdir -p
   ~/snap/steam/common/.steam/steam/steamapps/common/Factorio/config`
2. Create the file
   `~/snap/steam/common/.steam/steam/steamapps/common/Factorio/config/config.ini`
   and open it up
3. Add this content verbatim:
    ```ini
    [path]
    read-data=__PATH__executable__/../../data
    write-data=__PATH__executable__/../../writedata
    ```

You should be able to start Factorio now! If Factorio asks to reset the config
file, select "yes" (it will keep the custom paths we put in).

```{note}
You may lose out on Steam's cloud sync functionality by changing the save
directories like this. To work around that, you can pretty easily just copy the
files in
`~/snap/steam/common/.local/share/Steam/steamapps/common/Factorio/writedata` to
any other computer.
```

## Paradox Interactive games

Source: https://github.com/canonical/steam-snap/issues/469
([original](https://forum.paradoxplaza.com/forum/threads/mods-are-not-loading-linux.1440006/post-29917964))

The Paradox launcher and games sometimes have different methods of determining
the user's home directory to store configuration files, resulting in
configurations from the launcher not being reflected in games. You can fix this
by manually linking the appropriate configuration directories to the correct
directory in the snap.

Running the following script will copy config files from
`$HOME/.local/share/Paradox Interactive` (the "incorrect" directory) to
`$HOME/snap/steam/common/.local/share/Paradox Interactive` (the "correct"
directory), and links the directories to so they share the same data:

```bash
#!/bin/bash

launcher_dir="$HOME/.local/share/Paradox Interactive"
game_dir="$HOME/snap/steam/common/.local/share/Paradox Interactive"

if [[ ! -d "$launcher_dir" || ! -d "$game_dir" ]]; then
  echo "One or both directories do not exist. Please check the paths."
  exit 1
fi

cp -r "$launcher_dir/"* "$game_dir/"

rm -rf "$launcher_dir"

ln -s "$game_dir" "$launcher_dir"
```
