

TriBITS Macros and Functions
----------------------------

The following subsections give detailed documentation for the CMake macros and
functions that make up the core TriBITS system.  These are what are used by
TriBITS project developers in their ``CMakeLists.txt`` and other files.  All
of these functions and macros should be automatically available when
processing the project's and package's variables files if used properly.
Therefore, no explicit ``include()`` statements should be needed other than
the initial include of the ``TriBITS.cmake`` file in the top-level
`<projectDir>/CMakeLists.txt`_ file so the command `tribits_project()`_ can be
executed.

.. include:: TribitsMacroFunctionDoc.rst


General Utility Macros and Functions
------------------------------------

The following subsections give detailed documentation for some CMake macros
and functions which are *not* a core part of the TriBITS system but are
included in the TriBITS source tree, are used inside of the TriBITS system,
and are provided as a convenience to TriBITS project developers.  One will see
many of these functions and macros used throughout the implementation of
TriBITS and even in the ``CMakeLists.txt`` files for different projects that
use TriBITS.

These macros and functions are *not* prefixed with ``TRIBITS_``.  However,
there is really not a large risk to defining and using these non-namespaces
utility functions and macros.  It turns out that CMake allows one to redefine
any macro or function, even built-in ones, inside of one's project.
Therefore, even if CMake did add new commands that clashed with these names,
there would be no conflict.  When overriding a built-in command,
e.g. ``some_builtin_command()``, one can always access the original built-in
command as ``_some_builtin_command()``.

.. include:: UtilsMacroFunctionDoc.rst
