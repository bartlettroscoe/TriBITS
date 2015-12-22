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

import os
import sys
import copy
import unittest

from FindCISupportDir import *
from CDashQueryPassFail import *


g_testBaseDir = getScriptBaseDir()

tribitsBaseDir=os.path.abspath(g_testBaseDir+"/../../tribits")
mockProjectBaseDir=os.path.abspath(tribitsBaseDir+"/examples/MockTrilinos")

#
# Data for tests
#

fullCDashIndexBuilds = \
  eval(open('cdash_index_query_data.txt', 'r').read())

summmaryCDashIndexBuilds_expected = \
  eval(open('cdash_index_query_data.summary.txt', 'r').read())

singleBuildPasses = {
  'buildname':"buildName",
  'update': {'errors':0},
  'configure':{'error': 0},
  'compilation':{'error':0},
  'test': {'fail':0, 'notrun':0},
  }


#############################################################################
#
# Test CDashQueryPassFail.py
#
#############################################################################

class test_CDashQueryPassFail(unittest.TestCase):

  def test_getCDashIndexBuildsSummary(self):
    summaryCDashIndexBuilds = getCDashIndexBuildsSummary(fullCDashIndexBuilds)
    #pp.pprint(summaryCDashIndexBuilds)
    self.assertEqual(len(summaryCDashIndexBuilds), len(summmaryCDashIndexBuilds_expected))
    for i in range(0, len(summaryCDashIndexBuilds)):
      self.assertEqual(summaryCDashIndexBuilds[i], summmaryCDashIndexBuilds_expected[i])

  def test_cdashIndexBuildPasses_pass(self):
    build = copy.deepcopy(singleBuildPasses)
    self.assertEqual(cdashIndexBuildPasses(build), True)

  def test_cdashIndexBuildPasses_update_fail(self):
    build = copy.deepcopy(singleBuildPasses)
    build['update']['errors'] = 1
    self.assertEqual(cdashIndexBuildPasses(build), False)

  def test_cdashIndexBuildPasses_configure_fail(self):
    build = copy.deepcopy(singleBuildPasses)
    build['configure']['error'] = 1
    self.assertEqual(cdashIndexBuildPasses(build), False)

  def test_cdashIndexBuildPasses_compilation_fail(self):
    build = copy.deepcopy(singleBuildPasses)
    build['compilation']['error'] = 1
    self.assertEqual(cdashIndexBuildPasses(build), False)

  def test_cdashIndexBuildPasses_test_fail_fail(self):
    build = copy.deepcopy(singleBuildPasses)
    build['test']['fail'] = 1
    self.assertEqual(cdashIndexBuildPasses(build), False)

  def test_cdashIndexBuildPasses_test_notrun_fail(self):
    build = copy.deepcopy(singleBuildPasses)
    build['test']['notrun'] = 1
    self.assertEqual(cdashIndexBuildPasses(build), False)

  def test_cdashIndexBuildsPass_1_pass(self):
    builds = [copy.deepcopy(singleBuildPasses)]
    (buildPasses, buildFailedMsg) = cdashIndexBuildsPass(builds)
    self.assertEqual(buildPasses, True)
    self.assertEqual(buildFailedMsg, "")

  def test_cdashIndexBuildsPass_1_fail(self):
    build = copy.deepcopy(singleBuildPasses)
    build['compilation']['error'] = 1
    builds = [build]
    (buildPasses, buildFailedMsg) = cdashIndexBuildsPass(builds)
    self.assertEqual(buildPasses, False)
    self.assertEqual(buildFailedMsg, "Error, the build "+str(build)+" failed!")

  def test_cdashIndexBuildsPass_2_pass(self):
    build = copy.deepcopy(singleBuildPasses)
    builds = [build, build]
    (buildPasses, buildFailedMsg) = cdashIndexBuildsPass(builds)
    self.assertEqual(buildPasses, True)
    self.assertEqual(buildFailedMsg, "")

  def test_cdashIndexBuildsPass_2_fail_1(self):
    build = copy.deepcopy(singleBuildPasses)
    buildFailed = copy.deepcopy(singleBuildPasses)
    buildFailed['buildname'] = "failedBuild"
    buildFailed['compilation']['error'] = 1
    builds = [buildFailed, build]
    (buildPasses, buildFailedMsg) = cdashIndexBuildsPass(builds)
    self.assertEqual(buildPasses, False)
    self.assertEqual(buildFailedMsg, "Error, the build "+str(buildFailed)+" failed!")

  def test_cdashIndexBuildsPass_2_fail_2(self):
    build = copy.deepcopy(singleBuildPasses)
    buildFailed = copy.deepcopy(singleBuildPasses)
    buildFailed['buildname'] = "failedBuild"
    buildFailed['compilation']['error'] = 1
    builds = [build, buildFailed]
    (buildPasses, buildFailedMsg) = cdashIndexBuildsPass(builds)
    self.assertEqual(buildPasses, False)
    self.assertEqual(buildFailedMsg, "Error, the build "+str(buildFailed)+" failed!")

  def test_getCDashIndexBuildNames(self):
    build1 = copy.deepcopy(singleBuildPasses)
    build1['buildname'] = "build1"
    build2 = copy.deepcopy(singleBuildPasses)
    build2['buildname'] = "build2"
    build3 = copy.deepcopy(singleBuildPasses)
    build3['buildname'] = "build3"
    builds = [build1, build2, build3]
    buildNames_expected = [ "build1", "build2", "build3" ]
    self.assertEqual(getCDashIndexBuildNames(builds), buildNames_expected)

  def test_doAllExpectedBuildsExist_1_pass(self):
    buildNames = ["build1"]
    expectedBuildNames = ["build1"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg, "")
    self.assertEqual(allExpectedBuildsExist, True)

  def test_doAllExpectedBuildsExist_1_fail(self):
    buildNames = ["build1"]
    expectedBuildNames = ["build2"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg,
      "Error, the expected build 'build2' does not exist in the list of builds ['build1']")
    self.assertEqual(allExpectedBuildsExist, False)

  def test_doAllExpectedBuildsExist_2_2_a_pass(self):
    buildNames = ["build1", "build2"]
    expectedBuildNames = ["build1", "build2"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg, "")
    self.assertEqual(allExpectedBuildsExist, True)

  def test_doAllExpectedBuildsExist_2_2_b_fail(self):
    buildNames = ["build2", "build1"]
    expectedBuildNames = ["build1", "build2"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg, "")
    self.assertEqual(allExpectedBuildsExist, True)

  def test_doAllExpectedBuildsExist_2_1_pass(self):
    buildNames = ["build1", "build2"]
    expectedBuildNames = ["build1"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg, "")
    self.assertEqual(allExpectedBuildsExist, True)

  def test_doAllExpectedBuildsExist_2_1_fail(self):
    buildNames = ["build1", "build2"]
    expectedBuildNames = ["build3"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg,
      "Error, the expected build 'build3' does not exist in the list of builds ['build1', 'build2']")
    self.assertEqual(allExpectedBuildsExist, False)

  def test_doAllExpectedBuildsExist_1_2_a_fail(self):
    buildNames = ["build1"]
    expectedBuildNames = ["build1", "build2"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg,
      "Error, the expected build 'build2' does not exist in the list of builds ['build1']")
    self.assertEqual(allExpectedBuildsExist, False)

  def test_doAllExpectedBuildsExist_1_2_b_fail(self):
    buildNames = ["build1"]
    expectedBuildNames = ["build2", "build1"]
    (allExpectedBuildsExist, errMsg) = \
      doAllExpectedBuildsExist(buildNames, expectedBuildNames)
    self.assertEqual(errMsg,
      "Error, the expected build 'build2' does not exist in the list of builds ['build1']")
    self.assertEqual(allExpectedBuildsExist, False)


if __name__ == '__main__':

  unittest.main()
