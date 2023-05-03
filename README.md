# Gentoo Toolbox

Gentoo toolbox that can be used with [Toolbox](https://github.com/containers/toolbox).

## Usage

From a system that has `toolbox` installed, run:

```bash
$ podman build . -t gentoo-toolbox
$ toolbox create -i localhost/gentoo-toolbox:latest -c gentoo-toolbox
$ toolbox enter -c gentoo-toolbox

# You should see this but with your username:
# [esi@toolbox ~]$
```

This package is based on [Archlinux-Toolbox](https://github.com/palazzem/archlinux-toolbox).
