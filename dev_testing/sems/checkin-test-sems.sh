#!/bin/bash -e

# Used to test TriBITS on any SNL machine with the SEMS Dev ENv
#
# To push, can't use --push arg.  Instead have to use:
#
#   env CHECKIN_TEST_SEMS_PUSH=1 ./checkin-test-sems.sh [other args]
#
# Requires that the TriBITS repo be cloned under Trilinos as:
#
#   Trilinos/
#     TriBITS/
#
# You can link this script into any location and it will work out of the box.
#
# NOTE: You will also want to create a local-checkin-test-defaults.py file to
# set -j<N> for the particular machine (see --help).
#
# 
#

if [ "$TRIBITS_BASE_DIR" == "" ] ; then
  _ABS_FILE_PATH=`readlink -f $0`
  CHECKIN_TEST_SEMS_SCRIPT_DIR=`dirname $_ABS_FILE_PATH`
  TRIBITS_BASE_DIR=$CHECKIN_TEST_SEMS_SCRIPT_DIR/../..
fi
#echo "CHECKIN_TEST_SEMS_SCRIPT_DIR = $CHECKIN_TEST_SEMS_SCRIPT_DIR"

export TRIBITS_BASE_DIR_ABS=$(readlink -f $TRIBITS_BASE_DIR)
#echo "TRIBITS_BASE_DIR_ABS = $TRIBITS_BASE_DIR_ABS"

export TRILINOS_BASE_DIR_ABS=$(readlink -f $TRIBITS_BASE_DIR_ABS/..)
#echo "TRIBITS_BASE_DIR_ABS = $TRIBITS_BASE_DIR_ABS"

# Create local defaults file if one does not exist
_LOCAL_CHECKIN_TEST_DEFAULTS=local-checkin-test-defaults.py
if [ -f $_LOCAL_CHECKIN_TEST_DEFAULTS ] ; then
  echo "File $_LOCAL_CHECKIN_TEST_DEFAULTS already exists, leaving it!"
else
  echo "Creating default file $_LOCAL_CHECKIN_TEST_DEFAULTS!"
  echo "
defaults = [
  \"-j8\",
  ]
  " > $_LOCAL_CHECKIN_TEST_DEFAULTS
fi

for arg in "$@" ; do
  #echo "arg = '$arg'"
  if [ "$arg" == "--push" ] ; then
    echo "ERROR: Passed in '--push': To push you must use 'env CHECKIN_TEST_SEMS_PUSH=1 ..."
    exit 1
  fi
done

$CHECKIN_TEST_SEMS_SCRIPT_DIR/checkin-test-sems-cmake-2.8.11.sh \
"$@"

$CHECKIN_TEST_SEMS_SCRIPT_DIR/checkin-test-sems-cmake-3.3.2.sh \
"$@"

if [ "$CHECKIN_TEST_SEMS_PUSH" == "1" ] ; then
  $TRIBITS_BASE_DIR_ABS/checkin-test.py \
  --st-extra-builds=MPI_DEBUG_CMAKE-2.8.11,SERIAL_RELEASE_CMAKE-2.8.11,MPI_DEBUG_CMAKE-3.3.2,SERIAL_RELEASE_CMAKE-3.3.2 \
  --push
fi




