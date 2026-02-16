---
myst:
  html_meta:
    "description lang=en":
      "Install the Steam snap on Ubuntu."
---

(howto::configure-proton)=
# How to configure Steam Play/Proton?

{term}`Proton`/{term}`Steam Play` isn't always necessary, if the game installs and runs without
{term}`Proton`, it is native and likely works the best without {term}`Proton`.

## Enable Proton for non-native games

`Steam > Settings > Steam Play`

Enabling {term}`Steam Play` will automatically download {term}`Proton` {term}`compatibility layer` libraries
for non-native games. If left disabled, only {term}`native games <native game>` can be installed and
played.

'Enable Steam Play for supported titles' enables {term}`compatibility layer` tools for games
verified by Valve to work well on Linux.

'Enable Steam Play for all other titles' enables {term}`compatibility layer` tools for *all*
non-native games in your library. Unsupported titles greatly vary in
functionality, check {term}`ProtonDB` for more info on specific games.

![Checking Proton settings in Steam.](../assets/proton-protondb.png) 

## Enable Proton for individual games

`Right click the game > Properties > Compatibility > Check 'Force the use
of...' > Choose a Proton version`

## Check if a game is a Native or Proton game

{term}`ProtonDB` will show 'Native' if the game is a {term}`native game`, otherwise it is
a {term}`Proton` game.

Additionally, disabling {term}`Steam Play` entirely will then only then allow you to
install/play {term}`native games <native game>`.

## Use a custom Proton version

[{term}`Proton` GE instructions for reference](https://github.com/GloriousEggroll/proton-ge-custom#snap).

1. Run Steam at least once
2. Create the `compatibilitytools.d` directory

    ```shell
    mkdir -p ~/snap/steam/common/.steam/root/compatibilitytools.d
    ```
3. Extract custom {term}`Proton` versions to the above directory
  - For example, [proton-ge](https://github.com/GloriousEggroll/proton-ge-custom)
4. Run Steam, and you should be able to select your custom version from the {term}`Proton` version dropdown like normal
