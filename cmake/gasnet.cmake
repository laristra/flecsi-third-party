set(GASNET_NAME gasnet)
set(GASNET_URL ${PROJECT_SOURCE_DIR}/files)
set(GASNET_GZ  GASNet-1.26.4.tar)
set(GASNET_MD5 "ff204fe3df02a92d485371240999d395")

ExternalProject_Add(${GASNET_NAME}
 URL ${GASNET_URL}/${GASNET_GZ}
 URL_MD5 ${GASNET_MD5}
 CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-par --disable-aligned-segments  --enable-mpi-compat --enable-segment-fast --disable-aligned-segments --disable-pshm --with-segment-mmap-max=4GB CFLAGS=-g
)
