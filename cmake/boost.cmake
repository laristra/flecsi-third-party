set(BOOST_NAME boost)

set( BOOST_ARGS )

if ( CMAKE_C_COMPILER_ID STREQUAL "GNU" )
  list(APPEND BOOST_ARGS "--with-toolset=gcc")
elseif ( CMAKE_C_COMPILER_ID STREQUAL "Intel" )
  list(APPEND BOOST_ARGS "--with-toolset=intel-linux")
else()
  MESSAGE(FATAL_ERROR
    "Unknown boost toolset for compiler ${CMAKE_C_COMPILER_ID}")
endif()

if (BUILD_SHARED_LIBS)
  list( APPEND BOOST_ARGS "link=shared" )
else()
  list( APPEND BOOST_ARGS "link=static" )
endif()

if ( USE_INSTALL_TARGET )
  set( _install_dir ${BOOST_NAME}/install )
else()
  set( _install_dir ${CMAKE_INSTALL_PREFIX} )
endif()

message(STATUS "Building ${BOOST_NAME}")
ExternalProject_Add(${BOOST_NAME}
  SOURCE_DIR ${PROJECT_SOURCE_DIR}/boost
  PREFIX ${BOOST_NAME}
  INSTALL_DIR ${_install_dir}
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND ./bootstrap.sh ${BOOST_ARGS}
  BUILD_COMMAND ./b2 install --prefix=<INSTALL_DIR>
  INSTALL_COMMAND ""
  BUILD_IN_SOURCE 1
  LOG_BUILD 1
)
ExternalProject_get_property(${BOOST_NAME} INSTALL_DIR)
ExternalProject_Get_Property(${BOOST_NAME} source_dir)

set(BOOST_ROOT ${INSTALL_DIR})

if ( USE_INSTALL_TARGET )
  install(DIRECTORY ${INSTALL_DIR}/ DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)
endif()
