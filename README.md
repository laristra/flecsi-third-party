# third-party

This project provides an easy way to build and install many third party
libraries.

# Installation

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

Press "c" to configure. Enable libraries desired. (Press enter to change
a line, press c again, possibly a couple times, and finally g for generate.)
IMPORTANT: set the installation path for the libraries in CMAKE_INSTALL_PREFIX.

% make

"make install" does re-installation in the path you specified.

# Adding to third-party

1. Either add tar file to `files/` or link in the source from the repo
2. Add `<your-library-name>.cmake` in `cmake/`
  - Reference `caliper.cmake` if tar file is added to `files/`
  - Reference `cinch-utils.cmake` if the repo source is linked in
