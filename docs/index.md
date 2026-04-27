---
relatedlinks: "[Documentation&#32;for&#32;the&#32;debian&#32;package&#32;of&#32;Steam](https://wiki.debian.org/Steam)"
myst:
  html_meta:
    "description lang=en":
      "Run steam in a snap."
---

# Steam on Ubuntu

Valve's Steam client is available to Ubuntu users as a {term}`snap`.

The Steam {term}`snap` provides a consistent environment to run games. The
environment is separate from the underlying host operating system and receives
automatic updates. It also comes bundled with useful tools, like
{term}`MangoHud`.

The snap can be run on any system that supports {term}`snapd`, including
Ubuntu.

## In this documentation

* **Installation**: {ref}`Install the Steam snap <howto::install>` • {ref}`Check version and update <howto::update-version>` • {ref}`Uninstall the Steam snap <howto::uninstall>`
* **Gaming setup**: {ref}`Configure Steam Play/Proton <howto::configure-proton>` • {ref}`Set up a controller <howto::set-up-controller>` • {ref}`What games can I play? <explanation::what-games-can-i-play>`
* **Graphics and performance**: {ref}`Use your dedicated GPU <howto::dedicated-gpu>` • {ref}`Change mesa/graphics version <howto::change-mesa-graphics>` • {ref}`Configure MangoHud <howto::configure-mangohud>`
* **Troubleshooting**: {ref}`Troubleshoot common issues <howto::troubleshooting>` • {ref}`Find game-specific workarounds <howto::game-workarounds>`
* **Reference**: {ref}`Glossary <reference::glossary>` • {ref}`Locations for external libraries <reference::external-libraries>` • {ref}`Helpful links <reference::external-links>`
* **Additional information**: {ref}`Snap vs. deb comparison <explanation::snap-versus-deb>` • {ref}`Testing the Steam snap <howto::test-steam-snap>`

## How the documentation is organised

This documentation uses the [Diátaxis structure](https://diataxis.fr/).

* {ref}`How-to guides <howto>` provide you with the steps necessary for completing specific tasks.
* {ref}`References <reference>` give you concise and factual information to support your understanding.
* {ref}`Explanations <explanation>` include topic overviews and additional context on the software.

## Project and community

The Steam snap is an open-source project that warmly welcomes community
contributions, suggestions, fixes and constructive feedback.

* [Code of conduct](https://ubuntu.com/community/ethos/code-of-conduct)

```{toctree}
:hidden:
:titlesonly:

Home <self>
How-to guides </howto/index>
Reference </reference/index>
Explanation </explanation/index>
```
