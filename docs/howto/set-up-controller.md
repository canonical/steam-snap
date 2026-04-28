---
myst:
  html_meta:
    "description lang=en":
      "Use controllers with the Steam snap on Ubuntu."
---

(howto::set-up-controller)=
# Set up a controller

In Steam, enter Big Picture Mode by clicking the computer icon next to the close and minimize buttons. 
<!--TODO: is big picture mode necessary? why not just go straight to Settings > Controller?-->

Navigate to {guilabel}`Settings` > {guilabel}`Controller`.

You should be able to see your controller appear in the list and enable configurations 
for your controller type.

![Controller menu in Steam.](../assets/controller.png) 

## Troubleshooting

Try the following steps if your controller does not connect or you cannot enable the configurations.

### Connect plugs

Make sure the following plugs are connected using the following commands:

- **joystick**: `snap connect steam:joystick`
- **hardware-observe**: `snap connect steam:hardware-observe`
- **uinput**: `snap connect steam:uinput`

It is likely that they will already be connected automatically.

<!--TODO: if they're not, how would one connect them? -->

### Install `steam-devices`

You may also need to install the `steam-devices` deb package on your host
system:
<!--TODO: brief context-->

```shell
sudo apt install --no-install-recommends steam-devices.
```


