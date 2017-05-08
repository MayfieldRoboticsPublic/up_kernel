#!/usr/bin/env sh

set -eu

# Build a Docker image that compiles and packages the kernel
DOCKER_IMAGE="up-kernel-build"
DOCKER_ARTIFACTS="/root/artifacts"

docker build \
  --build-arg ARTIFACTS_DIR=${DOCKER_ARTIFACTS} \
  --tag ${DOCKER_IMAGE} \
  .

# Extract the Debian packages from the Docker image
DOCKER_CONTAINER="up-kernel-artifacts"
LOCAL_ARTIFACTS=$(basename ${DOCKER_ARTIFACTS})

mkdir -p ${LOCAL_ARTIFACTS}
rm -f ${LOCAL_ARTIFACTS}/*.deb

docker create --name ${DOCKER_CONTAINER} ${DOCKER_IMAGE}
docker cp "${DOCKER_CONTAINER}:${DOCKER_ARTIFACTS}" "./"
docker stop ${DOCKER_CONTAINER} && docker rm ${DOCKER_CONTAINER}

# Inspect the Debian packages
dpkg-deb --info ${LOCAL_ARTIFACTS}/*.deb
dpkg-deb --contents ${LOCAL_ARTIFACTS}/*.deb
