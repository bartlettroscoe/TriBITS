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

include(MessageWrapper)


# @FUNCTION: tribits_external_package_write_config_file()
#
# Write out a ``<tplName>Config.cmake`` file given the list of include
# directories and libraries for an external package/TPL.
#
# Usage::
#
#   tribits_write_external_package_config_file(
#     <tplName> <tplConfigFile> )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<tplConfigFile>``: Full file path for the ``<tplName>Config.cmake``
#   file that will be written out.
#
# This function just calls
# ``tribits_external_package_write_config_file_str()`` and writes that text to
# the file ``<tplConfigFile>`` so see that function for more details.
#
function(tribits_external_package_write_config_file  tplName  tplConfigFile)
  tribits_external_package_write_config_file_str(${tplName} tplConfigFileStr)
  file(WRITE "${tplConfigFile}" "${tplConfigFileStr}")
endfunction()


# @FUNCTION: tribits_external_package_write_config_version_file()
#
# Write out a ``<tplName>ConfigVersion.cmake`` file.
#
# Usage::
#
#   tribits_write_external_package_config_version_file(
#     <tplName> <tplConfigVersionFile> )
#
# ToDo: Add version arguments!
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<tplConfigVersionFile>``: Full file path for the
#   ``<tplName>ConfigVersion.cmake`` file that will be written out.
#
function(tribits_external_package_write_config_version_file  tplName  tplConfigVersionFile)
  set(tplConfigVersionFileStr "")
  string(APPEND tplConfigVersionFileStr
    "# Package config file for external package/TPL '${tplName}'\n"
    "#\n"
    "# Generated by CMake, do not edit!\n"
    "\n"
    "if (TRIBITS_FINDING_RAW_${tplName}_PACKAGE_FIRST)\n"
    "  set(PACKAGE_VERSION_COMPATIBLE FALSE)\n"
    "  set(PACKAGE_VERSION_UNSUITABLE TRUE)\n"
    "else()\n"
    "  set(PACKAGE_VERSION_COMPATIBLE TRUE)\n"
    "endif()\n"
    "\n"
    "# Currently there is no version information\n"
    "set(PACKAGE_VERSION UNKNOWN)\n"
    "set(PACKAGE_VERSION_EXACT FALSE)\n"
    )
  file(WRITE "${tplConfigVersionFile}" "${tplConfigVersionFileStr}")
endfunction()


# @FUNCTION: tribits_external_package_install_config_file()
#
# Install an already-generated ``<tplName>Config.cmake`` file.
#
# Usage::
#
#   tribits_write_external_package_install_config_file(
#     <tplName> <tplConfigFile> )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<tplConfigFile>``: Full file path for the ``<tplName>Config.cmake``
#   file that will be installed into the correct location.
#
function(tribits_external_package_install_config_file  tplName  tplConfigFile)
 install(
    FILES "${tplConfigFile}"
    DESTINATION "${${PROJECT_NAME}_INSTALL_LIB_DIR}/external_packages/${tplName}"
    )
endfunction()


# @FUNCTION: tribits_external_package_install_config_version_file()
#
# Install an already-generated ``<tplName>ConfigVersion.cmake`` file.
#
# Usage::
#
#   tribits_write_external_package_install_config_version_file(
#     <tplName> <tplConfigVersionFile> )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<tplConfigVersionFile>``: Full file path for the
#   ``<tplName>ConfigVersion.cmake`` file that will be installed into the
#   correct location.
#
function(tribits_external_package_install_config_version_file  tplName
     tplConfigVersionFile
  )
 install(
    FILES "${tplConfigVersionFile}"
    DESTINATION "${${PROJECT_NAME}_INSTALL_LIB_DIR}/external_packages/${tplName}"
    )
endfunction()


# @FUNCTION: tribits_external_package_write_config_file_str()
#
# Create the text string for a ``<tplName>Config.cmake`` file given the list of
# include directories and libraries for an external package/TPL.
#
# Usage::
#
#   tribits_external_package_write_config_file_str(
#     <tplName> <tplConfigFileStrOut> )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<tplConfigFileStrOut>``: Name of variable that will contain the string
#   for the config file on output.
#
# This function reads from the variables ``TPL_<tplName>_INCLUDE_DIRS``
# ``TPL_<tplName>_LIBRARIES``, and ``TPL_<tplName>_DEPENDENCIES`` (which must
# already be set) and uses that information to produce the contents of the
# ``<tplName>Config.cmake`` which is returned as a string variable that
# contains IMPORTED targets to represent these libraries and include
# directories as well as ``find_dependency()`` calls for upstream packages
# listed in ``TPL_<tplName>_DEPENDENCIES``
#
# ToDo: Flesh out more documentation for behavior as more features are added
# for handling:
#
# * ``TPL_<tplName>_LIBRARIES`` containing ``-l`` and ``-L`` arguments ...
#
# * ``TPL_<tplName>_LIBRARIES`` containing arguments other than library files
# * or ``-l`` and ``-L`` arguments and files.
#
function(tribits_external_package_write_config_file_str tplName tplConfigFileStrOut)

  # A) Set up beginning of config file text
  set(configFileStr "")
  string(APPEND configFileStr
    "# Package config file for external package/TPL '${tplName}'\n"
    "#\n"
    "# Generated by CMake, do not edit!\n"
    "\n"
    "# Guard against multiple inclusion\n"
    "if (TARGET ${tplName}::all_libs)\n"
    "  return()\n"
    "endif()\n"
    "\n"
    )

  # B) Call find_dependency() for all direct dependent upstream TPLs
  tribits_external_package_add_find_upstream_dependencies_str(${tplName}
    configFileStr)

  # C) Create IMPORTED library targets from TPL_${tplName}_LIBRARIES
  tribits_external_package_process_libraries_list(
    ${tplName}
    LIB_TARGETS_LIST_OUT  libTargets
    LIB_LINK_FLAGS_LIST_OUT  libLinkFlags
    CONFIG_FILE_STR_INOUT  configFileStr
    )

  # D) Create the <tplName>::all_libs target
  tribits_external_package_create_all_libs_target(
    ${tplName}
    LIB_TARGETS_LIST  ${libTargets}
    LIB_LINK_FLAGS_LIST  ${libLinkFlags}
    CONFIG_FILE_STR_INOUT  configFileStr
    )

  # E) Set the output
  set(${tplConfigFileStrOut} "${configFileStr}" PARENT_SCOPE)

endfunction()


# @FUNCTION: tribits_external_package_add_find_upstream_dependencies_str()
#
# Add code to call find_dependency() for all upstream external packages/TPLs
# listed in ``TPL_<tplName>_DEPENDENCIES``.
#
# Usage::
#
#   tribits_external_package_add_find_upstream_dependencies_str(tplName
#     configFileFragStrInOut)
#
# NOTE: This also requires that `<upstreamTplName>_DIR` be set for each
# external package/TPL listed in ``TPL_<tplName>_DEPENDENCIES``.
#
function(tribits_external_package_add_find_upstream_dependencies_str
    tplName  configFileFragStrInOut
  )
  if (NOT "${TPL_${tplName}_DEPENDENCIES}" STREQUAL "")
    set(configFileFragStr "${${configFileFragStrInOut}}")
    string(APPEND configFileFragStr
      "include(CMakeFindDependencyMacro)\n"
      "\n"
     )
    foreach (upstreamTplDepEntry IN LISTS TPL_${tplName}_DEPENDENCIES)
      tribits_external_package_append_upstream_target_link_libraries_get_name_and_vis(
	"${upstreamTplDepEntry}"  upstreamTplDepName  upstreamTplDepVis)
      if ("${${upstreamTplDepName}_DIR}" STREQUAL "")
        message(FATAL_ERROR "ERROR: ${upstreamTplDepName}_DIR is empty!")
      endif()
      string(APPEND configFileFragStr
        "set(${upstreamTplDepName}_DIR \"${${upstreamTplDepName}_DIR}\")\n"
        "find_dependency(${upstreamTplDepName})\n"
        )
    endforeach()
    string(APPEND configFileFragStr
      "\n"
     )
    set(${configFileFragStrInOut} "${configFileFragStr}" PARENT_SCOPE)
  endif()
endfunction()
#
# NOTE: Above, to be the most flexible, we have to set
# `<upstreamTplDepName>_DIR` and then call `find_dependency()` instead of just
# including the file:
#
#   include("${<upstreamTplDepName>_DIR}/<upstreamTplDepName>Config.cmake")
#
# This is to allow finding and depending on external packages/TPLs that may
# have different names than <upstreamTplDepName>Config.cmake.  The CMake
# command find_package() only returns <upstreamTplDepName>_DIR, not the full
# path to the config file or even the config file name.  It is a little bit
# dangerous to use find_dependency() in case the config fire is not found in
# the directory `<upstreamTplDepName>_DIR` but I am not sure how else to do
# this.
#
# ToDo: It would be great to make the above find_dependency() call **only **
# search the directory <upstreamTplDepName>_DIR and no others.  That would make 


# @FUNCTION: tribits_external_package_process_libraries_list()
#
# Read the ``TPL_<tplName>_LIBRARIES`` and ``TPL_<tplName>_DEPENDENCIES`` list
# variables and produce the string for the IMPORTED targets commands with
# upstream linkages and return list of targets and left over linker flags.
#
# Usage::
#
#   tribits_external_package_process_libraries_list(
#     <tplName>
#     LIB_TARGETS_LIST_OUT <libTargetsListOut>
#     LIB_LINK_FLAGS_LIST_OUT <libLinkFlagsListOut>
#     CONFIG_FILE_STR_INOUT <configFileFragStrInOut>
#     )
#
# The arguments are:
#
#   ``<tplName>``: [In] Name of the external package/TPL
#
#   ``<libTargetsListOut>``: [Out] Name of list variable that will be set with
#   the list of IMPORTED library targets generated from this list.
#
#   ``<libLinkFlagsListOut>``: [Out] Name of list variable that will be set
#   with the list of ``-L<dir>`` library directory paths.
#
#   ``<configFileFragStrInOut>``: [Inout] A string variable that will be
#   appended with the IMPORTED library commands for the list of targets given
#   in ``<libTargetsList>``.
#
function(tribits_external_package_process_libraries_list  tplName)

  # A) Parse commandline arguments

  cmake_parse_arguments(
     PARSE #prefix
     ""    #options
     "LIB_TARGETS_LIST_OUT;LIB_LINK_FLAGS_LIST_OUT;CONFIG_FILE_STR_INOUT"  #one_value_keywords
     ""    #multi_value_keywords
     ${ARGN}
     )
  tribits_check_for_unparsed_arguments()

  # Capture the initial input string in case the name of the var
  # 'configFileStr' is the same in the parent scope.
  set(configFileStrInit "${${PARSE_CONFIG_FILE_STR_INOUT}}")

  # B) Create IMPORTED library targets from TPL_${tplName}_LIBRARIES

  set(configFileStr "")
  set(libTargets "")
  set(lastLibProcessed "")

  # Iterate through libs in reverse order setting dependencies on the libs
  # that came before them so CMake will put in right order on the link line.

  set(libLinkFlagsList "")  # Will be filled in reverse order below

  set(reverseLibraries ${TPL_${tplName}_LIBRARIES})
  list(REVERSE reverseLibraries)

  foreach (libentry IN LISTS reverseLibraries)
    #print_var(libentry)
    tribits_tpl_libraries_entry_type(${libentry} libEntryType)
    if (libEntryType STREQUAL "UNSUPPORTED_LIB_ENTRY")
      message_wrapper(SEND_ERROR
        "ERROR: Can't handle argument '${libentry}' in list TPL_${tplName}_LIBRARIES")
    elseif (libEntryType STREQUAL "LIB_DIR_LINK_OPTION")
      list(APPEND libLinkFlagsList "${libentry}")
    elseif (libEntryType STREQUAL "GENERAL_LINK_OPTION")
      message_wrapper("-- NOTE: Moving the general link argument '${libentry}' in TPL_${tplName}_LIBRARIES forward on the link line which may change the link and break the link!")
      list(APPEND libLinkFlagsList "${libentry}")
    else()
      tribits_external_package_process_libraries_list_library_entry(
        ${tplName}  "${libentry}"  ${libEntryType}  libTargets  lastLibProcessed
        configFileStr )
    endif()
  endforeach()

  list(REVERSE libLinkFlagsList) # Put back in original order

  # C) Set output arguments:
  set(${PARSE_LIB_TARGETS_LIST_OUT} "${libTargets}" PARENT_SCOPE)
  set(${PARSE_LIB_LINK_FLAGS_LIST_OUT} "${libLinkFlagsList}" PARENT_SCOPE)
  set(${PARSE_CONFIG_FILE_STR_INOUT} "${configFileStrInit}${configFileStr}"
    PARENT_SCOPE)

endfunction()


# Returns the type of the library entry in the list TPL_<tplName>_LIBRARIES
#
# Arguments:
#
#   ``libentry`` [in]: Element of ``TPL_<tplName>_LIBRARIES``
#
#   ``libEntryTypeOut`` [out]: Variable set on output to the type of entry.
#
# The types of entries set on ``libEntryTypeOut`` include:
#
#   ``FULL_LIB_PATH``: A full library path
#
#   ``LIB_NAME_LINK_OPTION``: A library name link option of the form
#   ``-l<libname>``
#
#   ``LIB_NAME``: A library name of the form ``<libname>``
#
#   ``LIB_DIR_LINK_OPTION``: A library directory search option of the form
#   ``-L<dir>``
#
#   ``GENERAL_LINK_OPTION``: Some other general link option that starts with
#   ``-`` but is not ``-l`` or ``-L``.
#
#   ``UNSUPPORTED_LIB_ENTRY``: An unsupported lib option
#
function(tribits_tpl_libraries_entry_type  libentry  libEntryTypeOut)
  string(SUBSTRING "${libentry}" 0 1 firstCharLibEntry)
  string(SUBSTRING "${libentry}" 0 2 firstTwoCharsLibEntry)
  if (firstTwoCharsLibEntry STREQUAL "-l")
    set(libEntryType LIB_NAME_LINK_OPTION)
  elseif (firstTwoCharsLibEntry STREQUAL "-L")
    set(libEntryType LIB_DIR_LINK_OPTION)
  elseif (firstCharLibEntry STREQUAL "-")
    set(libEntryType GENERAL_LINK_OPTION)
  elseif (IS_ABSOLUTE "${libentry}")
    set(libEntryType FULL_LIB_PATH)
  elseif (libentry MATCHES "^[a-zA-Z_][a-zA-Z0-9_-]*$")
    set(libEntryType LIB_NAME)
  else()
    set(libEntryType UNSUPPORTED_LIB_ENTRY)
  endif()
  set(${libEntryTypeOut} ${libEntryType} PARENT_SCOPE)
endfunction()
# NOTE: Above, if libentry is only 1 char long, then firstTwoCharsLibEntry is
# also 1 char long and the above logic still works.


# Function to process a library inside of loop over
# ``TPL_<tplName>_LIBRARIES`` in the function
# tribits_external_package_process_libraries_list().
#
# This also puts in linkages to upstream TPLs ``<tplName>::all_libs`` listed
# in ``TPL_<tplName>_DEPENDENCIES``.
#
function(tribits_external_package_process_libraries_list_library_entry
    tplName  libentry  libEntryType
    libTargetsInOut  lastLibProcessedInOut  configFileStrInOut
  )
  cmake_policy(SET CMP0057 NEW) # Support if ( ... IN_LIST ... )
  # Set local vars for inout vars
  set(libTargets ${${libTargetsInOut}})
  set(lastLibProcessed ${${lastLibProcessedInOut}})
  set(configFileStr ${${configFileStrInOut}})
  # Get libname
  tribits_external_package_get_libname_and_path_from_libentry(
    "${libentry}"  ${libEntryType}  libname  libpath)
  # Create IMPORTED library target
  set(prefixed_libname "${tplName}::${libname}")
  if (NOT (prefixed_libname IN_LIST libTargets))
    tribits_external_package_append_add_library_str (${libname} ${prefixed_libname}
      ${libEntryType} "${libpath}" configFileStr)
    if (lastLibProcessed)
      string(APPEND configFileStr
        "target_link_libraries(${prefixed_libname}\n"
        "  INTERFACE ${tplName}::${lastLibProcessed})\n"
        )
    else()
      tribits_external_package_append_upstream_target_link_libraries_str( ${tplName}
        ${prefixed_libname}  configFileStr )
    endif()
    string(APPEND configFileStr
      "\n")
    # Update for next loop
    set(lastLibProcessed ${libname})
    list(APPEND libTargets ${prefixed_libname})
  endif()
  # Set output vars
  set(${libTargetsInOut} ${libTargets} PARENT_SCOPE)
  set(${lastLibProcessedInOut} ${lastLibProcessed} PARENT_SCOPE)
  set(${configFileStrInOut} ${configFileStr} PARENT_SCOPE)
endfunction()
# NOTE: Above, we only need to link the first library <tplName>::<libname0>
# against the upstream TPL libraries <upstreamTpl>::all_libs.  The other
# imported targets <tplName>::<libnamei> for this TPL are linked to this first
# <tplName>::<libname0> which has the needed dependencies.

function(tribits_external_package_get_libname_and_path_from_libentry
    libentry  libEntryType  libnameOut  libpathOut
  )
  if (libEntryType STREQUAL "FULL_LIB_PATH")
    tribits_external_package_get_libname_from_full_lib_path("${libentry}" libname)
    set(libpath "${libentry}")
  elseif (libEntryType STREQUAL "LIB_NAME_LINK_OPTION")
    tribits_external_package_get_libname_from_lib_name_link_option("${libentry}" libname)
    set(libpath "")
  elseif (libEntryType STREQUAL "LIB_NAME")
    set(libname "${libentry}")
    set(libpath "")
  else()
    message(FATAL_ERROR "Error libEntryType='${libEntryType}' not supported here!")
  endif()
  set(${libnameOut} ${libname} PARENT_SCOPE)
  set(${libpathOut} ${libpath} PARENT_SCOPE)
endfunction()


function(tribits_external_package_append_add_library_str
    libname  prefix_libname  libEntryType  libpath
    configFileStrInOut
  )
  set(configFileStr "${${configFileStrInOut}}")
  if (libEntryType STREQUAL "FULL_LIB_PATH")
    string(APPEND configFileStr
      "add_library(${prefixed_libname} IMPORTED UNKNOWN GLOBAL)\n"
      "set_target_properties(${prefixed_libname} PROPERTIES\n"
      "  IMPORTED_LOCATION \"${libpath}\")\n"
      )
  elseif (
      (libEntryType STREQUAL "LIB_NAME_LINK_OPTION")
      OR (libEntryType STREQUAL "LIB_NAME")
    )
    string(APPEND configFileStr
      "add_library(${prefixed_libname} IMPORTED INTERFACE GLOBAL)\n"
      "set_target_properties(${prefixed_libname} PROPERTIES\n"
      "  IMPORTED_LIBNAME \"${libname}\")\n"
      )
  else()
    message(FATAL_ERROR "Error libEntryType='${libEntryType}' not supported here!")
  endif()
  set(${configFileStrInOut} "${configFileStr}" PARENT_SCOPE)
endfunction()


function(tribits_external_package_get_libname_from_full_lib_path  full_lib_path
    libnameOut
  )
  # Should be an absolute library path
  get_filename_component(full_libname "${full_lib_path}" NAME_WLE)
  # Assert is a valid lib name and get lib name
  string(LENGTH "${full_libname}" full_libname_len)
  if (full_libname_len LESS 0)
    tribits_print_invalid_lib_name(${tplName} "${full_libname}")
  endif()
  if (WIN32)
    # Native windows compilers does not prepend library names with 'lib'
    set(libname "${full_libname}")
  else()
    # Every other system prepends the library name with 'lib'
    string(SUBSTRING "${full_libname}" 0 3 libPart)
    if (NOT libPart STREQUAL "lib")
      tribits_print_invalid_lib_name(${tplName} "${full_libname}")
    endif()
    string(SUBSTRING "${full_libname}" 3 -1 libname)
  endif()
  set(${libnameOut} ${libname} PARENT_SCOPE)
endfunction()


function(tribits_external_package_get_libname_from_lib_name_link_option
    lib_name_link_option  libnameOut
  )
  # Assert begging part '-l'
  string(SUBSTRING "${lib_name_link_option}" 0 2 firstTwoCharsLibEntry)
  if ( )
    tribits_print_invalid_lib_link_option(${tplName} "${lib_name_link_option}")
  endif()
  # Get <libname> from -l<libname>
  string(SUBSTRING "${lib_name_link_option}" 2 -1 libname)
  # Set output
  set(${libnameOut} ${libname} PARENT_SCOPE)
endfunction()


function(tribits_print_invalid_lib_name  tplName  full_libname)
  message(SEND_ERROR
    "ERROR: TPL_${tplName}_LIBRARIES entry '${full_libname}' not a valid lib name!")
endfunction()


function(tribits_print_invalid_lib_link_option  tplName  liblinkoption)
  message(SEND_ERROR
    "ERROR: TPL_${tplName}_LIBRARIES entry '${liblinkoption}' not a valid lib name link option!")
endfunction()


function(tribits_external_package_append_upstream_target_link_libraries_str
    tplName  prefix_libname  configFileStrInOut
  )
  set(configFileStr "${${configFileStrInOut}}")
  if (TPL_${tplName}_DEPENDENCIES)
    string(APPEND configFileStr
      "target_link_libraries(${prefix_libname}\n")
    foreach (upstreamTplDepEntry IN LISTS TPL_${tplName}_DEPENDENCIES)
      tribits_external_package_append_upstream_target_link_libraries_get_name_and_vis(
	"${upstreamTplDepEntry}"  upstreamTplDepName  upstreamTplDepVis)
      if (upstreamTplDepVis STREQUAL "PUBLIC")
        string(APPEND configFileStr
          "  INTERFACE ${upstreamTplDepName}::all_libs  # i.e. PUBLIC\n")
      elseif(upstreamTplDepVis STREQUAL "PRIVATE")
        string(APPEND configFileStr
          "  INTERFACE $<LINK_ONLY:${upstreamTplDepName}::all_libs>  # i.e. PRIVATE\n")
      else()
        message(FATAL_ERROR "ERROR: Invalid visibility in entry '${upstreamTplDepEntry}'")
      endif()
    endforeach()
    string(APPEND configFileStr
      "  )\n")
  endif()
  set(${configFileStrInOut} "${configFileStr}" PARENT_SCOPE)
endfunction()
#
# NOTE: Above, the syntax for a private dependency is:
#
#   INTERFACE $<LINK_ONLY:upstreamLib>
#
# This has the effect of not bringing along the INTERFACE_INCLUDE_DIRECTORIES
# for upstreamLib so the include dirs for upstreamLib will not be listed on
# the compile lines of downstream object builds.  But it will result in the
# libraries being listed on link lines for downstsream library and exec links.


function(tribits_external_package_append_upstream_target_link_libraries_get_name_and_vis
    upstreamTplDepEntry  upstreamTplDepNameOut  upstreamTplDepVisOut
  )
  string(REPLACE ":" ";" upstreamTplAndVisList  "${upstreamTplDepEntry}")
  list(LENGTH upstreamTplAndVisList upstreamTplAndVisListLen)
  # ToDo: Validate that 1 <= upstreamTplAndVisListLen <= 2
  list(GET upstreamTplAndVisList 0 upstreamTplDepName)
  if (upstreamTplAndVisListLen GREATER 1)
    list(GET upstreamTplAndVisList 1 upstreamTplDepVis)
  else()
    set(upstreamTplDepVis PRIVATE)
  endif()
  # ToDo: Validate value of upstreamTplDepVis!
  set(${upstreamTplDepNameOut} ${upstreamTplDepName} PARENT_SCOPE)
  set(${upstreamTplDepVisOut} ${upstreamTplDepVis} PARENT_SCOPE)
endfunction()


# @FUNCTION: tribits_external_package_create_all_libs_target()
#
# Creates the <tplName>::all_libs target command text using input info and
# from ``TPL_<tplName>_INCLUDE_DIRS``.
#
# Usage::
#
#   tribits_external_package_create_all_libs_target(
#     <tplName>
#     LIB_TARGETS_LIST <libTargetsList>
#     LIB_LINK_FLAGS_LIST <libLinkFlagsList>
#     CONFIG_FILE_STR_INOUT <configFileFragStrInOut>
#     )
#
# The arguments are:
#
#   ``<tplName>``: Name of the external package/TPL
#
#   ``<libTargetsList>``: List of targets created from processing
#   ``TPL_<tplName>_LIBRARIES``.
#
#   ``<libLinkFlagsList>``: List of of ``-L<dir>`` library directory paths
#   entries found while processing ``TPL_<tplName>_LIBRARIES``.
#
#   ``<configFileFragStrInOut>``: A string variable that will be appended with
#   the ``<tplName>::all_libs`` target statements.
#
function(tribits_external_package_create_all_libs_target  tplName)

  # Parse commandline arguments

  cmake_parse_arguments(
     PARSE #prefix
     ""    #options
     "CONFIG_FILE_STR_INOUT"  #one_value_keywords
     "LIB_TARGETS_LIST;LIB_LINK_FLAGS_LIST"  #multi_value_keywords
     ${ARGN}
     )
  tribits_check_for_unparsed_arguments()

  # Set short-hand local vars
  set(libTarget "${PARSE_LIB_TARGETS_LIST}")
  set(libLinkFlags "${PARSE_LIB_LINK_FLAGS_LIST}")

  # Capture the initial input string in case the name of the var
  # 'configFileStr' is the same in the parent scope.
  set(configFileStrInit "${${PARSE_CONFIG_FILE_STR_INOUT}}")

  set(configFileStr "")

  # add_library()
  string(APPEND configFileStr
    "add_library(${tplName}::all_libs INTERFACE IMPORTED GLOBAL)\n")
  # target_link_libraries()
  if (libTargets)
    string(APPEND configFileStr
      "target_link_libraries(${tplName}::all_libs\n")
    foreach (libTarget IN LISTS libTargets)
      string(APPEND configFileStr
        "  INTERFACE ${libTarget}\n")
    endforeach()
    string(APPEND configFileStr
      "  )\n")
  endif()
  # target_include_directories()
  if (TPL_${tplName}_INCLUDE_DIRS)
    string(APPEND configFileStr
      "target_include_directories(${tplName}::all_libs SYSTEM\n")
    foreach (inclDir IN LISTS TPL_${tplName}_INCLUDE_DIRS)
      string(APPEND configFileStr
        "  INTERFACE \"${inclDir}\"\n")
    endforeach()
    string(APPEND configFileStr
      "  )\n")
  endif()
  # target_link_options()
  if (libLinkFlags)
    string(APPEND configFileStr
      "target_link_options(${tplName}::all_libs\n")
    foreach (likLinkFlag IN LISTS libLinkFlags)
      string(APPEND configFileStr
        "  INTERFACE \"${likLinkFlag}\"\n")
    endforeach()
    string(APPEND configFileStr
      "  )\n")
  endif()
  # Add trailing newline
  string(APPEND configFileStr
      "\n")

  # C) Set output arguments
  set(${PARSE_CONFIG_FILE_STR_INOUT} "${configFileStrInit}${configFileStr}"
    PARENT_SCOPE)

endfunction()

