TRIBITS_SUBPACKAGE(C)

TRIBITS_ADD_EXECUTABLE( c_util
  NOEXEPREFIX  NOEXESUFFIX
  SOURCES  c_util.cpp
  )

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/ShowLibErrors.cmake)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
TRIBITS_ADD_LIBRARY(pws_c
  SOURCES C.cpp
  HEADERS wsp_c/C.hpp
  HEADERS_INSTALL_SUBDIR  wsp_c 
  ${TAL_EXTRALIB_ARGS} # Used to show warnings and errors
  )

TRIBITS_ADD_TEST_DIRECTORIES(tests)

INSTALL( DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/stuff"
  DESTINATION "${CMAKE_INSTALL_PREFIX}/share/${PACKAGE_NAME}"
  USE_SOURCE_PERMISSIONS PATTERN "*~" EXCLUDE )
# Above, we must use 'USE_SOURCE_PERMISSIONS' to preserve the executable
# permission on the scripts in that directory.  (TriBITS will add commands to
# fix the permissions after the install.)

TRIBITS_SUBPACKAGE_POSTPROCESS()
