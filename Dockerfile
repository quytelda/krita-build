FROM docker.io/library/archlinux:base-devel

# Create build user/group
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
	      fftw \
	      giflib \
	      gsl \
	      hicolor-icon-theme \
	      kcompletion \
	      kcrash \
	      kdoctools \
	      kguiaddons \
	      ki18n \
	      kitemmodels \
	      kitemviews \
	      kseexpr \
	      libheif \
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
	      vc \
    && pacman -Scc --noconfirm

# Build Script
COPY build.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/build.sh"]

USER 1000:1000
WORKDIR /krita

# Build Environment
ENV SRC_DIR=/krita/src
ENV BUILD_DIR=/krita/build
ENV STAGING_DIR=/krita/install
ENV INSTALL_DIR=/usr/local

# Build Settings
ENV BUILD_TESTING=OFF
ENV BUILD_KRITA_QT_DESIGNER_PLUGINS=ON
ENV CMAKE_BUILD_TYPE=Release

# Compiler/Linker flags
ENV CFLAGS="-march=native -mtune=native -O2 -pipe -fno-plt -fexceptions \
            -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security \
            -fstack-clash-protection -fcf-protection"
ENV CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
ENV LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"

VOLUME /krita/src
VOLUME /krita/build
VOLUME /krita/install
