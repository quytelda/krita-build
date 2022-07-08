#!/bin/bash

set -eux

KRITA_SRC=$HOME/projects/krita
KRITA_BUILD=$PWD/build
KRITA_INSTALL=$PWD/install

mkdir -p "$KRITA_BUILD" "$KRITA_INSTALL"

podman run -it \
       --name=krita \
       --userns=keep-id \
       \
       --mount type=bind,relabel=private,src="$KRITA_SRC",dst=/krita/src \
       --mount type=bind,relabel=private,src="$KRITA_BUILD",dst=/krita/build \
       --mount type=bind,relabel=private,src="$KRITA_INSTALL",dst=/krita/install \
       \
       --env INSTALL_DIR="$KRITA_INSTALL" \
       \
       localhost/krita-build:f35
