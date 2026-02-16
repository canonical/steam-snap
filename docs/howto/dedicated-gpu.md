---
myst:
  html_meta:
    "description lang=en":
      "Install the Steam snap on Ubuntu."
---

(howto::dedidcated-gpu)=
# How do to use your dedicated GPU

## NVIDIA

### 32-bit Driver

```{tip}
It is recommended to install the 32-bit NVIDIA drivers alongside your usual 64-bit NVIDIA drivers for the best experience.
```

To install on Ubuntu, run:

```shell
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libnvidia-gl-<YOUR_DRIVER_VERSION>:i386
```

Replace `<YOUR_DRIVER_VERSION>` with your NVIDIA driver version. This can be
found in `nvidia-smi` or something like `glxinfo -B`.

### Enabling a graphics card

Switch between graphics modes with `sudo prime-select <mode>` and reboot. For games to use your graphics card, `prime-select` should be set to `nvidia` or `on-demand`. Show your current graphics mode with `sudo prime-select query`. *Note: exclusively using a discrete graphics card (`nvidia` option) will use more power than normal.*

### GPU stats

To view programs using your GPU as well as power usage and other information, run `nvidia-smi`. If a game is correctly using your GPU, a listing should appear in `nvidia-smi` after it has started running.

### Launch arguments

If a game is not using your NVIDIA GPU by default, then it may be worth trying to pass NVIDIA's environment variables in as launch options for the game. For example:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```
