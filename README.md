This repository describes a podman/docker container that can simplify
building [Krita](https://krita.org) from source.

# Usage
First, you'll need a copy of the Krita source tree. You can get this
from the Krita website: https://krita.org/en/download/krita-desktop

Also, you probably want to create a "build" directory where CMake will
store its build system and generated artifacts. Krita takes a long
time to build from scratch, but reusing the build directory speeds up
the process significantly on subsequent rebuilds.
See `cmake(1)` for more information.

Assuming your Krita sources are located in `./src`, your build
directory is `./build`, and the directory where you want Krita to be
installed after building is `./install`, the following command will
build Krita with the default options:

```
podman run -it \
       --env INSTALL_DIR="$PWD/install" \
       --mount type=bind,src="$PWD/src",dst=/krita/src \
       --mount type=bind,src="$PWD/build",dst=/krita/build \
       --mount type=bind,src="$PWD/install",dst=/krita/install \
       --userns=keep-id \
       localhost/krita-build
```
The `INSTALL_DIR` variable should contain the path where Krita will be
installed and run from. This means the final executable should end up
at "$INSTALL_DIR/bin/krita".

After the build finishes, you should be able to run Krita:

```
./install/bin/krita
```

Invoking podman by hand is a bit of work, so there's also a `run.sh`
script to make this easier.
