---
myst:
  html_meta:
    "description lang=en":
      "Install GPU drivers and enable dedicated graphics cards, such as NVIDIA, to run your Steam snap games."
---

(howto::dedicated-gpu)=
# Use a dedicated GPU

<!--TODO: some broad context on what users should know/care about launching games via the steam snap on a dedicated GPU-->

## NVIDIA

### 32-bit Driver

It is recommended to install the 32-bit NVIDIA drivers alongside your usual 64-bit NVIDIA drivers for the best experience.
<!--TODO: Why? Is this still relevant after NVIDIA dropped support for 32-bit?-->

To install the 32-bit NVIDIA driver on Ubuntu, run:

```shell
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libnvidia-gl-<YOUR_DRIVER_VERSION>:i386
```

Replace `<YOUR_DRIVER_VERSION>` with your NVIDIA driver version. This can be
found by running a command like `glxinfo -B`, or via the NVIDIA System Managemenet Interface by running `nvidia-smi`.

### Enable a graphics card

Switch between graphics modes with the command `sudo prime-select <mode>` and reboot. 

For games to use your graphics card, `prime-select` should be set to `nvidia` or `on-demand`. 

Show your current graphics mode with the command `sudo prime-select query`. 

```{note}
Exclusively using a discrete graphics card (`nvidia` option) will use more power than normal.
```

### View GPU stats

To view programs using your GPU as well as power usage and other information, run `nvidia-smi`. 

If a game is correctly using your GPU, a listing should appear in `nvidia-smi` after it has started running.

### Configure launch options

If a game is not using your NVIDIA GPU by default, then it may be worth trying to pass NVIDIA's environment variables in as launch options for the game. For example:

```shell
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```
