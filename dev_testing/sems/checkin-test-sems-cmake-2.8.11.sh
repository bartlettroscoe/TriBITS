#!/bin/bash -e

# Make sure the right env is loaded!
export TRILINOS_SEMS_DEV_ENV_VERBOSE=1
source $TRILINOS_BASE_DIR_ABS/cmake/load_sems_dev_env.sh default default sems-cmake/2.8.11

echo "
-DTPL_ENABLE_MPI:BOOL=ON',
-DCMAKE_BUILD_TYPE:STRING=DEBUG',
-DTriBITS_ENABLE_DEBUG:BOOL=ON',
-DTriBITS_ENABLE_Fortran:BOOL=ON',
" > MPI_DEBUG_CMAKE-2.8.11.config

echo "
-DTPL_ENABLE_MPI:BOOL=OFF
-DCMAKE_BUILD_TYPE:STRING=RELEASE
-DTriBITS_ENABLE_DEBUG:BOOL=OFF
-DCMAKE_C_COMPILER=gcc
-DCMAKE_CXX_COMPILER=g++
-DCMAKE_Fortran_COMPILER=gfortran
" > SERIAL_RELEASE_CMAKE-2.8.11.config

$TRIBITS_BASE_DIR_ABS/checkin-test.py \
--default-builds= \
--st-extra-builds=MPI_DEBUG_CMAKE-2.8.11,SERIAL_RELEASE_CMAKE-2.8.11 \
"$@"
