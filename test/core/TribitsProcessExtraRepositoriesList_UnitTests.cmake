# @HEADER
# ************************************************************************
#
#            TriBITS: Tribal Build, Integrate, and Test System
#                    Copyright 2013 Sandia Corporation
#
# Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
# the U.S. Government retains certain rights in this software.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the Corporation nor the names of the
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ************************************************************************
# @HEADER

MESSAGE("PROJECT_NAME = ${PROJECT_NAME}")
MESSAGE("${PROJECT_NAME}_TRIBITS_DIR = ${${PROJECT_NAME}_TRIBITS_DIR}")

SET( CMAKE_MODULE_PATH
  "${${PROJECT_NAME}_TRIBITS_DIR}/core/utils"
  "${${PROJECT_NAME}_TRIBITS_DIR}/core/package_arch"
  )

INCLUDE(TribitsCMakePolicies)
INCLUDE(TribitsProcessExtraRepositoriesList)
INCLUDE(UnitTestHelpers)
INCLUDE(GlobalSet)


#####################################################################
#
# Unit tests for code in TribitsProcessExtraRepositoriesList.cmake
#
#####################################################################


FUNCTION(UNITTEST_TRIBITS_PROCESS_EXTRAREPOS_LISTS)

  MESSAGE("\n***")
  MESSAGE("*** Test TRIBITS_PROCESS_EXTRAREPOS_LISTS() getting Nightly")
  MESSAGE("***\n")

  SET(TRIBITS_PROCESS_EXTRAREPOS_LISTS_DEBUG  TRUE)

  SET(${PROJECT_NAME}_ENABLE_KNOWN_EXTERNAL_REPOS_TYPE  Nightly)

  TRIBITS_PROJECT_DEFINE_EXTRA_REPOSITORIES(
     repo0_name  ""              GIT   "git@url0.com:repo0"  ""           Continuous
     repo1_name  "some/sub/dir"  SVN   "git@url1.com:repo1"  NOPACKAGES   Nightly
     )
  
  TRIBITS_PROCESS_EXTRAREPOS_LISTS()

  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_DEFAULT
    "repo0_name;repo1_name")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_DIRS
    "repo0_name;some/sub/dir")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_REPOTYPES
    "GIT;SVN")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_REPOURLS
    "git@url0.com:repo0;git@url1.com:repo1")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_PACKSTATS
    "HASPACKAGES;NOPACKAGES")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_PREPOSTS
    "POST;POST")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_CATEGORIES
    "Continuous;Nightly")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_PRE_REPOSITORIES_DEFAULT
    "")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_EXTRA_REPOSITORIES_DEFAULT
    "repo0_name;repo1_name")

  MESSAGE("\n***")
  MESSAGE("*** Test TRIBITS_PROCESS_EXTRAREPOS_LISTS() getting Continuous")
  MESSAGE("***\n")

  SET(TRIBITS_PROCESS_EXTRAREPOS_LISTS_DEBUG  TRUE)

  SET(${PROJECT_NAME}_ENABLE_KNOWN_EXTERNAL_REPOS_TYPE  Continuous)

  TRIBITS_PROJECT_DEFINE_EXTRA_REPOSITORIES(
     repo0_name  ""              GIT   "git@url0.com:repo0"  ""           Continuous
     repo1_name  "some/sub/dir"  SVN   "git@url1.com:repo1"  NOPACKAGES   Nightly
     )
  
  TRIBITS_PROCESS_EXTRAREPOS_LISTS()

  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_DEFAULT
    "repo0_name")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_DIRS
    "repo0_name")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_REPOTYPES
    "GIT")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_REPOURLS
    "git@url0.com:repo0")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_PACKSTATS
    "HASPACKAGES")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_PREPOSTS
    "POST")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_CATEGORIES
    "Continuous")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_PRE_REPOSITORIES_DEFAULT
    "")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_EXTRA_REPOSITORIES_DEFAULT
    "repo0_name")


  MESSAGE("\n***")
  MESSAGE("*** Test TRIBITS_PROCESS_EXTRAREPOS_LISTS() empty VC type and URL")
  MESSAGE("***\n")

  SET(TRIBITS_PROCESS_EXTRAREPOS_LISTS_DEBUG  TRUE)

  SET(${PROJECT_NAME}_ENABLE_KNOWN_EXTERNAL_REPOS_TYPE  Continuous)

  TRIBITS_PROJECT_DEFINE_EXTRA_REPOSITORIES(
     repo0_name  ""              ""   ""  ""           Continuous
     )
  
  TRIBITS_PROCESS_EXTRAREPOS_LISTS()

  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_DEFAULT
    "repo0_name")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_DIRS
    "repo0_name")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_REPOTYPES
    "")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_REPOURLS
    "")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_PACKSTATS
    "HASPACKAGES")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_PREPOSTS
    "POST")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_ALL_EXTRA_REPOSITORIES_CATEGORIES
    "Continuous")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_PRE_REPOSITORIES_DEFAULT
    "")
  UNITTEST_COMPARE_CONST( ${PROJECT_NAME}_EXTRA_REPOSITORIES_DEFAULT
    "repo0_name")

  # ToDo: Test error when setting non-empty REPOURL when REPOTYPE is empty

  # ToDo: Test error when invalid VC type is given

ENDFUNCTION()



#####################################################################
#
# Execute the unit tests
#
#####################################################################

# Assume that all unit tests will pass by default
GLOBAL_SET(UNITTEST_OVERALL_PASS TRUE)
GLOBAL_SET(UNITTEST_OVERALL_NUMPASSED 0)
GLOBAL_SET(UNITTEST_OVERALL_NUMRUN 0)

# Set common/base options
SET(PROJECT_NAME "DummyProject")
SET(PROJECT_SOURCE_DIR "/home/me/DummyProject")

UNITTEST_TRIBITS_PROCESS_EXTRAREPOS_LISTS()

# Pass in the number of expected tests that must pass!
UNITTEST_FINAL_RESULT(27)
