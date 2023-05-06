#!/bin/bash

set -eu

function configure() {
    cmake -B "$BUILD_DIR" -S "$SRC_DIR" \
	  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" \
	  -DCMAKE_INSTALL_PREFIX="$CMAKE_INSTALL_PREFIX" \
	  -DCMAKE_STAGING_PREFIX="$CMAKE_STAGING_PREFIX" \
	  \
	  -DBUILD_KRITA_QT_DESIGNER_PLUGINS="$BUILD_KRITA_QT_DESIGNER_PLUGINS" \
	  -DBUILD_TESTING="$BUILD_TESTING" \
	  -DKRITA_DEVS="$KRITA_DEVS"
}

function build() {
    cmake --build "$BUILD_DIR" --parallel "${JOBS:-$(nproc)}"
}

function package() {
    cmake --install "$BUILD_DIR"
}

configure && build && package
