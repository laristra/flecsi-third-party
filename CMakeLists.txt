project(ThirdParty LANGUAGES CXX C Fortran)
cmake_minimum_required(VERSION 3.1.0)
include(CMakeDependentOption)
include(ExternalProject) 

# installation path for third party libraries
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set (CMAKE_INSTALL_PREFIX /path/to/install/third/party CACHE PATH
  "default install path" FORCE)
endif()

# third party libraries to build
option(ENABLE_EXODUS "Enable Exodus and dependencies" OFF)
cmake_dependent_option(ENABLE_HDF5 "Enable HDF5" ON
                       "ENABLE_EXODUS" OFF)
cmake_dependent_option(ENABLE_NETCDF "Enable HDF5" ON
                       "ENABLE_EXODUS" OFF)
cmake_dependent_option(ENABLE_SZIP "Enable szip" ON
                       "ENABLE_HDF5" OFF)
cmake_dependent_option(ENABLE_ZLIB "Enable zlib" ON
                       "ENABLE_HDF5" OFF)

option(ENABLE_METIS "Enable METIS and dependencies" OFF)


# build the libraries
if(ENABLE_ZLIB)
  include(cmake/zlib.cmake)
endif(ENABLE_ZLIB)

if(ENABLE_SZIP)
  include(cmake/szip.cmake)
endif(ENABLE_SZIP)

if(ENABLE_HDF5)
  include(cmake/hdf5.cmake)
endif(ENABLE_HDF5)

if(ENABLE_NETCDF)
  include(cmake/netcdf.cmake)
endif(ENABLE_NETCDF)

if(ENABLE_EXODUS)
  include(cmake/exodus.cmake)
endif(ENABLE_EXODUS)

if(ENABLE_METIS)
  include(cmake/metis.cmake)
endif()
