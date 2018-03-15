# flecsi-third-party: FleCSPH branch

Third-party libraries for FleCSI compatible with the [flecsph](https://github.com/laristra/flecsph) project.

# Installation

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

"make" does the installation in the path you specified.
