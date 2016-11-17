project(ThirdParty LANGUAGES CXX C Fortran)
cmake_minimum_required(VERSION 3.1.0)
include(CMakeDependentOption)
include(ExternalProject) 

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cinch/cmake)

# installation path for third party libraries
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set (CMAKE_INSTALL_PREFIX /path/to/install/third/party CACHE PATH
  "default install path" FORCE)
endif()

option(BUILD_SHARED_LIBS "Build shared libs" ON)
if(BUILD_SHARED_LIBS)
    set(CMAKE_LIBRARY_PREFIX ${CMAKE_SHARED_LIBRARY_PREFIX})
    set(CMAKE_LIBRARY_SUFFIX ${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
    set(CMAKE_LIBRARY_PREFIX ${CMAKE_STATIC_LIBRARY_PREFIX})
    set(CMAKE_LIBRARY_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

# third party libraries to build
find_package(EXODUSII)
STRING(COMPARE EQUAL ${EXODUSII_FOUND} FALSE ENABLE_EXODUS_DEFAULT)
option(ENABLE_EXODUS "Enable Exodus and dependencies" ${ENABLE_EXODUS_DEFAULT}) 
cmake_dependent_option(ENABLE_HDF5 "Enable HDF5" ON
                       "ENABLE_EXODUS" OFF)
cmake_dependent_option(ENABLE_NETCDF "Enable HDF5" ON
                       "ENABLE_EXODUS" OFF)
cmake_dependent_option(ENABLE_SZIP "Enable szip" ON
                       "ENABLE_HDF5" OFF)

if(EXODUSII_FOUND AND ENABLE_EXODUS)
  message(FATAL_ERROR "System Exodus library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_EXODUSII=ON to force it")
endif(EXODUSII_FOUND AND ENABLE_EXODUS)

find_package(LAPACKE)
STRING(COMPARE EQUAL ${LAPACKE_FOUND} FALSE ENABLE_LAPACK_DEFAULT)
option(ENABLE_LAPACK "Enable LAPACK and dependencies" ${ENABLE_LAPACK_DEFAULT})
if(LAPACKE_FOUND AND ENABLE_LAPACK)
  message(FATAL_ERROR "System Lapacke library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_LAPACKE=ON to force it")
endif(LAPACKE_FOUND AND ENABLE_LAPACK)

find_package(METIS 5.1)
STRING(COMPARE EQUAL ${METIS_FOUND} FALSE ENABLE_METIS_DEFAULT)
option(ENABLE_METIS "Enable METIS and dependencies" ${ENABLE_METIS_DEFAULT})
if(METIS_FOUND AND ENABLE_METIS)
  message(FATAL_ERROR "System metis library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_METIS=ON to force it")
endif(METIS_FOUND AND ENABLE_METIS)
option(METIS_INT64 "Build METIS with int64 support" OFF)

find_package(SCOTCH)
STRING(COMPARE EQUAL ${SCOTCH_FOUND} FALSE ENABLE_SCOTCH_DEFAULT)
option(ENABLE_SCOTCH "Enable SCOTCH and dependencies" ${ENABLE_SCOTCH_DEFAULT})
cmake_dependent_option(ENABLE_ZLIB "Enable zlib" ON
                       "ENABLE_HDF5 OR ENABLE_SCOTCH" OFF)
if(SCOTCH_FOUND AND ENABLE_SCOTCH)
  message(FATAL_ERROR "System scotch library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_SCOTCH=ON to force it")
endif(SCOTCH_FOUND AND ENABLE_SCOTCH)

find_package(Legion)
STRING(COMPARE EQUAL ${Legion_FOUND} FALSE ENABLE_LEGION_DEFAULT)
option(ENABLE_LEGION "Enable LEGION and dependencies" ${ENABLE_LEGION_DEFAULT})
cmake_dependent_option(ENABLE_GASNET "Enable gasnet" ON
                       "ENABLE_LEGION" OFF)
if(Legion_FOUND AND ENABLE_LEGION)
  message(FATAL_ERROR "System legion library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_LEGION=ON to force it")
endif(Legion_FOUND AND ENABLE_LEGION)

option(ENABLE_CINCH_UTILS "Enable cinch-utils and dependencies" OFF)

find_package (Cereal)
STRING(COMPARE EQUAL ${Cereal_FOUND} FALSE ENABLE_CEREAL_DEFAULT)
option(ENABLE_CEREAL "Enable Cereal C++ serialization library" ${ENABLE_CEREAL_DEFAULT})
if(Cereal_FOUND AND ENABLE_CEREAL)
  message(FATAL_ERROR "System cereal library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_Cereal=ON to force it")
endif(Cereal_FOUND AND ENABLE_CEREAL)

# build the libraries
if(ENABLE_ZLIB)
  find_package(ZLIB)
  if(ZLIB_FOUND)
    message("System z library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=ON to force it")
  else()
    include(cmake/zlib.cmake)
  endif()
endif(ENABLE_ZLIB)

if(ENABLE_SZIP)
  find_package(SZIP)
  if(SZIP_FOUND)
    message("System szip library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_SZIP=ON to force it")
  else()
    include(cmake/szip.cmake)
  endif()
endif(ENABLE_SZIP)

if(ENABLE_HDF5)
  find_package(HDF5)
  if(HDF5_FOUND)
    message("System hdf5 library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_HDF5=ON to force it")
  else()
    include(cmake/hdf5.cmake)
  endif()
endif(ENABLE_HDF5)

if(ENABLE_NETCDF)
  find_package(NetCDF)
  if(NetCDF_FOUND)
    message("System netcdf library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_NetCDF=ON to force it")
  else()
    include(cmake/netcdf.cmake)
  endif()
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
  set(GASNet_CONDUIT "mpi" CACHE STRING "Select Gasnet conduit [udp, mpi]")
  find_package(GASNet)
  if(GASNet_FOUND)
    message("System GASNet library found, no point in building it! (use -DCMAKE_DISABLE_FIND_PACKAGE_GASNet=ON to force it")
    #workaround for StanfordLegion/legion#210 on Fedora
    if(DEFINED ENV{MPI_LIB})
      set(Legion_GASNet_OPTS
       -DGASNet_mpi-par_LIBRARY=$ENV{MPI_LIB}/libgasnet-mpi-par.so
       -DGASNet_gasnet_tools-par_LIBRARY=$ENV{MPI_LIB}/libgasnet_tools-par.so
      )
    endif()
  else()
    set(Legion_GASNet_OPTS -DGASNet_ROOT_DIR=${CMAKE_INSTALL_PREFIX})
    include(cmake/gasnet.cmake)
  endif()
endif(ENABLE_GASNET)

if(ENABLE_LEGION)
  include(cmake/legion.cmake)
endif(ENABLE_LEGION)

if(ENABLE_CINCH_UTILS)
  include(cmake/cinch-utils.cmake)
endif(ENABLE_CINCH_UTILS)

if(ENABLE_CEREAL)
  include(cmake/cereal.cmake)
endif(ENABLE_CEREAL)

