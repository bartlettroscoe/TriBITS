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


include(TribitsGeneralMacros)


# @FUNCTION: tribits_write_external_package_config_file_str()
#
# Write out a ``<tplName>Config.cmake`` file into the provided directory given
# the list of include directories and libraries for an external package/TPL.
#
# Usage::
#
#   tribits_write_external_package_config_file_str(
#     <tplName>
#     <tplConfigFileStrOut>
#     )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<tplConfigFileStrOut>``: Name of variable that will contain the string
#   for the config file on output.
#
# This function reads from the varaibles ``TPL_<tplName>_INCLUDE_DIRS`` and
# ``TPL_<tplName>_LIBRARIES`` (which must already be set) and uses that
# information to produce the contents of the ``<tplName>Config.cmake`` which
# is returned as a string variable that contains IMPORTED targets the
# represent these libraries and include directories.
#
# ToDo: Flesh out more documentation for behavior as more features are added
# for handling:
#
# * ``TPL_<tplName>_LIBRARIES`` containing ``-l`` and ``-L`` arguments ...
#
# * ``TPL_<tplName>_LIBRARIES`` containing arguments other than library files
# * or ``-l`` and ``-L`` arguments and files.
#
function(tribits_write_external_package_config_file_str tplName tplConfigFileStrOut)

  #
  # A) Set up beginning of config file text
  #

  set(configFileStr "")
  string(APPEND configFileStr
    "# Package config file for external package/TPL '${tplName}'\n"
    "#\n"
    "# Generated by CMake, do not edit!\n"
    "\n"
    "include_guard()\n"
    "\n"
    )

  #
  # B) Create IMPORTED library targets from TPL_${tplName}_LIBRARIES
  #

  tribits_process_external_package_libraries_list(
    ${tplName}
    LIB_TARGETS_LIST  libTargets
    LIB_LINK_FLAGS_LIST  libLinkFlags
    CONFIG_FILE_STR  configFileStr
    )

  #
  # C) Create the <tplName>::all_libs
  #

  string(APPEND configFileStr
    "add_library(${tplName}::all_libs INTERFACE IMPORTED GLOBAL)\n"
    "target_link_libraries(${tplName}::all_libs\n")
  foreach (libTarget IN LISTS libTargets)
    string(APPEND configFileStr
      "  INTERFACE ${libTarget}\n")
  endforeach()
  string(APPEND configFileStr
    "  )\n\n")

  #
  # D) Set the output
  #

  set(${tplConfigFileStrOut} "${configFileStr}" PARENT_SCOPE)

endfunction()


# @FUNCTION: tribits_process_external_package_libraries_list()
#
# Read the ``TPL_<tplName>_LIBRARIES` list variable and produce the string for
# the IMPORTED targets commands and return list of targets and left over
# linker flags..
#
# Usage::
#
#   tribits_process_external_package_libraries_list(
#     <tplName>
#     LIB_TARGETS_LIST <libTargetsList>
#     LIB_LINK_FLAGS_LIST <libLinkFlagsList>
#     CONFIG_FILE_STR <configFileFragStrInOut>
#     )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<libTargetsList>``: Name of list variable that will be set with the list
#   of IMPORTED library targets generated from this list.
#
#   ``<libLinkFlagsList>``: Name of list variable that will be set with the
#   list of ``-L<dir>`` library directoy paths.
#
#   ``<configFileFragStrInOut>``: A string variable that will be appended with
#   the IMPORTED library commands for the list of targts given in
#   ``<libTargetsList>``.
#
function(tribits_process_external_package_libraries_list  tplName)

  #
  # A) Parse commandline arguments
  #

  cmake_parse_arguments(
     PARSE #prefix
     ""    #options
     "LIB_TARGETS_LIST;LIB_LINK_FLAGS_LIST;CONFIG_FILE_STR"  #one_value_keywords
     ""    #multi_value_keywords
     ${ARGN}
     )
  tribits_check_for_unparsed_arguments()

  set(configFileStrInit "${${PARSE_CONFIG_FILE_STR}}")

  #
  # B) Create IMPORTED library targets from TPL_${tplName}_LIBRARIES
  #

  set(configFileStr "")
  set(libTargets "")
  set(lastLib "")

  # Iterate through libs in reverse order setting dependencies on the libs
  # that came before them so CMake will put in right order on the link line.

  set(reversLibraries ${TPL_${tplName}_LIBRARIES})
  list(REVERSE reversLibraries)

  foreach (libentry IN LISTS reversLibraries)
    #print_var(libentry)
    if (IS_ABSOLUTE "${libentry}")
      # Should be an absolute library path
      get_filename_component(full_libname "${libentry}" NAME_WLE)
      #print_var(full_libname)
      # Assert is a valid lib name and get lib name
      string(LENGTH "${full_libname}" full_libname_len)
      if (full_libname_len LESS 0)
        tribits_print_invalid_lib_name(${tplName} "${full_libname}")
      endif()
      string(SUBSTRING "${full_libname}" 0 3 libPart)
      if (NOT libPart STREQUAL "lib")
        tribits_print_invalid_lib_name(${tplName} "${full_libname}")
      endif()
      string(SUBSTRING "${full_libname}" 3 -1 libname)
      #print_var(libname)
      # Create IMPORTED library target
      string(APPEND configFileStr
        "add_library(${tplName}::${libname} IMPORTED GLOBAL)\n"
        "set_target_properties(${tplName}::${libname} PROPERTIES\n"
        "  IMPORTED_LOCATION \"${libentry}\")\n"
        )
      # Set dependency on previous library
      if (lastLib)
        string(APPEND configFileStr
          "add_library(${tplName}::${libname} IMPORTED GLOBAL)\n"
          "target_link_libraries(${tplName}::${libname}\n"
          "  INTERFACE ${tplName}::${lastlib})\n"
          )
      endif()
      string(APPEND configFileStr
        "\n")
      # Update for next loop
      set(lastLib ${libname})
      list(APPEND libTargets "${tplName}::${libname}")
    else()
      message(SEND_ERROR
        "ERROR: Can't handle argument '${libentry}' in list TPL_${tplName}_LIBRARIES")
    endif()
  endforeach()


  #
  # C) Set ouptut arguments:
  #

  set(${PARSE_LIB_TARGETS_LIST} "${libTargets}" PARENT_SCOPE)
  set(${PARSE_LIB_LINK_FLAGS_LIST} "") # ToDo: Fill in once supported!
  set(${PARSE_CONFIG_FILE_STR} "${configFileStrInit}${configFileStr}" PARENT_SCOPE)

endfunction()


function(tribits_print_invalid_lib_name  tplName  full_libname)
  message(SEND_ERROR
    "ERROR: TPL_${tplName}_LIBRARIES entry '${full_libname}' not a valid lib name!")
endfunction()




