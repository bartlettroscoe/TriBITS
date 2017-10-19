#
# A) Define the subpackage
#

IF(NOT PkgWithSubpkgsWithUserErrors_TURN_OFF_SUBPACKAGE_INIT)
  TRIBITS_SUBPACKAGE(A)
ENDIF()

IF(PkgWithSubpkgsWithUserErrors_DOUBLE_SUBPACKAGE_INIT)
  TRIBITS_SUBPACKAGE(A)
ENDIF()
#
# B) Set up subpackage-specific options
#
# Typically there are none or are few as most options are picked up from the
# parent package's CMakeLists.txt file!

#
# C) Add the libraries, tests, and examples
#


IF(NOT PkgWithSubpkgsWithUserErrors_TURN_OFF_LIBRARY_BEFORE_POSTPROCESS)
  INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
  TRIBITS_ADD_LIBRARY(pwswue_a
    SOURCES A.cpp
    HEADERS A.hpp
    NOINSTALLHEADERS 
  )
ENDIF()

IF(PkgWithSubpkgsWithUserErrors_TURN_ON_EXECUTABLE_BEFORE_POSTPROCESS)
  INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
  TRIBITS_ADD_EXECUTABLE(pwswue_a
    SOURCES A.cpp
    HEADERS A.hpp
    NOINSTALLHEADERS 
  )
ENDIF()

TRIBITS_ADD_TEST_DIRECTORIES(tests)

#
# D) Do standard post processing
#
TRIBITS_SUBPACKAGE_POSTPROCESS()

IF(PkgWithSubpkgsWithUserErrors_DOUBLE_SUBPACKAGE_POSTPROCESS)
  TRIBITS_SUBPACKAGE_POSTPROCESS()
ENDIF()

# Not added by defeault
IF(PkgWithSubpkgsWithUserErrors_ADD_LIBRARY_AFTER_POST_PROCESS)
  MESSAGE("Adding library in subpackage after post process")
  TRIBITS_ADD_LIBRARY(lib_after_post_process
    SOURCES A.cpp
    HEADERS A.hpp
    NOINSTALLHEADERS 
  )
ENDIF()

# Not added by defeault
IF(PkgWithSubpkgsWithUserErrors_ADD_EXECUTABLE_AFTER_POST_PROCESS)
  MESSAGE("Adding executable in subpackage after post process")
  TRIBITS_ADD_EXECUTABLE(exe_after_post_process
    SOURCES A.cpp
    HEADERS A.hpp
  )
ENDIF()
