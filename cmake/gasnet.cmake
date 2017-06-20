set(GASNET_NAME gasnet)
set(GASNET_URL ${PROJECT_SOURCE_DIR}/files)
set(GASNET_GZ  GASNet-1.26.4.tar)
set(GASNET_MD5 "ff204fe3df02a92d485371240999d395")

if(GASNet_CONDUIT STREQUAL "udp")
   set(CONF_OPTS --enable-udp --disable-mpi --disable-ibv)
elseif(GASNet_CONDUIT STREQUAL "mpi")
   set(CONF_OPTS --enable-mpi --disable-udp --disable-ibv)
elseif(GASNet_CONDUIT STREQUAL "ibv")
   set(CONF_OPTS --disable-mpi --disable-udp --enable-ibv)
else() 
  message (ERROR "wrong Gasnet conduit specified")
endif ()

find_package(MPI REQUIRED)
 
message(STATUS "Building ${GASNET_NAME}")
ExternalProject_Add(${GASNET_NAME}
 URL ${GASNET_URL}/${GASNET_GZ}
 URL_MD5 ${GASNET_MD5}
 CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}  ${CONF_OPTS}  --enable-par --enable-mpi-compat  "CC=${CMAKE_C_COMPILER} -fPIC" "CXX=${CMAKE_CXX_COMPILER} -fPIC" "MPI_CC=${MPI_C_COMPILER} -fPIC"
 LOG_BUILD 1
)
