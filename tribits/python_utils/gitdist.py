#!/usr/bin/env python


#
# Pieces of the --help documentation
#


distRepoStatusLegend = r"""Legend:
* ID: Repository ID, zero based (order git commands are run)
* Repo Dir: Relative to base repo (base repo shown first with '(Base)')
* Branch: Current branch (or detached HEAD)
* Tracking Branch: Tracking branch (or empty if no tracking branch exists)
* C: Number local commits w.r.t. tracking branch (empty if zero or no TB)
* M: Number of tracked modified (uncommitted) files (empty if zero)
* ?: Number of untracked, non-ignored files (empty if zero)
"""


helpTopics = [
  'overview',
  'repo-selection-and-setup',
  'gitdist-options',
  'dist-repo-status',
  'repo-version-files',
  'aliases', 
  'usage-tips',
  'script-dependencies'
  ]

 
def getHelpTopicsStr():
  helpTopicStr = "" 
  for helpTopic in helpTopics:
    helpTopicStr += "* '" + helpTopic + "'\n"
  return helpTopicStr


# Look up help help string given keys from helpTopics array.
helpTopicDefaultIdx = 0;


helpTopicsDict = {}


helpUsageHeader = r"""gitdist [gitdist arguments] [git arguments]
       gitdist [gitdist arguments] dist-repo-status

Run git recursively over a set of git repos in a multi-repository git project.
This script also includes other tools like printing a repo status table (using
dist-repo-status) and tracking versions through multi-repository version files
(e.g. --dist-repo-version-file=RepoVersion.txt).
"""


overviewHelp = r"""
OVERVIEW:

Running:

  $ gitdist [gitdist options] [git arguments]

will distribute git commands specified by [git arguments] across the current
base git repo and the set of git repos as listed in the file ./.gitdist (or
./.gitdist.default, or --dist-extra-repos=<repo0>,<repo1>,..., see
--help-topic=repo-selection-and-setup).

For example, consider the following base git repo 'BaseRepo' with other git
repos cloned under it:

  BaseRepo/
    .git/
    .gitdist
    ExtraRepo1/
      .git/
    ExtraRepo2/
      .git/

The file .gitdist shown above is created by the user and in this example
should have the contents:

  ExtraRepo1
  ExtraRepo2

For this example, running the command:

  $ gitdist status

in 'BaseRepo/' produces the equivalent commands:

  $ git status
  $ cd ExtraRepo1/ ; git status ; ../
  $ cd ExtraRepo2/ ; git status ; ../

The gitdist tool allows managing a set of git repos like one big continuously
integrated git repo.  For example, after cloning a set of git repos, one can
perform basic operations like for single git repos like creating a new release
branch and pushing it with:

  $ gitdist checkout master
  $ gitdist pull
  $ gitdist tag -a -m "Start of the 2.3 release" release-2.3-start
  $ gitdist checkout -b release-2.3 release-2.3-start
  $ gitdist push origin release-2.3-start
  $ gitdist push origin -u release 2.3
  $ gitdist checkout master

The above command creates the same tag 'release-2.3-start' and the same branch
'release-2.3' in all of the local git repos and pushes these to the 'origin'
remote repo for each repo.

For more information about a certain topic, use --help
--help-topic=<topic-name> for <topic-name>=
"""+getHelpTopicsStr()+r"""
To see full help with all topics, use --help-topic=all.

This script is self-contained and has no dependencies other than standard
python 2.6 packages so it can be copied to anywhere and used.
"""
helpTopicsDict.update( { 'overview' : overviewHelp } )


repoSelectionAndSetupHelp = r"""
REPO SELECTION AND SETUP:

Before using the gitdist tool, one will want to set up some useful aliases for
the user's hell like 'gitdist-status', 'gitdist-mod', and 'gitdist-mod-status'
(see --help-topic=aliases).

The set of git repos processed by gitdist is determined by the argument:

  --dist-extra-repos=<repo0>,<repo1>,...

or the files .gitdist or .gitdist.default.  If --dist-extra-repos="", then the
list of extra repos will be read from the file '.gitdist' in the current
working directory.  If the file '.gitdist' does not exist, then the list of
extra repos will be read from the file '.gitdist.default' in the current
working directory.  The format of this files '.gitdist' and '.gitdist.default'
is to have one repo directory/name per line as in the 'BaseRepo' example:

  ExtraRepo1
  ExtraRepo2

where each repo is the relative path to the repo under the base git repo
(e.g. under 'BaseRepo/').  The file .gitdist.default is meant to be committed
to the base git repo so that gitdist is ready to use right away after the
extra repos are cloned.

If a specified extra repository directory (i.e. listed in
--dist-extra-repos=<repo0>,<repo1>,..., .gitdist, or .gitdist.default) does
not exist, then it will be ignored by the script.  Therefore, be careful to
manually verify that the script recognizes the repositories that you list.
The best way to do that is to run 'gitdist dist-repo-status' and see which
repos are listed.

Certain git repos can also be selectively excluded using the options
--dist-not-base-repo and --dist-not-extra-repos=<repox>,<repoy>,...

Setting up to use gitdist requires first setting up and organizing the local
git clones. For the example listed here, one would clone the base repo
'BaseRepo', then clone the two extra git repos like 'ExtraRepo1' and
'ExtraRepo2' and then set up a .gitdist file like:

  $ git clone git@some.url:BaseRepo.git
  $ cd BaseRepo/
  $ git clone git@some.url:ExtraRepo1.git
  $ git clone git@some.url:ExtraRepo2.git
  $ echo ExtraRepo1 > .gitdist
  $ echo ExtraRepo2 >> .gitdist

This produces the repo structure:

  BaseRepo/
    .git/
    .gitdist
    ExtraRepo1/
      .git/
    ExtraRepo2/
      .git/

After that setup, running:

  $ gitdist [git command and options]

in the 'BaseRepo/ 'directory will automatically distribute the commands across
the repos ExtraRepo1 and ExtraRepo2.

To simplify the setup of gitdist, one may choose to instead create the file
.gitdist.default in the base repo and commit that file to the BaseRepo git
repo.  That way, one does not have to manually create the .gitdist file in
every new local clone of the repos.  But if the file BaseRepo/.gitdist is
present, then it will override the file .gitdist.default.
"""
helpTopicsDict.update( { 'repo-selection-and-setup' : repoSelectionAndSetupHelp } )


gitdistOptionsHelp = r"""
GITDIST OPTIONS:

The options in [gitdist options] are prefixed with '--dist-' and are pulled
out before passing the remaining arguments in [git arguments] to git for each
processed git repo.  See --help for the list of [gitdist options].
"""
helpTopicsDict.update( { 'gitdist-options' : gitdistOptionsHelp } )


distRepoStatusHelp = r"""
SUMMARY OF REPO STATUS:

This script supports the special command 'dist-repo-status' which prints a
table showing the current status of all the repos (see alias 'gitdist-status'
in --help-topic=aliases).  For the example set of repos shown in OVERVIEW (see
--help-topic=overview), running:

  $ gitdist dist-repo-status    # alias 'gitdist-status'

prints a table like:

  ----------------------------------------------------------------
  | ID | Repo Dir        | Branch | Tracking Branch | C | M  | ? |
  |----|-----------------|--------|-----------------|---|----|---|
  |  0 | BaseRepo (Base) | dummy  |                 |   |    |   |
  |  1 | ExtraRepo1      | master | origin/master   | 1 |  2 |   |
  |  2 | ExtraRepo2      | HEAD   |                 |   | 25 | 4 |
  ----------------------------------------------------------------

If the option --dist-legend is passed in, it will print the legend:

"""+distRepoStatusLegend+\
r"""
One can also show the status of only changed repos with the command:

  $ gitdist dist-repo-status --dist-mod-only  # gitdist-mod-status

which prints a table like:

  ----------------------------------------------------------------
  | ID | Repo Dir        | Branch | Tracking Branch | C | M  | ? |
  |----|-----------------|--------|-----------------|---|----|---|
  |  1 | ExtraRepo1      | master | origin/master   | 1 |  2 |   |
  |  2 | ExtraRepo2      | HEAD   |                 |   | 25 | 4 |
  ----------------------------------------------------------------

(see the alias 'gitdist-mod-status' in --help-topic=aliases).

Note that the base repo was left out but the repo indexes are the same.  This
allows one to compactly show the status of changes of the changed repos even
when there are many git repos by filtering out rows for repos that have no
changes w.r.t. their tracking branches.  This allows one to get the status on
a few repos with changes out of a large number of repos (i.e. 10s to 100s of
repos).
"""
helpTopicsDict.update( { 'dist-repo-status' : distRepoStatusHelp } )


repoVersionFilesHelp = r"""
REPO VERSION FILES:

This script supports the options --dist-version-file=<versionFile> and
--dist-version-file2=<versionFile2> which are used to provide different SHA1
versions for each repo.  Each of these version files is expected to represent
a compatible set of versions of the repos.

The format of these repo version files is shown in the following example:

-----------------------------------------------------
*** Base Git Repo: BaseRepo
e102e27 [Mon Sep 23 11:34:59 2013 -0400] <author1@someurl.com>
First summary message
*** Git Repo: ExtraRepo1
b894b9c [Fri Aug 30 09:55:07 2013 -0400] <author2@someurl.com>
Second summary message
*** Git Repo: ExtraRepo2
97cf1ac [Thu Dec 1 23:34:06 2011 -0500] <author3@someurl.com>
Third summary message
-----------------------------------------------------

(the lines '---------' are *not* included in the file.)

Each repository entry can have a summary message or not (i.e. use two or three
lines per repo in the file).  A compatible repo version file can be generated
with this script listing three lines per repo (as shown above) using, for
example:

  $ gitdist --dist-no-color log -1 --pretty=format:"%h [%ad] <%ae>%n%s" \
    | grep -v "^$" &> RepoVersion.txt

or two lines per repo using, for example:

  $ gitdist --dist-no-color log -1 --pretty=format:"%h [%ad] <%ae>" \
    | grep -v "^$" &> RepoVersion.txt

This allows checking out consistent versions of the repos, diffing two
consistent versions of the repos, etc.

To checkout an older set of consistent versions of the set of repos
represented by the set of versions given in a file RepoVersion.<date>.txt,
use:

  $ gitdist fetch origin
  $ gitdist --dist-version-file=RepoVersion.<date>.txt checkout _VERSION_

The '_VERSION_' string is replaced with the SHA1 for each of the repos listed
in the file RepoVersion.<date>.txt.  (NOTE: this puts the repos into a
detached head state so one has to know what that means.)

To tag a set of repos using a consistent set of versions, use (for example):

  $ gitdist --dist-version-file=RepoVersion.<date>.txt \
      tag -a <some_tag> _VERSION_

To create a branch off of a consistent set of versions, use (for example):

  $ gitdist --dist-version-file=RepoVersion.<date>.txt \
      checkout -b some-branch _VERSION_

To diff two sets of versions of the repos, for example, use:

  $ gitdist --dist-version-file=RepoVersion.<new-date>.txt \
      --dist-version-file2=RepoVersion.<old-date>.txt \
      diff _VERSION_ ^_VERSION2_

Here, _VERSION_ is replaced by the SHA1s listed in RepoVersion.<new-date>.txt
and _VERSION2_ is replaced by the SHA1s listed in RepoVersion.<old-date>.txt.

One can construct any git command taking one or two different repo version
arguments (SHA1s) using this approach.

Note that the set of repos listed in the RepoVersion.txt file must be a
super-set of those processed by this script or an error will occur and the
script will stop.  If there are additional repos RepoX, RepoY, ... not listed
in the RepVersion.txt file one can exclude them with:

  $ gitdist --dist-not-extra-repos=RepoX,RepoY,... \
    --dist-version-file=RepoVersion.txt \
    [other arguments]
"""
helpTopicsDict.update( { 'repo-version-files' : repoVersionFilesHelp } )


usefulAliasesHelp =r"""
USEFUL ALIASES:

A few very useful (bash) shell aliases to use along with the gitdist script
are:

  $ alias gitdist-status="gitdist dist-repo-status"
  $ alias gitdist-mod="gitdist --dist-mod-only"
  $ alias gitdist-mod-status="gitdist dist-repo-status --dist-mod-only"

This avoids lots of extra typing as these gitdist arguments are used a lot.
For example, to see the status table of all your repos, do:

  $ gitdist-status

To just see the status table of changed repos only, do:

  $ gitdist-mod-status

To process only repos that have changes and see commits in these repos
w.r.t. their tracking branches, use (for example):

  $ gitdist-mod log --name-status HEAD ^@{u}

or

  $ gitdist-mod local-stat

(where 'local-stat' is a useful git alias defined in the script
'git-config-alias.sh').
"""
helpTopicsDict.update( { 'aliases' : usefulAliasesHelp } )


usageTipsHelp = r"""
USAGE TIPS:

Since gitdist allows treating a set of git repos as one big git repo, almost
any git workflow that is used for a single git repo can be used for a set of
repos using gitdist.  The main difference is that one will typically need to
create commits individually for each repo.  Also, pulls and pushes are no
longer atomic like is guaranteed for a single git repo.

In general, the mapping between the commands for a single-repo git workflow
using raw git vs. a multi-repo git workflow using gitdist (using the shell
aliases 'gitdist-status', 'gitdist-mod-status', and 'gitdist-mod'; see
--help-topic=aliases) is given by:

  git pull                          =>  gitdist pull
  git checkout -b <branch> [<ref>]  =>  gitdist checkout -b <branch> [<ref>]
  git tag -a -m "<message>" <tag>   =>  gitdist tag -a -m "<message>" <tag>
  git status                        =>  gitdist-mod status  # status details
                                    =>  gitdist-status      # table for all
                                    =>  gitdist-mod-status  # table for mod.
  git commit                        =>  gitdist-mod commit
  git log HEAD ^@{u}                =>  gitdist-mod log HEAD ^@{u} 
  git push                          =>  gitdist-mod push
  git push [-u] <remote> <branch>   =>  gitdist push [-u] <remote> <branch>
  git push <remote> <tag>           =>  gitdist push <remote> <tag>

NOTE: The usage of 'gitdist-mod' can be replaced with just 'gitdist' in all of
the above commands.  It is just that in these cases gitdist-mod produces more
compact output and avoids do-nothing commands for repos that have no changes
with respect to their tracking branch.  But when it doubt, just use raw
'gitdist' if you are confused.

A typical development iteration of the centralized workflow using using
multiple git repos looks like the following:

1) Update the local branches from the remote tracking branches:

    $ cd BaseRepo/
    $ gitdist pull

2) Make local modifications for each repo:

    $ emacs <base-files>
    $ cd ExtraRepo1/
    $ emacs <files-in-extra-repo1>
    $ cd ..
    $ cd ExtraRepo2/
    $ emacs <files-in-extra-repo2>
    $ cd ..

3) Build and test local modifications:

    $ cd BUILD/
    $ make -j16
    $ make test  # hopefully all pass!
    $ cd ..

4) View the modifications before committing:

    $ gitdist-mod-status   # Produces a summary table
    $ gitdist-mod status   # See status details

5) Make commits to each repo:

    $ gitdist-mod commit -a  # Opens editor for each repo in order

  or use the same commit message for all repos:

    $ emacs commitmsg.txt
    $ echo /commitmsg.txt >> .git/info/exclude
    $ gitdist-mod commit -a -F $PWD/commitmsg.txt

  or manually create the commits in each repo separately with raw git:

    $ git commit -a
    $ cd ExtraRepo1/
    $ git commit -a
    $ cd ..
    $ cd ExtraRepo2/
    $ git commit -a
    $ cd ..

6) Examine the local commits that are about to be pushed:

    $ gitdist-mod-status  # Should be no unmodified or untracked files!
    $ gitdist-mod log --name-status HEAD ^@{u}

7) Rebase and push local commits to remote tracking branch:

    $ gitdist pull --rebase
    $ gitdist-mod push
    $ gitdist-mod-status   # Make sure all the pushes occurred!

Another example workflow is creating a new release branch as shown in the
OVERVIEW section (--help-topic=overview).

Other usage tips:

 - 'gitdist --help' will run gitdist help, not git help.  If you want raw git
   help, then run 'git --help'.

 - Be sure to run 'gitdist-status' to make sure that each repo is on the
   correct local branch and is tracking the correct remote branch.

 - In general, for most workflows, one should use the local branch name,
   remote repo name, and remote tracking branch name.

 - For many git commands, it is better to process only repos that are changed
   w.r.t. their tracking branch with 'gitdist-mod [git arguments]'.  For
   example, to see the status of only changed repos use 'gitdist-mod status'.

 - A few different types of git commands tend to be run on all the git repos
    like 'gitdist pull', 'gitdist checkout', and 'gitdist tag'.
"""
helpTopicsDict.update( { 'usage-tips' : usageTipsHelp } )


scriptDependenciesHelp = r"""
SCRIPT DEPENDENCIES:

This Python script only depends on the Python 2.6+ standard modules 'sys',
'os', 'subprocess', and 're'. Also, of course, it requires some compatible
version of 'git' in your path.
"""
helpTopicsDict.update( { 'script-dependencies' : scriptDependenciesHelp } )


#
# Functions to help Format an ASCII table
#


# Fill in a field
def getTableField(field, width, just):
  if just == "R":
    return " "+field.rjust(width)+" |"
  return " "+field.ljust(width)+" |"


# Format an ASCII table from a set of fields
#
# The format is of tableData input is:
#
#   [ { "label":"<label0>:, "align":"<align0>, "fields":[<fld00>, ... ]}, 
#     { "label":"<label1>:, "align":"<align1>, "fields":[<fld10>, ... ]},
#     ...
#     ]
#
# The "algin" field is either "R" for right, or "L" for left.
#
def createAsciiTable(tableData):

  asciiTable = ""

  # Table size
  numFields = len(tableData)
  numRows = len(tableData[0]["fields"])

  # a) Get the max field width for each column.
  fullTableWidth = 1  # The left '|'
  tableFieldWidth = []
  for fieldDict in tableData:
    label = fieldDict["label"]
    maxFieldWidth = len(label)
    if len(fieldDict["fields"]) != numRows:
      raise Exception("Error: column '"+label+"' numfields = " + \
        str(len(fieldDict["fields"])) + " != numRows = "+str(numRows)+"\n" )
    for field in fieldDict["fields"]:
      fieldWidth = len(field)
      if fieldWidth > maxFieldWidth: maxFieldWidth = fieldWidth 
    fullTableWidth += (maxFieldWidth + 3) # begin " ", end " ", '|'
    tableFieldWidth.append(maxFieldWidth)

  # b) Write the header of the table (always left-align the colume labels)
  asciiTable += ('-'*fullTableWidth)+"\n"
  asciiTable += "|"
  fieldIdx = 0
  for fieldDict in tableData:
    asciiTable += getTableField(fieldDict["label"], tableFieldWidth[fieldIdx], "L")
    fieldIdx += 1
  asciiTable += "\n"
  asciiTable += "|"
  for field_i in range(numFields):
    asciiTable += ('-'*(tableFieldWidth[field_i]+2))+"|"
    fieldIdx += 1
  asciiTable += "\n"

  # c) Write each row of the table
  for row_i in range(numRows):
    asciiTable += "|"
    field_i = 0
    for fieldDict in tableData:
      asciiTable += getTableField(fieldDict["fields"][row_i],
        tableFieldWidth[field_i], fieldDict["align"] )
      field_i += 1
    asciiTable += "\n"
  asciiTable += ('-'*fullTableWidth)+"\n"
  
  return asciiTable


#
# Helper functions for gitdist
#

import sys
import os
import subprocess
import re

from optparse import OptionParser

def addOptionParserChoiceOption(
  optionName,
  optionDest,
  choiceOptions,
  defaultChoiceIndex,
  helpStr,
  optionParser
  ):
  """ Add a general choice option to a optparse.OptionParser object"""
  defaultOptionValue = choiceOptions[defaultChoiceIndex]
  optionParser.add_option(
    optionName,
    dest=optionDest,
    type="choice",
    choices=choiceOptions,
    default=defaultOptionValue,
    help='%s Choices = (\'%s\').  [default = \'%s\']'
    % (helpStr, '\', \''.join(choiceOptions), defaultOptionValue)
    )


def getUsageHelpStr(helpTopicArg):
  #print "helpTopicArg =", helpTopicArg
  usageHelpStr = helpUsageHeader
  if helpTopicArg == "":
    usageHelpStr += helpTopicsDict.get(helpTopics[helpTopicDefaultIdx])
  else:
    helpTopicArgArray = helpTopicArg.split("=")
    if len(helpTopicArgArray) == 1:
      # Option not formatted correctly, set let error hander get it."
      return ""
    (helpTopicArgName, helpTopicVal) = helpTopicArg.split("=")
    #print "helpTopicArgName =", helpTopicArgName
    if helpTopicVal == "all":
      for helpTopic in helpTopics:
        usageHelpStr += helpTopicsDict.get(helpTopic)
    elif helpTopicVal == "":
      None  # Don't show any help topic
    else:
      helpTopicHelpStr = helpTopicsDict.get(helpTopicVal, None)
      if helpTopicHelpStr:
        usageHelpStr += helpTopicHelpStr
      else:
        # Invalid help topic so return just the error:
        return ""
  return usageHelpStr

def filterWarningsGen(lines): 
  for line in lines:
    if not line.startswith('warning') and not line.startswith('error'): yield line


# Filter warning and error lines from output
def filterWarnings(lines): 
  g = filterWarningsGen(lines)
  if g is not None: 
    return list(g)
  return g


# Get output from command
def getCmndOutput(cmnd, rtnCode=False):
  child = subprocess.Popen(cmnd, shell=True, stdout=subprocess.PIPE,
    stderr = subprocess.STDOUT)
  output = child.stdout.read()
  child.wait()
  if rtnCode:
    return (output, child.returncode)
  return output


# Run a command and syncronize the output
def runCmnd(options, cmnd):
  if options.debug:
    print "*** Running command:", cmnd
  if options.noOpt:
    print cmnd
  else:
    child = subprocess.Popen(cmnd, stdout=subprocess.PIPE).stdout
    output = child.read()
    sys.stdout.flush()
    print output
    sys.stdout.flush()


# Determine if a command exists:
def commandExists(cmnd):
  whichCmnd = getCmndOutput("which "+cmnd).strip()
  #print "whichCmnd =", whichCmnd
  if os.path.exists(whichCmnd):
    return True
  return False


# Get the terminal colors
txtbld=getCmndOutput(r"tput bold")       # Bold
txtblu=getCmndOutput(r"tput setaf 4")    # Blue
txtred=getCmndOutput(r"tput setaf 1")    # Red
txtrst=getCmndOutput(r"tput sgr0")       # Text reset


# Add color to the repo dirs printed out
def addColorToRepoDir(useColor, strIn):
  if useColor:
    return txtbld+txtblu+strIn+txtrst
  return strIn


# Add color to the error messages printed out
def addColorToErrorMsg(useColor, strIn):
  if useColor:
    return txtred+strIn+txtrst
  return strIn


# Get the commandline options
def getCommandlineOps():

  #
  # A) Define the native gitdist command-line arguments
  #

  helpTopicArgName = "--help-topic" # Must match --help-topic before --help!
  helpArgName = "--help"
  withGitArgName = "--dist-use-git"
  extraRepoArgName = "--dist-extra-repos"
  notExtraRepoArgName = "--dist-not-extra-repos"
  notBaseRepoArgName = "--dist-not-base-repo"
  versionFileName = "--dist-version-file"
  versionFile2Name = "--dist-version-file2"
  noColorArgName = "--dist-no-color"
  debugArgName = "--dist-debug"
  noOptName = "--dist-no-opt"
  modifiedOnlyName = "--dist-mod-only"
  legendName = "--dist-legend"

  nativeArgNames = [ helpTopicArgName, helpArgName, withGitArgName, \
    extraRepoArgName, notExtraRepoArgName, notBaseRepoArgName, \
    versionFileName, versionFile2Name, noColorArgName, debugArgName, noOptName, \
    modifiedOnlyName, legendName ]

  distRepoStatus = "dist-repo-status"
  nativeCmndNames = [ distRepoStatus ]

  # Select a version of git (see above help documentation)
  defaultGit = "git" # Try system git
  if not commandExists(defaultGit):
    defaultGit = "" # Give up and make the user specify

  #
  # B) Pull the native commandline arguments out of the commandline
  #

  argv = sys.argv[1:]
  nativeArgs = []
  nativeCmnds = []
  otherArgs = []
  helpTopicArg = "" 

  for arg in argv:
    #print "\narg = '"+arg+"'"
    matchedNativeArg = False
    for nativeArgName in nativeArgNames:
      #print "\nnativeArgName ='"+nativeArgName+"'"
      currentArgName = arg[0:len(nativeArgName)]
      #print "currentArgName = '"+currentArgName+"'"
      if currentArgName == nativeArgName:
        #print "\nMatches native arg!"
        nativeArgs.append(arg)
        matchedNativeArg = True
        if currentArgName == helpTopicArgName:
          helpTopicArg = arg
        break
    matchedNativeCmnd = False
    for nativeCmndName in nativeCmndNames:
      if arg == nativeCmndName:
        #print "\nMatches native cmnd!"
        nativeCmnds.append(nativeCmndName)
        matchedNativeCmnd = True
        break
    if not (matchedNativeArg or matchedNativeCmnd):
      #print "\nDoes *not* match native arg!"
      otherArgs.append(arg)
    #print "\nnativeArgs =", nativeArgs
    #print "otherArgs =", otherArgs

  #print "\nnativeArgs =", nativeArgs
  #print "nativeCmnds =", nativeCmnds
  #print "otherArgs =", otherArgs

  if len(nativeCmnds) == 0:
    nativeCmnd = None
  elif len(nativeCmnds) == 1:
    nativeCmnd = nativeCmnds[0]
  elif len(nativeCmnds) > 1:
    raise Exception("Error: Can't have more than one dist-xxx command "+\
      " but was passed in "+str(nativeCmnds))

  #
  # C) Set up the commandline parser and parse the native args
  #

  usageHelp = getUsageHelpStr(helpTopicArg)

  clp = OptionParser(usage=usageHelp)

  addOptionParserChoiceOption(
    helpTopicArgName, "helpTopic", helpTopics+["all", ""], 0,
    "Print help topic with --help --help-topic=HELPTOPIC.  Using" \
    +" --help-topic=all --help prints all help topics.  Has no effect if" \
    +" --help is not also given." ,
    clp )

  clp.add_option(
    withGitArgName, dest="useGit", type="string",
    default=defaultGit,
    help="The (path) to the git executable to use for each git repo command."
    +"  By default, gitdist will use 'git' in the environment.  If it can't find"
    +" 'git' in the environment, then it will require setting"
    +" --dist-use-git=<git command> (which is typically only  used in automated"
    +" testing). (default='"+defaultGit+"')"
    )

  clp.add_option(
    extraRepoArgName, dest="extraRepos", type="string",
    default="",
    help="Comma-separated list of extra repos to forward git commands to."
    +"  If the list is empty, it will look for a file called .gitdist to"
    +" get the list of extra repos separated by newlines."
    )

  clp.add_option(
    notExtraRepoArgName, dest="notExtraRepos", type="string",
    default="",
    help="Comma separated list of extra repos to *not* forward git commands to."
    +"  This removes any repos from being processed that would otherwise be."
    )

  clp.add_option(
    notBaseRepoArgName, dest="processBaseRepo", action="store_false",
    help="If set, don't pass the git command on to the base git repo.",
    default=True )

  clp.add_option(
    versionFileName, dest="versionFile", type="string",
    default="",
    help="Path to a file contains a list of extra repo directories and git versions (replaces _VERSION_)."
    )

  clp.add_option(
    versionFile2Name, dest="versionFile2", type="string",
    default="",
    help="Path to a second file contains a list of extra repo directories and git versions (replaces _VERSION2_)."
    )

  clp.add_option(
    noColorArgName, dest="useColor", action="store_false",
    help="If set, don't use color in the output for gitdist (better for output to a file).",
    default=True )

  clp.add_option(
    debugArgName, dest="debug", action="store_true",
    help="If set, then debugging info is printed.",
    default=False )

  clp.add_option(
    noOptName, dest="noOpt", action="store_true",
    help="If set, then no git commands will be run but instead will just be printed.",
    default=False )

  clp.add_option(
    modifiedOnlyName, dest="modifiedOnly", action="store_true",
    help="If set, then the listed git command will be only be run and output for the" \
      " repo will only be produced if the command 'git diff --name-only ^<tracking-branch>'"
      " returns non-empty output where <tracking-branch> is returned" \
      " from 'rev-parse --abbrev-ref --symbolic-full-name @{u}'.  In order words," \
      " if a git repo is unchanged w.r.t. its tracking branch, then the git command is" \
      " skipped for that repo.  If a repo does not have a tracking branch, then the repo will" \
      " be skipped as well.  Therefore, be careful to first run with dist-repo-status to see the" \
      " status of each local repo to know which repos don't have tracking branches.",
    default=False )

  clp.add_option(
    legendName, dest="printLegend", action="store_true",
    help="If set, then a legend will be printed below the repo summary table"\
      " for the special dist-repo-status command.  Only applicable with dist-repo-status.",
    default=False )

  (options, args) = clp.parse_args(nativeArgs)

  debugFromEnv = os.environ.get("GITDIST_DEBUG_OVERRIDE")
  if debugFromEnv:
    options.debug = True

  #
  # D) Check for valid usage
  #

  if not nativeCmnd and len(otherArgs) == 0:
    print addColorToErrorMsg(options.useColor,
      "Must specify git command. See 'git --help' for options.")
    sys.exit(1)

  if not options.useGit:
    print addColorToErrorMsg(options.useColor,
      "Can't find git, please set --dist-use-git")
    sys.exit(1)

  #
  # E) Get the list of extra repos
  #

  if options.extraRepos:
    extraReposFullList = options.extraRepos.split(",")
  else:
    if os.path.exists(".gitdist"):
      gitdistfile = ".gitdist"
    elif os.path.exists(".gitdist.default"):
      gitdistfile = ".gitdist.default"
    else:
      gitdistfile = None
    if gitdistfile:
      extraReposFullList = open(gitdistfile, 'r').read().split()
    else:
      extraReposFullList = []

  # Get list of not extra repos

  if options.notExtraRepos:
    notExtraReposFullList = options.notExtraRepos.split(",")
  else:
    notExtraReposFullList = []

  return (options, nativeCmnd, otherArgs, extraReposFullList,
    notExtraReposFullList)


# Requote commandline arguments into an array
def requoteCmndLineArgsIntoArray(inArgs):
  argsArray = []
  for arg in inArgs:
    splitArg = arg.split("=")
    newArg = None
    if len(splitArg) == 1:
      newArg = arg
    else:
      newArg = splitArg[0]+"="+'='.join(splitArg[1:])
    #print "\nnewArg =", newArg
    argsArray.append(newArg)
  return argsArray


# Get a data-structure for a set of repos from a string
def getRepoVersionDictFromRepoVersionFileString(repoVersionFileStr):
  repoVersionFileStrList = repoVersionFileStr.splitlines()
  repoVersionDict = {}
  len_repoVersionFileStrList = len(repoVersionFileStrList)
  i = 0
  while i < len_repoVersionFileStrList:
    #print "i = ", i
    repoDirLine = repoVersionFileStrList[i]
    #print "repoDirLine = '"+repoDirLine+"'"
    if repoDirLine[0:3] == "***":
      repoDir = repoDirLine.split(":")[1].strip()
      #print "repoDir = '"+repoDir+"'"
      repoVersionLine = repoVersionFileStrList[i+1]
      #print "repoVersionLine = '"+repoVersionLine+"'"
      repoSha1 = repoVersionLine.split(" ")[0].strip()
      #print "repoSha1 = '"+repoSha1+"'"
      repoVersionDict.update({repoDir : repoSha1})
    else:
      break
    nextRepoNoSummary_i = i+2
    if nextRepoNoSummary_i >= len_repoVersionFileStrList:
      break
    if repoVersionFileStrList[nextRepoNoSummary_i][0:3] == "***":
      # Has no summary line
      i = i + 2
    else:
      # Has a summary line
      i = i + 3
  return repoVersionDict


# Get a data-structure for a set of repos from a file
def getRepoVersionDictFromRepoVersionFile(repoVersionFileName):
  if repoVersionFileName:
    repoVersionFileStr = open(repoVersionFileName, 'r').read()
    return getRepoVersionDictFromRepoVersionFileString(repoVersionFileStr)
  else:
    None


def assertAndGetRepoVersionFromDict(repoDirName, repoVersionDict):
  if repoVersionDict:
    repoSha1 = repoVersionDict.get(repoDirName, "")
    if not repoSha1:
      print addColorToErrorMsg(options.useColor,
        "Extra repo '"+repoDirName+"' is not in the list of extra repos "+\
        str(repoVersionDict.keys()[1:])+" read in from version file.")
      sys.exit(3)
    return repoSha1
  else:
    return ""


def replaceRepoVersionInCmndLineArg(cmndLineArg, verToken, repoDirName, repoSha1):
  if repoSha1:
    newCmndLineArg = re.sub(verToken, repoSha1, cmndLineArg)
    return newCmndLineArg
  return cmndLineArg


def replaceRepoVersionInCmndLineArgs(cmndLineArgsArray, repoDirName, \
  repoVersionDict, repoVersionDict2 \
  ):
  #print "repoDirName =", repoDirName
  repoSha1 = assertAndGetRepoVersionFromDict(repoDirName, repoVersionDict)
  repoSha1_2 = assertAndGetRepoVersionFromDict(repoDirName, repoVersionDict2)
  #print "repoSha1 =", repoSha1
  #print "repoSha1_2 =", repoSha1_2
  cmndLineArgsArrayRepo = []
  for cmndLineArg in cmndLineArgsArray:
    #print "cmndLineArg =", cmndLineArg
    newCmndLineArg = replaceRepoVersionInCmndLineArg(cmndLineArg, \
      "_VERSION_", repoDirName, repoSha1)
    #print "newCmndLineArg =", newCmndLineArg
    newCmndLineArg = replaceRepoVersionInCmndLineArg(newCmndLineArg, \
      "_VERSION2_", repoDirName, repoSha1_2)
    #print "newCmndLineArg =", newCmndLineArg
    cmndLineArgsArrayRepo.append(newCmndLineArg)
  return cmndLineArgsArrayRepo


# Generate the command line arguments
def runRepoCmnd(options, cmndLineArgsArray, repoDirName, baseDir, \
  repoVersionDict, repoVersionDict2 \
  ):
  cmndLineArgsArryRepo = replaceRepoVersionInCmndLineArgs(cmndLineArgsArray, \
    repoDirName, repoVersionDict, repoVersionDict2)
  egCmndArray = [ options.useGit ] + cmndLineArgsArryRepo
  runCmnd(options, egCmndArray)


# Get the name of the base directory
def getBaseDirNameFromPath(dirPath):
  dirPathArray = dirPath.split("/")
  return dirPathArray[-1]


# Get the name of the base repo to insert into the table
def getBaseRepoTblName(baseRepoName):
  return baseRepoName+" (Base)"


# Determine if the extra repo should be processed or not
def repoExistsAndNotExcluded(options, extraRepo, notExtraReposList):
  if not os.path.isdir(extraRepo): return False
  if extraRepo in notExtraReposList: return False
  return True


# Get the tracking branch for a repo
def getLocalBranch(options, getCmndOutputFunc):
  (resp, rtnCode) = getCmndOutputFunc(
    options.useGit + " rev-parse --abbrev-ref HEAD",
    rtnCode=True )
  if rtnCode == 0:
    filteredLines = filterWarnings(resp.strip().splitlines())
    if filteredLines and len(filteredLines) > 0:
      localBranch = filteredLines[0].strip()
    else:
      localBranch = "<AMBIGUOUS-HEAD>"
    return localBranch
  return ""


# Get the tracking branch for a repo
def getTrackingBranch(options, getCmndOutputFunc):
  (trackingBranch, rtnCode) = getCmndOutputFunc(
    options.useGit + " rev-parse --abbrev-ref --symbolic-full-name @{u}",
    rtnCode=True )
  if rtnCode == 0:
    return trackingBranch.strip()
  return ""
  # Above, if the command failed, there is likely no tracking branch.
  # However, this could fail for other reasons so it is a little dangerous to
  # just fail and return "" but I don't know of another way to do this.


# Get number of commits as a str wr.t.t tracking branch
def getNumCommitsWrtTrackingBranch(options, trackingBranch, getCmndOutputFunc):
  if trackingBranch == "":
    return ""
  (summaryLines, rtnCode) = getCmndOutputFunc(
    options.useGit + " shortlog -s HEAD ^"+trackingBranch, rtnCode=True )
  if rtnCode != 0:
    raise Exception(summaryLines)
  numCommits = 0
  summaryLines = summaryLines.strip()
  if summaryLines:
    for summaryLine in filterWarnings(summaryLines.splitlines()):
      #print "summaryLine = '"+summaryLine+"'"
      numAuthorCommits = int(summaryLine.strip().split()[0].strip())
      #print "numAuthorCommits =", numAuthorCommits
      numCommits += numAuthorCommits
  return str(numCommits)
  # NOTE: Above, we would like to use 'git ref-list --count' but that is not
  # supported in older versions of git (at least not in 1.7.0.4).  Using 'git
  # shortlog -s' will return just one line per author so this is not likley to
  # return a lot of data and the cost of the python code to process this
  # should be insignificant compared to the process execution command.


def matchFieldOneOrTwo(findIdx):
  if findIdx == 0 or findIdx == 1:
    return True
  return False


# Get the number of modified
def getNumModifiedAndUntracked(options, getCmndOutputFunc):
  (rawStatusOutput, rtnCode) = getCmndOutputFunc(
    options.useGit + " status --porcelain", rtnCode=True )
  if rtnCode == 0:
    numModified = 0
    numUntracked = 0
    for line in rawStatusOutput.splitlines():
      if matchFieldOneOrTwo(line.find("M")):
        numModified += 1
      elif matchFieldOneOrTwo(line.find("A")):
        numModified += 1
      elif matchFieldOneOrTwo(line.find("D")):
        numModified += 1
      elif matchFieldOneOrTwo(line.find("T")):
        numModified += 1
      elif matchFieldOneOrTwo(line.find("U")):
        numModified += 1
      elif matchFieldOneOrTwo(line.find("R")):
        numModified += 1
      elif line.find("??") == 0:
        numUntracked += 1
    return (str(numModified), str(numUntracked))
  return ("", "")


#
# Get the repo statistics
#

class RepoStatsStruct:

  def __init__(self, branch, trackingBranch, numCommits, numModified, numUntracked):
    self.branch = branch
    self.trackingBranch = trackingBranch
    self.numCommits = numCommits
    self.numModified = numModified
    self.numUntracked = numUntracked

  def __str__(self):
    return "{" \
     "branch='"+self.branch+"'," \
     " trackingBranch='"+self.trackingBranch+"'," \
     " numCommits='"+self.numCommits+"'," \
     " numModified='"+self.numModified+"'," \
     " numUntracked='"+self.numUntracked+"'" \
     "}"

  def numCommitsInt(self):
    if self.numCommits == '': return 0
    return int(self.numCommits)

  def numModifiedInt(self):
    if self.numModified == '': return 0
    return int(self.numModified)

  def numUntrackedInt(self):
    if self.numUntracked == '': return 0
    return int(self.numUntracked)

  def hasLocalChanges(self):
    if self.numCommitsInt()+self.numModifiedInt()+self.numUntrackedInt() > 0:
      return True
    return False


def getRepoStats(options, getCmndOutputFunc=None):
  if not getCmndOutputFunc:
    getCmndOutputFunc = getCmndOutput
  branch = getLocalBranch(options, getCmndOutputFunc)
  trackingBranch = getTrackingBranch(options, getCmndOutputFunc)
  numCommits = getNumCommitsWrtTrackingBranch(options, trackingBranch, getCmndOutputFunc)
  (numModified, numUntracked) = getNumModifiedAndUntracked(options, getCmndOutputFunc)
  return RepoStatsStruct(branch, trackingBranch,
   numCommits, numModified, numUntracked)


def convertZeroStrToEmpty(strIn):
  if strIn == "0":
    return ""
  return strIn


class RepoStatTable:
  
  def __init__(self):
    self.tableData = [
      { "label" : "ID", "align" : "R", "fields" : [] },
      { "label" : "Repo Dir", "align" : "L", "fields" : [] },
      { "label" : "Branch", "align":"L", "fields" : [] },
      { "label" : "Tracking Branch", "align":"L", "fields" : [] },
      { "label" : "C", "align":"R", "fields" : [] },
      { "label" : "M", "align":"R", "fields" : [] },
      { "label" : "?", "align":"R", "fields" : [] },
      ]

  def insertRepoStat(self, repoDir, repoStat, repoID):
    self.tableData[0]["fields"].append(str(repoID))
    self.tableData[1]["fields"].append(repoDir)
    self.tableData[2]["fields"].append(repoStat.branch)
    self.tableData[3]["fields"].append(repoStat.trackingBranch)
    self.tableData[4]["fields"].append(convertZeroStrToEmpty(repoStat.numCommits))
    self.tableData[5]["fields"].append(convertZeroStrToEmpty(repoStat.numModified))
    self.tableData[6]["fields"].append(convertZeroStrToEmpty(repoStat.numUntracked))

  def getTableData(self):
    return self.tableData


#
# Run the script
#

if __name__ == '__main__':

  (options, nativeCmnd, otherArgs, extraReposFullList, notExtraReposList) = \
    getCommandlineOps()

  if nativeCmnd == "dist-repo-status":
    distRepoStatus = True
    if len(otherArgs) > 0:
      print "Error, passing in extra git commands/args =" \
        "'"+" ".join(otherArgs)+"' with special comamnd 'dist-repo-status" \
        " is not allowed!"
      sys.exit(1)
  else:
    distRepoStatus = False

  # Get the repo version files
  repoVersionDict = getRepoVersionDictFromRepoVersionFile(options.versionFile)
  repoVersionDict2 = getRepoVersionDictFromRepoVersionFile(options.versionFile2)

  # Reform the commandline arguments correctly
  #print "otherArgs =", otherArgs
  cmndLineArgsArray = requoteCmndLineArgsIntoArray(otherArgs)

  # Get the reference base directory
  baseDir = os.getcwd()

  if options.debug:
    print "*** Using git:", options.useGit

  # Get the name of the base repo
  baseRepoName = getBaseDirNameFromPath(baseDir)

  repoStatTable = RepoStatTable()

  # Compute base repo stats
  if options.modifiedOnly or distRepoStatus:
    baseRepoStats = getRepoStats(options)
  else:
    baseRepoStats = None

  # See if we should process the base repo or not
  processBaseRepo = True
  if not options.processBaseRepo:
    processBaseRepo = False
  elif options.modifiedOnly and not baseRepoStats.hasLocalChanges():
    processBaseRepo = False

  repoID = 0

  # Process the base git repo
  if processBaseRepo:
    if distRepoStatus:
      repoStatTable.insertRepoStat(getBaseRepoTblName(baseRepoName), baseRepoStats, repoID)
    else:
      print ""
      print "*** Base Git Repo: "+addColorToRepoDir(options.useColor, baseRepoName)
      if options.debug:
        print "*** Tracking branch for git repo" \
          " '"+baseRepoName+"' = '"+baseRepoStats.trackingBranch+"'"
      sys.stdout.flush()
      runRepoCmnd(options, cmndLineArgsArray, baseRepoName, baseDir,
        repoVersionDict, repoVersionDict2)

  repoID += 1

  for extraRepo in extraReposFullList:

    # Determine if we should process this extra repo
    processThisExtraRepo = True
    if not repoExistsAndNotExcluded(options, extraRepo, notExtraReposList):
      processThisExtraRepo = False
    if processThisExtraRepo:
      repoDoesExistsAndNotExcluded = True
      # cd into extrarepo dir
      if options.debug:
        print "\n*** Changing to directory "+extraRepo,
      os.chdir(extraRepo)
      # Get repo stats
      if options.modifiedOnly or distRepoStatus:
        extraRepoStats = getRepoStats(options)
      else:
        extraRepoStats = None
      # See if we should process based on --dist-mod-only
      if options.modifiedOnly and not extraRepoStats.hasLocalChanges():
         processThisExtraRepo = False
    else:
      repoDoesExistsAndNotExcluded = False

    # Process the extra repo
    if processThisExtraRepo:
      if distRepoStatus:
        repoStatTable.insertRepoStat(extraRepo, extraRepoStats, repoID)
        processThisExtraRepo = False
      else:
        print ""
        print "*** Git Repo: "+addColorToRepoDir(options.useColor, extraRepo)
        sys.stdout.flush()
        if options.debug:
          print "*** Tracking branch for git repo" \
           " '"+extraRepo+"' = '"+extraRepoStats.trackingBranch+"'"
        runRepoCmnd(options, cmndLineArgsArray, extraRepo, baseDir, \
          repoVersionDict, repoVersionDict2)
        if options.debug:
          print "*** Changing to directory "+baseDir

    if repoDoesExistsAndNotExcluded:
      repoID += 1

    os.chdir(baseDir)

  if distRepoStatus:
    print createAsciiTable(repoStatTable.getTableData())
    if options.printLegend:
      print distRepoStatusLegend
    else:
      print "(tip: to see a legend, pass in --dist-legend.)" 
  else:
    print ""

  sys.stdout.flush()

