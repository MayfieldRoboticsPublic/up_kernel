# UP board Linux kernel Ubuntu 14.04

This script will download and compile kernel 4.4.13 with
upboard patches for Ubuntu 14.04.

## Compilation

```bash
# Local build on a dev machine or robot
bash build.sh
```

or

```bash
# Isolated build in a Docker container
./docker_build.sh
```

## Installation


```bash
# Installation of Debian packages on a robot
sudo dpkg -i *.deb
```
