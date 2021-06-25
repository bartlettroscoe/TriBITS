=======================================
TriBITS Maintainers Guide and Reference
=======================================

:Author: Roscoe A. Bartlett (rabartl@sandia.gov)
:Date: |date|
:Version: .. include:: ../TribitsGitVersion.txt

.. |date| date::

:Abstract: This document describes the internal implementation and the maintenance of the TriBITS project itself.  The primary audience are those individuals who will make changes and contributions to the TriBITS project.  This includes 

.. sectnum::
   :depth: 2

.. Above, the depth of the TOC is set to just 2 because I don't want the
.. TriBITS function/macro names to have section numbers appearing before them.
.. Also, some of them are long and I don't want them to go off the page of the
.. PDF document.

.. Sections in this document use the underlines:
..
.. Level-1 ==================
.. Level-2 ------------------
.. Level-3 ++++++++++++++++++
.. Level-4 ..................

.. contents::


Introduction
=============

This document describes the usage and maintenance of TriBITS (Tribal Build,
Integration, Test System) to develop software projects.

ToDo: Fill this in for the maintainers guide.


.. include:: ../TribitsGuidesBody.rst


.. include:: TribitsCoreDetailedReference.rst


TriBITS System Maintainers Documentation
========================================

This section contains more detailed information about the internal
implementation of TriBITS.  This information is meant to make it easier to
understand and manipulate the data-structures and macros/functions that make
up internal implementation of TriBITS.


.. include:: ../../../core/package_arch/TribitsSystemDataStructuresMacrosFunctions.rst


.. include:: TribitsSystemMacroFunctionDoc.rst


.. include:: ../TribitsGuidesReferences.rst


.. include:: ../TribitsFAQ.rst


Appendix
========

.. include:: ../TribitsHistory.rst

.. include:: ../TribitsPackageNotCMakePackage.rst

.. include:: ../TribitsDesignConsiderations.rst

.. include:: ../TribitsToolsDocumentation.rst
