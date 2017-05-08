#!/bin/bash
###
## bashscript to build custom kernel for ubilinux that works on ubuntu
### AUTHOR: Vinay Malkani
## Copyright 2016 Mayfield Robotics

set -eu

KERNEL_VERSION=4.4.13
MINOR_VERSION=1
BASE_HOST=http://ubilinux.org
BASE_URL=ubilinux/pool/main/l/linux-ubilinux
KERNEL_FILE=linux-ubilinux_${KERNEL_VERSION}.orig.tar.xz
DSC_FILE=linux-ubilinux_${KERNEL_VERSION}-${MINOR_VERSION}.dsc
PATCH_FILE=linux-ubilinux_${KERNEL_VERSION}-${MINOR_VERSION}.debian.tar.xz
CONFIG_FILE=config-mayfield-${KERNEL_VERSION}
KPKG_PACKAGE_URL=https://launchpad.net/ubuntu/+source/kernel-package/13.003/+build/5980712/+files/kernel-package_13.003_all.deb
KPKG_PACKAGE=${KPKG_PACKAGE_URL##*/}

# change that last number by the revision number
DEB_REVISION=$KERNEL_VERSION-$MINOR_VERSION+may1


mkdir -p work
pushd work

# pull files
curl -LO $BASE_HOST/$BASE_URL/$KERNEL_FILE
curl -LO $BASE_HOST/$BASE_URL/$DSC_FILE
curl -LO $BASE_HOST/$BASE_URL/$PATCH_FILE
curl -LO "${KPKG_PACKAGE_URL}"

# is the upgrade really necessary?
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y build-dep linux-image-"$(uname -r)"
sudo dpkg -i ${KPKG_PACKAGE}


dpkg-source -x ${DSC_FILE}
cp -v ../${CONFIG_FILE} linux-ubilinux-${KERNEL_VERSION}/.config
cd linux-ubilinux-${KERNEL_VERSION}
cat ../../patches/*.patch | patch -p1
fakeroot make-kpkg -j 3 --initrd --append-to-version="-mayfield" --revision="$DEB_REVISION" kernel-image kernel-headers
popd
