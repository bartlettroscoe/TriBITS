# @HEADER
# *****************************************************************************
#            TriBITS: Tribal Build, Integrate, and Test System
#
# Copyright 2013-2016 NTESS and the TriBITS contributors.
# SPDX-License-Identifier: BSD-3-Clause
# *****************************************************************************
# @HEADER

include(TribitsDefineStandardCompileVars)
include(DualScopePrependCmndlineArgs)
include(PrintVar)

#
# Helper macros
#

macro(tribits_set_language_buildtype_flags LANG BUILDTYPE)

  #print_var(CMAKE_${LANG}_FLAGS_${BUILDTYPE})
  #print_var(GENERAL_${BUILDTYPE}_FLAGS)

  # Set the default CMAKE_${LANG}_FLAGS_${BUILDTYPE} to empty to override the
  # default that CMake gives!  We want to define these for ourselves.
  set(CMAKE_${LANG}_FLAGS_${BUILDTYPE} "")

  if (${LANG}_${BUILDTYPE}_FLAGS)
    dual_scope_prepend_cmndline_args(CMAKE_${LANG}_FLAGS_${BUILDTYPE}
      "${${LANG}_${BUILDTYPE}_FLAGS}")
  endif()
  if(${PROJECT_NAME}_VERBOSE_CONFIGURE)
    message(STATUS "Adding ${LANG} ${BUILDTYPE} flags"
      " \"${${LANG}_${BUILDTYPE}_FLAGS}\"")
    print_var(CMAKE_${LANG}_FLAGS_${BUILDTYPE})
  endif()

endmacro()


macro(tribits_set_language_buildtype_flags_override LANG BUILDTYPE)

  set(CMAKE_${LANG}_FLAGS_${BUILDTYPE}_OVERRIDE  ""
    CACHE  STRING
    "If set to non-empty, will override CMAKE_${LANG}_FLAGS_${BUILDTYPE}")

  if (CMAKE_${LANG}_FLAGS_${BUILDTYPE}_OVERRIDE)
    if(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      message(
        "-- Overriding CMAKE_${LANG}_FLAGS_${BUILDTYPE}:\n"
        "--  from\n"
        "--    ${CMAKE_${LANG}_FLAGS_${BUILDTYPE}}")
    endif()
    dual_scope_set(CMAKE_${LANG}_FLAGS_${BUILDTYPE}
      ${CMAKE_${LANG}_FLAGS_${BUILDTYPE}_OVERRIDE})
    if(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      message(
        "--  to\n"
        "--    ${CMAKE_${LANG}_FLAGS_${BUILDTYPE}}")
    endif()
  endif()

  # NOTE: Above, we can't just let users set CMAKE_${LANG}_FLAGS_${BUILDTYPE}
  # in the cache because CMake overrides it.  We have to add this override
  # option to allow them to override it.

endmacro()


macro(tribits_set_language_all_buildtypes_flags_override LANG)

  foreach(BUILDTYPE ${CMAKE_BUILD_TYPES_LIST})
    tribits_set_language_buildtype_flags_override(${LANG} ${BUILDTYPE})
  endforeach()

endmacro()


macro(tribits_set_language_general_flags LANG)

  dual_scope_prepend_cmndline_args(CMAKE_${LANG}_FLAGS "${GENERAL_BUILD_FLAGS}")
  if(${PROJECT_NAME}_VERBOSE_CONFIGURE)
    message(STATUS "Adding general ${LANG} flags \"${${GENERAL_BUILD_FLAGS}}\"")
    print_var(CMAKE_${LANG}_FLAGS)
  endif()

endmacro()


macro(tribits_set_language_coverage_flags LANG)

  dual_scope_prepend_cmndline_args(CMAKE_${LANG}_FLAGS
   "${${PROJECT_NAME}_COVERAGE_OPTIONS}")
  if(${PROJECT_NAME}_COVERAGE_OPTIONS AND ${PROJECT_NAME}_VERBOSE_CONFIGURE)
    message(STATUS "Adding coverage ${LANG} flags \"${${PROJECT_NAME}_COVERAGE_OPTIONS}\"")
    print_var(CMAKE_${LANG}_FLAGS)
  endif()

endmacro()


#
# Function that sets up strong compile options for the primary
# development platform (i.e. gcc)
#
# NOTE: The compiler flags in the cache, which may have been set by
# the user, are not disturbed in this function.  Instead variables in
# the parent base scope are set.
#
# NOTE: This function should be called only once before adding any libraries,
# executables, etc.
#

function(tribits_setup_basic_compile_link_flags)

  #
  # Setup and general flags
  #

  tribits_define_standard_compile_flags_vars(FALSE)

  #
  # Set up coverage testing options
  #

  set(${PROJECT_NAME}_COVERAGE_OPTIONS_DEFAULT "")
  if (${PROJECT_NAME}_ENABLE_COVERAGE_TESTING)
    if (CMAKE_C_COMPILER_ID STREQUAL "GNU")
      set(${PROJECT_NAME}_COVERAGE_OPTIONS_DEFAULT "-fprofile-arcs -ftest-coverage")
    elseif (CMAKE_C_COMPILER_ID STREQUAL "Clang")  # gcov compatible
      set(${PROJECT_NAME}_COVERAGE_OPTIONS_DEFAULT "--coverage")
    endif()
  endif()
  set(${PROJECT_NAME}_COVERAGE_OPTIONS "${${PROJECT_NAME}_COVERAGE_OPTIONS_DEFAULT}"
    CACHE STRING "Coverage options to use when ${PROJECT_NAME}_ENABLE_COVERAGE_TESTING=ON")

  #
  # C compiler options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_C CMAKE_C_COMPILER_ID)
  if (${PROJECT_NAME}_ENABLE_C AND ${PROJECT_NAME}_COVERAGE_OPTIONS_DEFAULT)
    tribits_set_language_buildtype_flags(C DEBUG)
    tribits_set_language_buildtype_flags(C RELEASE)
    tribits_set_language_general_flags(C)
    tribits_set_language_coverage_flags(C)
  endif()
  tribits_set_language_all_buildtypes_flags_override(C)

  #
  # C++ compiler options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_CXX CMAKE_CXX_COMPILER_ID)
  if (${PROJECT_NAME}_ENABLE_CXX AND ${PROJECT_NAME}_COVERAGE_OPTIONS_DEFAULT)
    tribits_set_language_buildtype_flags(CXX DEBUG)
    tribits_set_language_buildtype_flags(CXX RELEASE)
    tribits_set_language_general_flags(CXX)
    tribits_set_language_coverage_flags(CXX)
  endif()
  tribits_set_language_all_buildtypes_flags_override(CXX)

  #
  # Fortran compiler options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_Fortran)
  if (${PROJECT_NAME}_ENABLE_Fortran AND CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    tribits_set_language_buildtype_flags(Fortran DEBUG)
    tribits_set_language_buildtype_flags(Fortran RELEASE)
    tribits_set_language_general_flags(Fortran)
    tribits_set_language_coverage_flags(Fortran)
  endif()
  tribits_set_language_all_buildtypes_flags_override(Fortran)

  #
  # Linker options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_COVERAGE_TESTING
    ${PROJECT_NAME}_COVERAGE_OPTIONS)
  if (${PROJECT_NAME}_ENABLE_COVERAGE_TESTING AND ${PROJECT_NAME}_COVERAGE_OPTIONS)
    dual_scope_prepend_cmndline_args(CMAKE_EXE_LINKER_FLAGS
     "${${PROJECT_NAME}_COVERAGE_OPTIONS} ${CMAKE_EXE_LINKER_FLAGS}")
    if(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      message(STATUS "Adding coverage linker flags flags \"${${PROJECT_NAME}_COVERAGE_OPTIONS}\"")
      print_var(CMAKE_EXE_LINKER_FLAGS)
    endif()
  endif()

endfunction()
