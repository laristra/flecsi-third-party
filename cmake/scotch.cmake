set(SCOTCH_NAME scotch)
set(SCOTCH_URL ${PROJECT_SOURCE_DIR}/files)
set(SCOTCH_GZ  scotch_6.0.4.tar.gz)
set(SCOTCH_MD5 "d58b825eb95e1db77efe8c6ff42d329f")

find_program(FLEX flex)
if (NOT FLEX)
   message( FATAL_ERROR
            "'flex' lexical parser not found. Cannot build scotch." )
endif()

if (APPLE)
    set(SCOTCH_MAKE Makefile.inc.i686_mac_darwin10)
    set(SCOTCH_CFLAGS "-Drestrict=__restrict -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_TIMING_OLD -DSCOTCH_PTHREAD -DSCOTCH_RENAME -DCOMMON_PTHREAD_BARRIER -I${ZLIB_INCLUDE_DIR}")
    set(SCOTCH_LDFLAGS "-Wl,-rpath,${CMAKE_INSTALL_PREFIX}/lib ${ZLIB_LIBRARIES} -lm -lpthread")
else ()
    if (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(SCOTCH_MAKE Makefile.inc.x86-64_pc_linux2)
        set(SCOTCH_CFLAGS "-DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -Drestrict=__restrict -DIDXSIZE64 -I${ZLIB_INCLUDE_DIR}")
    else ()
        set(SCOTCH_MAKE Makefile.inc.i686_pc_linux2)
        set(SCOTCH_CFLAGS "-DCOMMON_FILE_COMPRESS_GZ -DCOMMON_PTHREAD -DCOMMON_RANDOM_FIXED_SEED -DSCOTCH_RENAME -DSCOTCH_PTHREAD -Drestrict=__restrict -I${ZLIB_INCLUDE_DIR}")
    endif ()
    set(SCOTCH_LDFLAGS "-Wl,-rpath,${CMAKE_INSTALL_PREFIX}/lib ${ZLIB_LIBRARIES} -lm -lrt -lpthread")
endif ()

ExternalProject_Add( ${SCOTCH_NAME}
 DEPENDS ${ZLIB_PACKAGE_NAME}

 URL ${SCOTCH_URL}/${SCOTCH_GZ}
 URL_MD5 ${SCOTCH_MD5}
 UPDATE_COMMAND ""

 BUILD_IN_SOURCE 1

 CONFIGURE_COMMAND rm -f src/Makefile.inc

 COMMAND ln -s Make.inc/${SCOTCH_MAKE}
               src/Makefile.inc

 BUILD_COMMAND 
   $(MAKE) -C src
     "CCS=${CMAKE_C_COMPILER}"
     "CCD=${CMAKE_C_COMPILER}"
     "CFLAGS=${CMAKE_C_FLAGS} ${SCOTCH_CFLAGS}"
     "LDFLAGS=${SCOTCH_LDFLAGS}"
     "CLIBFLAGS=-fPIC"     
     scotch
 INSTALL_COMMAND 
   $(MAKE) -C src 
     "MKDIR=mkdir -p"
     prefix=${CMAKE_INSTALL_PREFIX} 
     install
)
