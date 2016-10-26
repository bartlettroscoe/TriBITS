#
# Set the options specific to this build case
#

SET(COMM_TYPE SERIAL)
SET(BUILD_TYPE DEBUG)
SET(BUILD_DIR_NAME ${COMM_TYPE}_${BUILD_TYPE}_TravisCI)
#SET(CTEST_TEST_TIMEOUT 900)

#override the default number of processors to run on.
SET( CTEST_BUILD_FLAGS "-j10 -i" )
SET( CTEST_PARALLEL_LEVEL "10" )

SET( EXTRA_CONFIGURE_OPTIONS
  "-DBUILD_SHARED_LIBS:BOOL=ON"
  "-DCMAKE_BUILD_TYPE=DEBUG"
  "-DCMAKE_C_COMPILER=gcc"
  "-DCMAKE_CXX_COMPILER=g++"
  "-DCMAKE_Fortran_COMPILER=gfortran"
  "-DTriBITS_ENABLE_Fortran=ON"
  "-DTriBITS_HOSTNAME=travis-ci-server-linux"
  )

SET(CTEST_TEST_TYPE Experimental)

#
# Set the locations of things
#

SET(TRIBITS_PROJECT_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../..")

SET(TriBITS_TRIBITS_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../tribits")

INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../../../tribits/ctest_driver/TribitsCTestDriverCore.cmake")

#
# Run the CTest driver and submit to CDash
#

TRIBITS_CTEST_DRIVER()
