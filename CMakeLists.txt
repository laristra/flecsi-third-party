project(ThirdParty LANGUAGES CXX C Fortran)
cmake_minimum_required(VERSION 3.1.0)
include(CMakeDependentOption)
include(ExternalProject) 

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cinch/cmake)

option(BUILD_SHARED_LIBS "Build shared libs" ON)
if(BUILD_SHARED_LIBS)
    set(CMAKE_LIBRARY_PREFIX ${CMAKE_SHARED_LIBRARY_PREFIX})
    set(CMAKE_LIBRARY_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
    set(CMAKE_LIBRARY_PREFIX ${CMAKE_STATIC_LIBRARY_PREFIX})
    set(CMAKE_LIBRARY_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

option(USE_SYSTEM_LIBS "Check for system libraries and use them if found" OFF)
if(USE_SYSTEM_LIBS)
  find_package(EXODUSII)
  string(COMPARE EQUAL ${EXODUSII_FOUND} FALSE ENABLE_EXODUS_DEFAULT)
  find_package(LAPACKE)
  string(COMPARE EQUAL ${LAPACKE_FOUND} FALSE ENABLE_LAPACK_DEFAULT)
  find_package(METIS 5.1)
  string(COMPARE EQUAL ${METIS_FOUND} FALSE ENABLE_METIS_DEFAULT)
  find_package(SCOTCH)
  string(COMPARE EQUAL ${SCOTCH_FOUND} FALSE ENABLE_SCOTCH_DEFAULT)
  find_package(Legion)
  string(COMPARE EQUAL ${Legion_FOUND} FALSE ENABLE_LEGION_DEFAULT)
  find_package (Cereal)
  string(COMPARE EQUAL ${Cereal_FOUND} FALSE ENABLE_CEREAL_DEFAULT)
  find_package(ZLIB)
  string(COMPARE EQUAL ${ZLIB_FOUND} FALSE ENABLE_ZLIB_DEFAULT)
  find_package(SZIP)
  string(COMPARE EQUAL ${SZIP_FOUND} FALSE ENABLE_SZIP_DEFAULT)
  find_package(HDF5)
  string(COMPARE EQUAL ${HDF5_FOUND} FALSE ENABLE_HDF5_DEFAULT)
  find_package(NetCDF)
  string(COMPARE EQUAL ${NetCDF_FOUND} FALSE ENABLE_NETCF_DEFAULT)
  find_package(GASNet)
  string(COMPARE EQUAL ${GASNet_FOUND} FALSE ENABLE_GASNET_DEFAULT)
  #workaround for StanfordLegion/legion#210 on Fedora
  if(GASNet_FOUND AND DEFINED ENV{MPI_LIB})
      set(Legion_GASNet_OPTS
       -DGASNet_mpi-par_LIBRARY=$ENV{MPI_LIB}/libgasnet-mpi-par.so
       -DGASNet_gasnet_tools-par_LIBRARY=$ENV{MPI_LIB}/libgasnet_tools-par.so
      )
  endif()
else(USE_SYSTEM_LIBS)
  set(ENABLE_EXODUS_DEFAULT ON)
  set(ENABLE_LAPACK_DEFAULT ON)
  set(ENABLE_METIS_DEFAULT ON)
  set(ENABLE_SCOTCH_DEFAULT ON)
  set(ENABLE_LEGION_DEFAULT ON)
  set(ENABLE_CEREAL_DEFAULT ON)
  set(ENABLE_ZLIB_DEFAULT ON)
  set(ENABLE_SZIP_DEFAULT ON)
  set(ENABLE_HDF5_DEFAULT ON)
  set(ENABLE_NETCF_DEFAULT ON)
  set(ENABLE_GASNET_DEFAULT ON)
endif(USE_SYSTEM_LIBS)

# third party libraries to build
option(ENABLE_EXODUS "Enable Exodus and dependencies" ${ENABLE_EXODUS_DEFAULT}) 
cmake_dependent_option(ENABLE_HDF5 "Enable HDF5" ${ENABLE_HDF5_DEFAULT}
                       "ENABLE_EXODUS" OFF)
cmake_dependent_option(ENABLE_NETCDF "Enable HDF5" ${ENABLE_NETCF_DEFAULT}
                       "ENABLE_EXODUS" OFF)
cmake_dependent_option(ENABLE_SZIP "Enable szip" ${ENABLE_SZIP_DEFAULT}
                       "ENABLE_HDF5" OFF)

option(ENABLE_LAPACK "Enable LAPACK and dependencies" ${ENABLE_LAPACK_DEFAULT})

option(ENABLE_METIS "Enable METIS and dependencies" ${ENABLE_METIS_DEFAULT})
option(METIS_INT64 "Build METIS with int64 support" OFF)

option(ENABLE_SCOTCH "Enable SCOTCH and dependencies" ${ENABLE_SCOTCH_DEFAULT})
cmake_dependent_option(ENABLE_ZLIB "Enable zlib" ${ENABLE_ZLIB_DEFAULT}
                       "ENABLE_HDF5 OR ENABLE_SCOTCH" OFF)

option(ENABLE_LEGION "Enable LEGION and dependencies" ${ENABLE_LEGION_DEFAULT})
cmake_dependent_option(ENABLE_GASNET "Enable gasnet" ${ENABLE_GASNET_DEFAULT}
                       "ENABLE_LEGION" OFF)
#legion uses that option, too	    
set(GASNet_CONDUIT "mpi" CACHE STRING "Select Gasnet conduit [udp, mpi]")

option(ENABLE_CINCH_UTILS "Enable cinch-utils and dependencies" ON)

option(ENABLE_CEREAL "Enable Cereal C++ serialization library" ${ENABLE_CEREAL_DEFAULT})

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

if(ENABLE_LAPACK)
  include(cmake/lapack.cmake)
endif(ENABLE_LAPACK)

if(ENABLE_METIS)
  include(cmake/metis.cmake)
endif()

if(ENABLE_SCOTCH)
  include(cmake/scotch.cmake)
endif()

if(ENABLE_LAPACK)
  install(SCRIPT scripts/lapack_post_install.cmake)
endif(ENABLE_LAPACK)

if(ENABLE_GASNET)
  include(cmake/gasnet.cmake)
endif(ENABLE_GASNET)

if(ENABLE_LEGION)
  if(ENABLE_GASNET)
    set(Legion_GASNet_OPTS -DGASNet_ROOT_DIR=${CMAKE_INSTALL_PREFIX})
  endif()
  include(cmake/legion.cmake)
endif(ENABLE_LEGION)

if(ENABLE_CINCH_UTILS)
  include(cmake/cinch-utils.cmake)
endif(ENABLE_CINCH_UTILS)

if(ENABLE_CEREAL)
  include(cmake/cereal.cmake)
endif(ENABLE_CEREAL)

