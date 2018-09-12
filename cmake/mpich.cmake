set(MPICH_NAME mpich)
set(MPICH_URL ${PROJECT_SOURCE_DIR}/files)
set(MPICH_TGZ mpich-3.2.1.tar.gz)
set(MPICH_MD5 "e175452f4d61646a52c73031683fc375")

set( MPICH_ARGS )

if (BUILD_SHARED_LIBS)
  list( APPEND MPICH_ARGS "--enable-shared=yes" )
else()
  list( APPEND MPICH_ARGS "--enable-shared=no" )
endif()

if ( USE_INSTALL_TARGET )
  set( _install_dir ${MPICH_NAME}/install )
else()
  set( _install_dir ${CMAKE_INSTALL_PREFIX} )
endif()

message(STATUS "Building ${MPICH_NAME}")
ExternalProject_Add(${MPICH_NAME}
  URL ${MPICH_URL}/${MPICH_TGZ}
  URL_MD5 ${MPICH_MD5}
  PREFIX ${MPICH_NAME}
  INSTALL_DIR ${_install_dir}
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND 
    FC=${CMAKE_Fortran_COMPILER}
    FCFLAGS=${CMAKE_F_FLAGS}
    CC=${CMAKE_C_COMPILER}
    CCFLAGS=${CMAKE_C_FLAGS}
    CXX=${CMAKE_CXX_COMPILER}
    CXXFLAGS=${CMAKE_CXX_FLAGS}
    ./configure --prefix=<INSTALL_DIR> ${MPICH_ARGS}
  BUILD_COMMAND make
  INSTALL_COMMAND make install
  BUILD_IN_SOURCE 1
  LOG_BUILD 1
)
ExternalProject_get_property(${MPICH_NAME} INSTALL_DIR)
ExternalProject_Get_Property(${MPICH_NAME} source_dir)

set(MPICH_ROOT ${INSTALL_DIR})
set(MPICH_INCLUDE_DIR ${MPICH_ROOT}/include)
set(MPICH_LIBRARY_DIR ${MPICH_ROOT}/lib)
set(MPI_C_COMPILER ${INSTALL_DIR}/bin/mpicc)
set(MPI_CXX_COMPILER ${INSTALL_DIR}/bin/mpicxx)

if ( USE_INSTALL_TARGET )
  install(DIRECTORY ${INSTALL_DIR}/ DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)
endif()
