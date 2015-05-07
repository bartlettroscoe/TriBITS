# Use TriBITS implementation in *this* TriBITS package!  This is to make
# sure it is consistent with the tests in this TriBITS package.
INCLUDE("${CMAKE_CURRENT_SOURCE_DIR}/../tribits/core/package_arch/TribitsProjectImpl.cmake")

ADD_SUBDIRECTORY(core)

IF (PYTHON_EXECUTABLE)
  ADD_SUBDIRECTORIES(
    python_utils
    ci_support
    ctest_driver
    devtools_install
    )
ENDIF()
