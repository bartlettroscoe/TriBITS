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

# Echo input arguments
message("PROJECT_NAME = '${PROJECT_NAME}'")
message("${PROJECT_NAME}_TRIBITS_DIR = '${${PROJECT_NAME}_TRIBITS_DIR}'")
message("CURRENT_TEST_DIRECTORY = '${CURRENT_TEST_DIRECTORY}'")

set( CMAKE_MODULE_PATH
  "${${PROJECT_NAME}_TRIBITS_DIR}/core/utils"
  "${${PROJECT_NAME}_TRIBITS_DIR}/core/package_arch"
  )

include(TribitsWriteExternalPackageConfigFile)

include(UnitTestHelpers)


#####################################################################
#
# Unit tests for code in TribitsWriteExternalPackageConfigFile.cmake
#
#####################################################################


function(unittest_tribits_process_external_package_libraries_list_incl_dirs_0_lib_files_1)

  message("\n***")
  message("*** Testing tribits_process_external_package_libraries_list(): incl dirs 0, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  set(configFileFragStr "#beginning\n\n")

  tribits_process_external_package_libraries_list( ${tplName}
    LIB_TARGETS_LIST libTargetsList
    LIB_LINK_FLAGS_LIST libLinkFlagsList
    CONFIG_FILE_STR configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::somelib"
    )

  unittest_compare_const( libLinkFlagsList
    ""
    )

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

]=]
    )

endfunction()


function(unittest_tribits_process_external_package_libraries_list_incl_dirs_0_lib_files_2)

  message("\n***")
  message("*** Testing tribits_process_external_package_libraries_list(): incl dirs 0, lib files 2")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    "/some/explicit/path/libsomelib2.so" "/some/explicit/path/libsomelib1.so")

  set(configFileFragStr "#beginning\n\n")

  tribits_process_external_package_libraries_list( ${tplName}
    LIB_TARGETS_LIST libTargetsList
    LIB_LINK_FLAGS_LIST libLinkFlagsList
    CONFIG_FILE_STR configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::somelib1;SomeTpl::somelib2"
    )

  unittest_compare_const( libLinkFlagsList
    ""
    )

  print_var(configFileFragStr)

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::somelib1 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib1 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib1.so")

add_library(SomeTpl::somelib2 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib2 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib2.so")
target_link_libraries(SomeTpl::somelib2
  INTERFACE SomeTpl::somelib1)

]=]
    )

endfunction()


function(unittest_tribits_process_external_package_libraries_list_incl_dirs_0_lib_files_3)

  message("\n***")
  message("*** Testing tribits_process_external_package_libraries_list(): incl dirs 0, lib files 3")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_LIBRARIES
    "/some/explicit/path/libsomelib3.so"
    "/some/explicit/path/libsomelib2.so"
    "/some/explicit/path/libsomelib1.so")

  set(configFileFragStr "#beginning\n\n")

  tribits_process_external_package_libraries_list( ${tplName}
    LIB_TARGETS_LIST libTargetsList
    LIB_LINK_FLAGS_LIST libLinkFlagsList
    CONFIG_FILE_STR configFileFragStr
    )

  unittest_compare_const( libTargetsList
    "SomeTpl::somelib1;SomeTpl::somelib2;SomeTpl::somelib3"
    )

  unittest_compare_const( libLinkFlagsList
    ""
    )

  print_var(configFileFragStr)

  unittest_string_block_compare( configFileFragStr
[=[
#beginning

add_library(SomeTpl::somelib1 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib1 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib1.so")

add_library(SomeTpl::somelib2 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib2 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib2.so")
target_link_libraries(SomeTpl::somelib2
  INTERFACE SomeTpl::somelib1)

add_library(SomeTpl::somelib3 IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib3 PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib3.so")
target_link_libraries(SomeTpl::somelib3
  INTERFACE SomeTpl::somelib2)

]=]
    )

endfunction()


function(unittest_tribits_write_external_package_config_file_str_incl_dirs_0_lib_files_1)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 0, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "")
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  tribits_write_external_package_config_file_str(${tplName}
    tplConfigFileStr )

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::somelib
  )

]=]
    )

endfunction()


function(unittest_tribits_write_external_package_config_file_str_incl_dirs_2_lib_files_0)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 2, lib files 0")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "/some/path/to/include/d" "/some/other/path/to/include/e")
  set(TPL_${tplName}_LIBRARIES "")

  tribits_write_external_package_config_file_str(${tplName}
    tplConfigFileStr )

  print_var(tplConfigFileStr)

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_include_directories(SomeTpl::all_libs
  INTERFACE /some/path/to/include/d
  INTERFACE /some/other/path/to/include/e
  )

]=]
    )

endfunction()


function(unittest_tribits_write_external_package_config_file_str_incl_dirs_1_lib_files_1)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 1, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "/some/path/to/include/C")
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  tribits_write_external_package_config_file_str(${tplName}
    tplConfigFileStr )

  print_var(tplConfigFileStr)

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::somelib
  )
target_include_directories(SomeTpl::all_libs
  INTERFACE /some/path/to/include/C
  )

]=]
    )

endfunction()


function(unittest_tribits_write_external_package_config_file_str_incl_dirs_2_lib_files_1)

  message("\n***")
  message("*** Testing the generation of <tplName>Config.cmake: incl dirs 2, lib files 1")
  message("***\n")

  set(tplName SomeTpl)
  set(TPL_${tplName}_INCLUDE_DIRS "/some/path/to/include/a" "/some/other/path/to/include/b")
  set(TPL_${tplName}_LIBRARIES "/some/explicit/path/libsomelib.so")

  tribits_write_external_package_config_file_str(${tplName}
    tplConfigFileStr )

  print_var(tplConfigFileStr)

  unittest_string_block_compare( tplConfigFileStr
[=[
# Package config file for external package/TPL 'SomeTpl'
#
# Generated by CMake, do not edit!

include_guard()

add_library(SomeTpl::somelib IMPORTED UNKNOWN GLOBAL)
set_target_properties(SomeTpl::somelib PROPERTIES
  IMPORTED_LOCATION "/some/explicit/path/libsomelib.so")

add_library(SomeTpl::all_libs INTERFACE IMPORTED GLOBAL)
target_link_libraries(SomeTpl::all_libs
  INTERFACE SomeTpl::somelib
  )
target_include_directories(SomeTpl::all_libs
  INTERFACE /some/path/to/include/a
  INTERFACE /some/other/path/to/include/b
  )

]=]
    )

endfunction()


#####################################################################
#
# Execute the unit tests
#
#####################################################################

unittest_initialize_vars()

#
# Run the unit tests
#

unittest_tribits_process_external_package_libraries_list_incl_dirs_0_lib_files_1()
unittest_tribits_process_external_package_libraries_list_incl_dirs_0_lib_files_2()
unittest_tribits_process_external_package_libraries_list_incl_dirs_0_lib_files_3()

unittest_tribits_write_external_package_config_file_str_incl_dirs_0_lib_files_1()
unittest_tribits_write_external_package_config_file_str_incl_dirs_2_lib_files_0()
unittest_tribits_write_external_package_config_file_str_incl_dirs_1_lib_files_1()
unittest_tribits_write_external_package_config_file_str_incl_dirs_2_lib_files_1()

# Pass in the number of expected tests that must pass!
unittest_final_result(13)
