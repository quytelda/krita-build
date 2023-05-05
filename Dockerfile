FROM docker.io/library/archlinux:base-devel

# Create a user/group to run the build.
RUN groupadd --gid 1000 krita \
    && useradd --uid 1000 \
	       --gid 1000 \
	       --home-dir /krita \
	       --create-home \
	       --no-log-init \
	       krita

# Install dependancies
RUN pacman -Syu --noconfirm \
    && pacman -S --needed --noconfirm \
	      boost \
	      eigen \
	      exiv2 \
	      extra-cmake-modules \
	      ffmpeg \
	      fftw \
	      gsl \
	      hicolor-icon-theme \
	      kcompletion \
	      kcrash \
	      kdoctools \
	      kguiaddons \
	      ki18n \
	      kimageformats \
	      kitemmodels \
	      kitemviews \
	      kseexpr \
	      libheif \
	      libjxl \
	      libmypaint \
	      libraw \
	      libwebp \
	      opencolorio \
	      openexr \
	      openjpeg2 \
	      poppler-qt5 \
	      python-pyqt5 \
	      qt5-multimedia \
	      qt5-svg \
	      qt5-tools \
	      quazip \
	      sip \
	      xsimd \
    && pacman -Scc --noconfirm

# Build Script
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

USER 1000:1000
WORKDIR /krita

# Build Environment

# INSTALL_DIR must match the path where Krita will be installed on the host.
# This means the final executable should be at "$INSTALL_DIR/bin/krita".
ENV INSTALL_DIR=/usr/local

# The following variables represent paths *inside* the container.
# SRC_DIR is the path where the Krita source tree is mounted.
# BUILD_DIR is a path where the build cache may be mounted.
# STAGING_DIR is the path where CMake will install Krita after building.
ENV SRC_DIR=/krita/src
ENV BUILD_DIR=/krita/build
ENV STAGING_DIR=/krita/install

VOLUME "$SRC_DIR"
VOLUME "$BUILD_DIR"
VOLUME "$STAGING_DIR"

# Build Options
# https://docs.krita.org/en/untranslatable_pages/cmake_settings_for_developers.html
ENV BUILD_TESTING=OFF
ENV BUILD_KRITA_QT_DESIGNER_PLUGINS=ON
ENV CMAKE_BUILD_TYPE=Release
ENV KRITA_DEVS=OFF

# Compiler/Linker flags
# Taken from the default x86-64 flags in /etc/makepkg.conf
ENV CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fno-plt -fexceptions \
            -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
            -fstack-clash-protection -fcf-protection"
ENV CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
ENV LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
