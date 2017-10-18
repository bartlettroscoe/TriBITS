#
# A) Forward declare the package so that certain options are also defined for
# subpackages
#
IF(NOT ${PACKAGE_NAME}_TURN_OFF_PACKAGE_DECL)
  TRIBITS_PACKAGE_DECL(PkgWithSubpkgsWithUserErrors)
ENDIF()
#
# B) Define the common options for the package first so they can be used by
# subpackages as well.
#
TRIBITS_ADD_DEBUG_OPTION()


IF(${PACKAGE_NAME}_POSTPROCESS_BEFRORE_SUBPACKAGES)
  TRIBITS_PACKAGE_DEF()
  TRIBITS_PACKAGE_POSTPROCESS()
ENDIF()

#
# C) Process the subpackages
#
TRIBITS_PROCESS_SUBPACKAGES()

#
# D) Define the package now and perform standard post processing
#
IF(NOT ${PACKAGE_NAME}_POSTPROCESS_BEFRORE_SUBPACKAGES)
  TRIBITS_PACKAGE_DEF()
  TRIBITS_PACKAGE_POSTPROCESS()
ENDIF()
