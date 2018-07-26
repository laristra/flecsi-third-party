# Third-Party

This project provides an easy way to build and install many third party
libraries.

## Installation

HDF5 requires CMake >= 3.1.0

% module load cmake

% module load git/2.11.0

% module load gcc/5.3.0

% module load openmpi/1.10.5

% git clone --recursive git@github.com:laristra/flecsi-third-party.git

% cd flecsi-third-party

% mkdir build

% cd build

% ccmake ../

Press "c" to configure. Enable libraries desired. (Press enter to change/confirm
a line, press c again, possibly a couple times, and finally g for generate.)
IMPORTANT: set the installation path for the libraries in CMAKE_INSTALL_PREFIX.

% make

"make install" does re-installation in the path you specified.

## Adding to Third-Party

1. Either add `.tar` file to `files/` or link in the source from the repo
2. Add `<your-library-name>.cmake` in `cmake/`
  - Reference `caliper.cmake` if `.tar` file is added to `files/`
  - Reference `cinch-utils.cmake` if the repo source is linked in

## Using Third-Party Container

1. `docker pull laristra/flesci-third-party:fedora`
2. `docker run -it laristra/flesci-third-party:fedora /bin/bash`
3. Download packages that are not already installed, but needed
  - Reference `flecsi-buildenv`
  - Also see https://github.com/laristra/flecsi-buildenv/blob/master/fedora and https://github.com/laristra/flecsi-buildenv/blob/master/ubuntu for recent dnf and apt-get package lists.

## Building Third-Party with `USE_SYSTEM_LIBS=ON/OFF` on Travis-CI

1. `.travis.yml`: Specify `SYSTEM_LIBS=ON` or `SYSTEM_LIBS=OFF` in the `matrix` of `env` for Travis to pass into the Docker through `--build-arg`
2. `docker/Dockerfile`: Use `ARG SYSTEM_LIBS` to assign the value passed in from Travis to `SYSTEM_LIBS` and include `-DUSE_SYSTEM_LIBS=${SYSTEM_LIBS}` in cmake command

For more information on Travis-CI and Docker setup, see [here](https://github.com/laristra/flecsi/blob/master/developer/CI.md)
