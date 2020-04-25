TRIBITS_ADD_INSTALL_GROUP_AND_PERMS_FIXUPS()

# NOTE: This is a workaround for a problem with an issue with CMake where you
# must call install(SCRIPT ...) in a subdirectory added with
# add_subdirectory() in order for CMake to run that install script after all
# of the other subdirectories (which are TriBITS packages).  In automated
# testing of TriBITS, this seems to show that this custom script runs after
# all of the other files get installed and passes the automated test that
# ensures that the last file installed is given the correct permissions!
