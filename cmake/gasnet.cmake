set(GASNET_NAME gasnet)
set(GASNET_URL ${PROJECT_SOURCE_DIR}/files)
set(GASNET_GZ  GASNet-1.26.4.tar)
set(GASNET_MD5 "ff204fe3df02a92d485371240999d395")

if(GASNet_CONDUIT STREQUAL "udp")
   set(CONF_OPTS --enable-udp --disable-mpi)
elseif(GASNet_CONDUIT STREQUAL "mpi")
   set(CONF_OPTS --enable-mpi --disable-udp)
else() 
  message (ERROR "wrong Gasnet conduit specified")
endif ()
 
ExternalProject_Add(${GASNET_NAME}
 URL ${GASNET_URL}/${GASNET_GZ}
 URL_MD5 ${GASNET_MD5}
 CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}  ${CONF_OPTS} --disable-ibv --enable-par --enable-mpi-compat  "CC=${CMAKE_C_COMPILER} -fPIC" "CXX=${CMAKE_CXX_COMPILER} -fPIC" "MPI_CC=mpicc -fPIC"
 LOG_BUILD 1
)
