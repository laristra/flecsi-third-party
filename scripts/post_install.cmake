#------------------------------------------------------------------------------#
# Fix lapacke installation to match linux distribution style installs.
#------------------------------------------------------------------------------#

if(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/include/lapacke)
	file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include/lapacke)
	execute_process(COMMAND ln -s ${CMAKE_INSTALL_PREFIX}/lapacke*.h ${CMAKE_INSTALL_PREFIX}/include/lapacke)
endif(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/include/lapacke)
