---
myst:
  html_meta:
    "description lang=en":
      "Checking the version of the Steam snap and updating the snap."
---

(howto::update-version)=
# Update the Steam snap version

<!-- TODO: Commenting this out for now because it is confusing.
           We should briefly clarify how upstream Steam updates and Steam snap updates relate to each other, 
           and what users should expect.

Steam will update itself like it normally does. -->

When a new version of the Steam snap is released, your snap will be updated automatically. 

You can force an update immediately by running the command

```shell
snap refresh steam
```

<!-- TODO: how do you go back a version or stay on one version? -->

## Check Steam snap and `snapd` versions

Check your current version of the Steam snap with the command

```shell
snap info steam
```

Your revision is the number at the end by `installed:` in parenthesis. 

For example: 

```text
installed:          1.0.0.74            (39) 371MB -
```

This means `39` is the revision.

Check your current version of `snapd` with the command

```shell
snap info snapd
```

Your revision is the number at the end by `installed:` in parenthesis.



