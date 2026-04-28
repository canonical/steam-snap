(reference::glossary)=
# Glossary

```{glossary}
Compatibility Layer
  Software that enables programs designed for one platform to run on another. Proton is a compatibility layer that allows Windows games to run on Linux.

Confinement
  The security isolation that snaps run under, restricting their access to system resources. Snaps can have strict confinement (limited access), classic confinement (full system access), or devmode (development mode).

GameMode
  A Linux daemon/library that optimizes system performance for gaming by adjusting CPU governor, I/O priority, and other settings when games are running.

gaming-graphics-core24-snap
  Graphics stack useful as a content snap for gaming snaps.

MangoHud
  An overlay for monitoring system performance in games, showing metrics like frame rate (FPS), CPU/GPU usage, and temperatures on Linux.

Native Game
  A game that has been compiled and designed to run directly on Linux without requiring compatibility layers like Proton.

Proton
  Valve's compatibility layer that allows Windows games to run on Linux. Based on Wine and additional libraries, Proton translates Windows API calls to Linux equivalents.

ProtonDB
  A community-driven database that tracks how well Windows games run on Linux using Proton. Users submit reports and ratings for game compatibility.

Snap
  A universal Linux package format that bundles an application and its dependencies in a confined environment. Snaps work across different Linux distributions and are enabled by default in Ubuntu.

Snap Connection
  A connection between occurs when a snap needing a resource is connected to another snap that provides that resource.

Snap Interface
  Snaps can only access resources from the system and other snaps through interfaces that describe the resources they provide.

Snapd
  The background service (daemon) that manages and runs snaps on a Linux system. It handles installation, updates, and the security confinement of snap packages.

Steam Deck
  Valve's handheld gaming device that runs SteamOS (a Linux-based operating system). Games verified for Steam Deck are generally compatible with Linux desktop systems.

Steam Play
  Valve's technology that enables cross-platform gaming. In the context of Linux, Steam Play uses Proton to run Windows-only games on Linux systems.
```
