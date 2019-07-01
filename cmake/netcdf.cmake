set(NETCDF_NAME netcdf)
set(NETCDF_URL ${PROJECT_SOURCE_DIR}/files)
set(NETCDF_GZ  netcdf-4.3.3.1.tar.gz )
set(NETCDF_MD5 "5c9dad3705a3408d27f696e5b31fb88c" )

ExternalProject_get_property(${HDF5_NAME} INSTALL_DIR)
set(HDF5_INSTALL_DIR ${INSTALL_DIR})

message(STATUS "Building ${NETCDF_NAME}")
ExternalProject_Add(${NETCDF_NAME}
  DEPENDS ${HDF5_NAME}
  URL ${NETCDF_URL}/${NETCDF_GZ}
  URL_MD5 ${NETCDF_MD5}
  PREFIX ${NETCDF_NAME}
  INSTALL_DIR install
  UPDATE_COMMAND ""
  PATCH_COMMAND patch -p0 < ${PROJECT_SOURCE_DIR}/patches/netcdf.patch
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS} ${SZIP_LIBRARY}
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DENABLE_TESTS=OFF
    -DENABLE_DAP=OFF 
    -DZLIB_LIBRARY:FILEPATH=${ZLIB_LIBRARIES}
    -DSZIP_LIBRARY:FILEPATH=${SZIP_LIBRARIES}
    -DHDF5_LIB:FILEPATH=${HDF5_LIBRARIES}
    -DHDF5_HL_LIB:FILEPATH=${HDF5_HL_LIBRARIES}
    -DHDF5_INCLUDE_DIR:PATH=${HDF5_INSTALL_DIR}/include
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  DEPENDS ${HDF5_NAME}
  LOG_BUILD 1
)
ExternalProject_get_property(${NETCDF_NAME} INSTALL_DIR)

set(NETCDF_INCLUDE_DIR ${INSTALL_DIR}/include)
set(NETCDF_LIBRARIES   ${INSTALL_DIR}/lib/${CMAKE_LIBRARY_PREFIX}netcdf${CMAKE_LIBRARY_SUFFIX})

install(DIRECTORY ${INSTALL_DIR}/ DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)
