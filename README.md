# ThirdParty

This project provides an easy way to build and install many third party
libraries.

# Installation

HDF5 requires CMake >= 3.1.0

% module load cmake
% module load other/git-1.8.2.2
% module load compilers/gcc/5.2.0
% git clone git@gitlab.lanl.gov:csse/ThirdParty.git
% cd ThirdParty
% mkdir build
% cd build
% ccmake ../

Press "c" to configure. Enable libraries desired. (Press enter to change
a line, press c again, possibly a couple times, and finally g for generate.)
IMPORTANT: set the installation path for the libraries in CMAKE_INSTALL_PREFIX.

% make

"make" does the installation in the path you specified.
