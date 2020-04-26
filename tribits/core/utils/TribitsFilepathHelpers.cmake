#
# @FUNCTION: TRIBITS_DIR_IS_BASEDIR()
#
# Function to determin if a given path is a base dir of another path.
#
# Usage::
#
#   TRIBITS_DIR_IS_BASEDIR(<absBaseDir> <absFullDir> <isBaseDirVarOut>)
#
# If the absolute path ``<absBaseDir>`` is a subdir of the absolute path
# ``<absFullDir>``, then the variable ``<isBaseDirVarOut>`` is set to
# ``TRUE``.  Otherwise, ``<isBaseDirVarOut>`` is set to ``FALSE``.
#
# For example, the ouptut var ``isBaseDir`` would be set to ``TRUE`` in the
# following examples::
#
#   TRIBITS_DIR_IS_BASEDIR(/some/base/path /some/base/path/more isBaseDir)
#
#   TRIBITS_DIR_IS_BASEDIR(/some/base/path /some/base/path isBaseDir)
#
# Hoever, in the following examples, ``isBaseDir`` would be set to ``FALSE``::
#
#   TRIBITS_DIR_IS_BASEDIR(/some/base/path/more /some/base/path isBaseDir)
#
#   TRIBITS_DIR_IS_BASEDIR(/some/base/path /some/other/path isBaseDir)
#
FUNCTION(TRIBITS_DIR_IS_BASEDIR  absBaseDir  absFullDir  isBaseDirVarOut)

  # Assume not base dir by default unless we find it is
  SET(isBaseDir FALSE)

  STRING(LENGTH "${absBaseDir}" absBaseDirLen)
  STRING(LENGTH "${absFullDir}" absFullDirLen)

  IF (absBaseDir STREQUAL absFullDir)
    SET(isBaseDir TRUE)
  ELSEIF (NOT absBaseDirLen GREATER absFullDirLen)
    STRING(FIND "${absFullDir}" "${absBaseDir}/" baseDirIdx)
    IF (baseDirIdx EQUAL 0)
      SET(isBaseDir TRUE)
    ENDIF()
  ENDIF()

  SET(${isBaseDirVarOut} ${isBaseDir} PARENT_SCOPE)

ENDFUNCTION()
