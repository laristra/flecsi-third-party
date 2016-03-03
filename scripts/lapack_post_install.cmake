#------------------------------------------------------------------------------#
# Fix lapacke installation to match linux distribution style installs.
#------------------------------------------------------------------------------#

set(CMAKE_INSTALL_PREFIX ${CMAKE_ARGV3})

MESSAGE(STATUS "install prefix: ${CMAKE_INSTALL_PREFIX}")

if(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/include/lapacke)
  file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include/lapacke)
endif(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/include/lapacke)

if(NOT MINGW AND NOT MSVC)
  execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CMAKE_INSTALL_PREFIX}/include/lapacke_config.h
    ${CMAKE_INSTALL_PREFIX}/include/lapacke/lapacke_config.h)

  execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CMAKE_INSTALL_PREFIX}/include/lapacke.h
    ${CMAKE_INSTALL_PREFIX}/include/lapacke/lapacke.h)

  execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CMAKE_INSTALL_PREFIX}/include/lapacke_mangling.h
    ${CMAKE_INSTALL_PREFIX}/include/lapacke/lapack_mangling.h)

  execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
    ${CMAKE_INSTALL_PREFIX}/include/lapacke_utils.h
    ${CMAKE_INSTALL_PREFIX}/include/lapacke/lapacke_utils.h)
endif(NOT MINGW)
