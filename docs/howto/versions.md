---
myst:
  html_meta:
    "description lang=en":
      "Checking the version of the Steam snap and updating the snap."
---

(howto::versions)=
# Checking Steam snap versions and updating the snap

## Checking the version

You can check the version of the steam snap and snapd.

### Steam snap revision

```shell
snap info steam
```
Your revision is the number at the end by `installed:` in parenthesis. 

For example: 

```
installed:          1.0.0.74            (39) 371MB -
```

This means 39 is the revision.

### snapd revision

```shell
snap info snapd
```

Your revision is the number at the end by `installed:` in parenthesis.

## Update the Steam snap

<!-- TODO: these two sentences are confusing -->
Steam will update itself like it normally does.

If the Steam snap is updated, the snap will be updated automatically. 

You can force an update immediately by running `snap refresh steam`.

<!-- TODO: how do you go back a version or stay on one version? -->

