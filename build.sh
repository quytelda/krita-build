#!/bin/bash

set -eu

export CFLAGS="-march=native -mtune=native -O2 -pipe -fno-plt -fexceptions \
       	       -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
               -fstack-clash-protection -fcf-protection"
export CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"

function configure() {
    cmake -B "$BUILD_DIR" -S "$SRC_DIR" \
	  -DCMAKE_INSTALL_PREFIX="$RUNTIME_PREFIX" \
	  -DCMAKE_STAGING_PREFIX="$INSTALL_DIR" \
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
