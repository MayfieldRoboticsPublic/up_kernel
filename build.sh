#!/bin/bash 
###
## bashscript to build custom kernel for ubilinux that works on ubuntu
### AUTHOR: Vinay Malkani
## Copyright 2016 Mayfield Robotics
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


#pull files
wget -N $BASE_HOST/$BASE_URL/$KERNEL_FILE
wget -N $BASE_HOST/$BASE_URL/$DSC_FILE
wget -N $BASE_HOST/$BASE_URL/$PATCH_FILE 
wget -N "${KPKG_PACKAGE_URL}"


sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y build-dep linux-image-$(uname -r)
sudo dpkg -i KPKG_PACKAGE


dpkg-source ${DSC_FILE}
cp ${CONFIG_FILE} linux-ubilinux-${KERNEL_VERSION}/.config
cd linux-ubilinux-${KERNEL_VERSION}
fakeroot make-kpkg -j 2 --initrd --append-to-version="-mayfield" kernel-image kernel-headers
