#------------------------------------------------------------------------------#
# Top-level CMakeLists.txt
#------------------------------------------------------------------------------#

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

#------------------------------------------------------------------------------#
# Add options for METIS model selection
#------------------------------------------------------------------------------#

set(METIS_MODELS parallel serial)

if(NOT METIS_MODEL)
	list(GET METIS_MODELS 0 METIS_MODEL)
endif()

set(METIS_MODEL "${METIS_MODEL}" CACHE STRING "Select the metis model")
set_property(CACHE METIS_MODEL PROPERTY STRINGS ${METIS_MODELS})

#------------------------------------------------------------------------------#

set(ENABLE_LEGION_DEFAULT ON)
set(ENABLE_GASNET_DEFAULT ON)
set(ENABLE_METIS_DEFAULT ON)
option(USE_SYSTEM_LIBS "Check for system libraries and use them if found" OFF)
if(USE_SYSTEM_LIBS)
  if(METIS_MODEL STREQUAL "parallel")
    find_package(ParMETIS)
    if(ParMETIS_FOUND)
      set(ENABLE_METIS_DEFAULT OFF)
    endif(ParMETIS_FOUND)
  else()
    find_package(METIS 5.1)
    if(METIS_FOUND)
      set(ENABLE_METIS_DEFAULT OFF)
    endif(METIS_FOUND)
  endif()

  find_package(Legion)
  if(Legion_FOUND)
    set(ENABLE_LEGION_DEFAULT OFF)
  endif(Legion_FOUND)
  find_package(GASNet)
  if(GASNet_FOUND)
    set(ENABLE_GASNET_DEFAULT OFF)
  endif(GASNet_FOUND)
  #workaround for StanfordLegion/legion#210 on Fedora
  if(GASNet_FOUND AND DEFINED ENV{MPI_LIB})
      set(Legion_GASNet_OPTS
       -DGASNet_mpi-par_LIBRARY=$ENV{MPI_LIB}/libgasnet-mpi-par.so
       -DGASNet_gasnet_tools-par_LIBRARY=$ENV{MPI_LIB}/libgasnet_tools-par.so
      )
  endif()
endif(USE_SYSTEM_LIBS)

# third party libraries to build
option(ENABLE_METIS "Enable METIS and dependencies" ${ENABLE_METIS_DEFAULT})
cmake_dependent_option(METIS_INT64 "Build METIS with int64 support" OFF
                       "ENABLE_METIS" OFF)

option(ENABLE_LEGION "Enable LEGION and dependencies" ${ENABLE_LEGION_DEFAULT})
cmake_dependent_option(ENABLE_GASNET "Enable gasnet" ${ENABLE_GASNET_DEFAULT}
                       "ENABLE_LEGION" OFF)
#legion uses that option, too	    
set(GASNet_CONDUITS udp mpi ibv psm)
set(GASNet_CONDUIT "mpi" CACHE STRING "Select Gasnet conduit ${GASNet_CONDUITS}")
set_property(CACHE GASNet_CONDUIT PROPERTY STRINGS ${GASNet_CONDUITS})
option(LEGION_USE_OPENMP "enable OpenMP threads in Legion" OFF)

option(ENABLE_CINCH_UTILS "Enable cinch-utils and dependencies" ON)

# build the libraries
if(ENABLE_METIS)
  if(METIS_MODEL STREQUAL "parallel")
    include(cmake/parmetis.cmake)
  else(METIS_MODEL STREQUAL "serial")
    include(cmake/metis.cmake)
  endif()
endif()

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
