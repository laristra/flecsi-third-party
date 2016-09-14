set(GASNET_NAME gasnet)
set(GASNET_URL ${PROJECT_SOURCE_DIR}/files)
set(GASNET_GZ  GASNet-1.26.4.tar)
set(GASNET_MD5 "ff204fe3df02a92d485371240999d395")

if(GASNet_CONDUIT STREQUAL "udp")

ExternalProject_Add(${GASNET_NAME}
 URL ${GASNET_URL}/${GASNET_GZ}
 URL_MD5 ${GASNET_MD5}
 CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}  --disable-ibv --enable-udp --enable-par --disable-aligned-segments  --enable-mpi-compat --enable-segment-fast --disable-aligned-segments --disable-pshm --with-segment-mmap-max=4GB --disable-mpi  "CC=${CMAKE_C_COMPILER} -fPIC" "CXX=${CMAKE_CXX_COMPILER} -fPIC" "MPI_CC=mpicc -fPIC"
)

elseif (GASNet_CONDUIT STREQUAL "ibv")

ExternalProject_Add(${GASNET_NAME}
 URL ${GASNET_URL}/${GASNET_GZ}
 URL_MD5 ${GASNET_MD5}
 CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}  --disable-udp --enable-ibv --enable-par --disable-aligned-segments  --enable-mpi-compat --enable-segment-fast --disable-aligned-segments --disable-pshm --with-segment-mmap-max=4GB --disable-mpi "CC=${CMAKE_C_COMPILER} -fPIC" "CXX=${CMAKE_CXX_COMPILER} -fPIC" "MPI_CC=mpicc -fPIC"
)

elseif (GASNet_CONDUIT STREQUAL "mpi")

ExternalProject_Add(${GASNET_NAME}
 URL ${GASNET_URL}/${GASNET_GZ}
 URL_MD5 ${GASNET_MD5}
 
 CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX}  --enable-mpi --disable-udp --enable-par --disable-aligned-segments  --enable-mpi-compat --enable-segment-fast --disable-aligned-segments --disable-pshm --with-segment-mmap-max=4GB "CC=${CMAKE_C_COMPILER} -fPIC" "CXX=${CMAKE_CXX_COMPILER} -fPIC" "MPI_CC=mpicc -fPIC"  
)
  
else() 
  message (ERROR "wrong Gasnet conduit specified")
endif ()
