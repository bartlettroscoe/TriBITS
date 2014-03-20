MACRO(TRIBITS_REPOSITORY_SETUP_EXTRA_OPTIONS)

  ASSERT_DEFINED(${PROJECT_NAME}_ENABLE_EXPORT_MAKEFILES)
  ASSERT_DEFINED(${PROJECT_NAME}_ENABLE_INSTALL_CMAKE_CONFIG_FILES)

  IF (${PROJECT_NAME}_ENABLE_EXPORT_MAKEFILES OR 
    ${PROJECT_NAME}_ENABLE_INSTALL_CMAKE_CONFIG_FILES
    )
    MESSAGE(
      "\n***"
      "\n*** Warning: Setting ${PROJECT_NAME}_ENABLE_WrapExternal=OFF"
      " because ${PROJECT_NAME}_ENABLE_EXPORT_MAKEFILES or"
      " ${PROJECT_NAME}_ENABLE_INSTALL_CMAKE_CONFIG_FILES is on!"
      "\n***\n"
      )
    SET(${PROJECT_NAME}_ENABLE_WrapExternal OFF)
  ENDIF()

ENDMACRO()
