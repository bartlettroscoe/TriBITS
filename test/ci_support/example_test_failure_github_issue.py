#!/usr/bin/env python

import os
import sys


#
# Implementation code
#


# Find the implementation
tribitsDir = os.environ.get("TRIBITS_DIR", "")
if tribitsDir:
  sys.path = [os.path.join(tribitsDir, "ci_support")] + sys.path

import CreateIssueTrackerFromCDashQuery as CITFCQ


usageHelp = \
r"""Stock error message.
"""


# The main function
def main():
  issueTrackerCreator = \
    CITFCQ.CreateIssueTrackerFromCDashQueryDriver(
      ExampleIssueTrackerCreatorAndFormatter(),
      cdashProjectStartTimeUtc="6:00", # Midnight MST
      usageHelp=usageHelp,
      issueTrackerUrlTemplate="https://github.com/<group>/<group>/issues/<newissueid>",
      issueTrackerTemplate="#<newissueid>" )
  issueTrackerCreator.runDriver()


# Nonmember function to actually create the body of the new GitHub marddown text
#
# NOTE: This was made a nonmember function to put this to the bottom and not
# obscure the implementing class 'ExampleIssueTrackerCreatorAndFormatter'
#
def getGithubIssueBodyMarkdown(summaryLine, testingDayStartNonpassingDate,
    nonpassingTestsUrl, uniqNonpassingTestsLOD, buildnameList, testnameList,
    testHistoryHtmlTableText,
  ):
  issueTrackerText = ""

  issueTrackerText += \
r"""
SUMMARY: """+summaryLine+" "+testingDayStartNonpassingDate+r"""

## Description

As shown in [this query]("""+nonpassingTestsUrl+r""") (click "Shown Matching Output" in upper right) the tests:

"""

  for testname in testnameList:
    issueTrackerText += "* `"+testname+"`\n"

  issueTrackerText += \
r"""
in the builds:

"""

  for buildname in buildnameList:
    issueTrackerText += "* `"+buildname+"`\n"

  issueTrackerText += \
r"""
started failing on testing day """+testingDayStartNonpassingDate+r""".


## Current Status on CDash

Run the [above query]("""+nonpassingTestsUrl+r""") adjusting the "Begin" and "End" dates to match today any other date range or just click "CURRENT" in the top bar to see results for the current testing day.
"""

# NOTE: ABOVE: It is important to keep entire paragraphs on one line.
# Otherwise, GitHub will show the line-breaks and it looks terrible.

  return issueTrackerText

# END FUNCTION: getGithubIssueBodyMarkdown()


################################################################################
#
# EVERYTHING BELOW HERE SHOULD NEED TO BE MODIFIED
#
################################################################################


# Class implementation of callback to fill in the new ATDM Trilinos GitHub
# issue.
#
class ExampleIssueTrackerCreatorAndFormatter:


  def __init__(self):
    self.issueTrackerText = None


  def acceptIssueTrackerData(self, summaryLine, testingDayStartNonpassingDate,
      nonpassingTestsUrl, uniqNonpassingTestsLOD,  buildnameList, testnameList,
      testHistoryHtmlTableText,
    ):
    self.issueTrackerText = \
      getGithubIssueBodyMarkdown(
        summaryLine=summaryLine,
        testingDayStartNonpassingDate=testingDayStartNonpassingDate,
        nonpassingTestsUrl=nonpassingTestsUrl,
        uniqNonpassingTestsLOD=uniqNonpassingTestsLOD,
        buildnameList=buildnameList,
        testnameList=testnameList,
        testHistoryHtmlTableText=testHistoryHtmlTableText,
        )


  def getIssueTrackerText(self):
    return self.issueTrackerText

#
# Execute main if this is being run as a script
#

if __name__ == '__main__':
  sys.exit(main())

