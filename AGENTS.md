# Steam Snap

Snap package of [Valve](https://www.valvesoftware.com/en/)'s
[Steam](https://store.steampowered.com/) client (strict confinement, `core26` base).

## Development

### Repository layout

- `snap/snapcraft.yaml`: snap definition: parts, layouts, plugs, environment, apps.
- `snap/hooks/`: snap hooks (`configure`).
- `src/`: launcher and helper scripts staged into `$SNAP/bin` (e.g. `desktop-launch`,
  `steam-snap.sh`, `steamreport`, splash/watchdog). Shell scripts are checked with
  `shellcheck` in CI.
- `tests/`: GLX/Vulkan smoke tests, run via `snap run steam.test`.
- `docs/`: Sphinx docs published at https://ubuntu.com/docs/steam/.

### Build and test

```shell
# Build the snap
snapcraft pack -v
# Install locally-built snap
sudo snap install steam_*.snap --dangerous
# Run smoke tests
snap run steam.test
# Shell inside the snap
snap run --shell steam
```

### Runtime paths

- `/snap/steam/current`: installed snap contents (`$SNAP`).
- `~/snap/steam/common/`, `$SNAP_USER_COMMON`: Steam runs with `HOME` set here.
- `~/snap/steam/common/.steam/`: actual Steam files. Most entries are symlinks
  into `~/snap/steam/common/.local/share/Steam/` (`.steam/root`, `.steam/steam`),
  which holds the client, `steamapps`, `logs`, Steam Runtime
  (`steamrt32`/`steamrt64`), and `compatibilitytools.d` for custom Proton builds
  (created by the user, may not exist).
- `$SNAP/graphics`: mount point for the [`gaming-graphics-core26`](https://github.com/canonical/gaming-graphics) content snap,
  which provides the graphics stack (Mesa, Vulkan drivers, etc.). On the host it
  lives at `/snap/gaming-graphics-core26/current`. Many layouts and
  `LD_LIBRARY_PATH`/`LIBGL_DRIVERS_PATH` entries in `snapcraft.yaml` point into it,
  so inspect it when debugging graphics issues. Channels: `kisak-fresh`,
  `kisak-turtle`, `oibaf-latest`.

## External references

- Steam snap wiki: https://wiki.ubuntu.com/Steam_snap
- Steam for Linux (Valve docs and issue tracker; search for existing issues):
  https://github.com/ValveSoftware/steam-for-linux
- SteamVR for Linux (same, for VR): https://github.com/ValveSoftware/SteamVR-for-Linux
- Proton: https://github.com/ValveSoftware/Proton
- Steam Runtime tools (pressure-vessel, container/sandboxing internals):
  https://gitlab.steamos.cloud/steamrt
- ProtonDB (user-sourced per-game compatibility reports): https://www.protondb.com/
- Gaming graphics source PPA: https://launchpad.net/~kisak/+archive/ubuntu/kisak-mesa
