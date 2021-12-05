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
	      libraw \
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
ENV INSTALL_DIR=/krita/install
ENV RUNTIME_PREFIX="/usr/local"

VOLUME /krita/src
VOLUME /krita/build
VOLUME /krita/install
