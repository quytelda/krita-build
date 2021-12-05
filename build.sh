#!/bin/bash

set -eu

function configure() {
    cmake -B "$BUILD_DIR" -S "$SRC_DIR" \
	  -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
	  -DCMAKE_STAGING_PREFIX="$STAGING_DIR" \
	  -DBUILD_TESTING=OFF \
	  -DBUILD_KRITA_QT_DESIGNER_PLUGINS=ON \
	  -DCMAKE_BUILD_TYPE=Release
}

function build() {
    cmake --build "$BUILD_DIR" --parallel "$(nproc)"
}

function package() {
    cmake --install "$BUILD_DIR"
}

configure && build && package
