set(BOOST_NAME boost)

if ( CMAKE_C_COMPILER_ID STREQUAL "GNU" )
  set(BOOST_TOOLSET "gcc")
elseif ( CMAKE_C_COMPILER_ID STREQUAL "Intel" )
  set(BOOST_TOOLSET "intel-linux")
else()
  MESSAGE(FATAL_ERROR
    "Unknown boost toolset for compiler ${CMAKE_C_COMPILER_ID}")
endif()

message(STATUS "Building ${BOOST_NAME}")
ExternalProject_Add(${BOOST_NAME}
  SOURCE_DIR ${PROJECT_SOURCE_DIR}/boost
  PREFIX ${BOOST_NAME}
  INSTALL_DIR ${BOOST_NAME}/install
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND ./bootstrap.sh --with-toolset=${BOOST_TOOLSET}
  BUILD_COMMAND ./b2 install --prefix=<INSTALL_DIR>
  INSTALL_COMMAND ""
  BUILD_IN_SOURCE 1
  LOG_BUILD 1
)
ExternalProject_get_property(${BOOST_NAME} INSTALL_DIR)
ExternalProject_Get_Property(${BOOST_NAME} source_dir)

set(BOOST_ROOT ${INSTALL_DIR})

install(DIRECTORY ${INSTALL_DIR}/ DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)
