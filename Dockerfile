FROM mayfieldrobotics/ubuntu:14.04

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm"

ARG ARTIFACTS_DIR

COPY . .

RUN apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    ca-certificates \
    curl \
    fakeroot \
    libfile-fcntllock-perl

RUN ./build.sh

RUN mkdir -p ${ARTIFACTS_DIR} \
  && mv work/*.deb ${ARTIFACTS_DIR}
