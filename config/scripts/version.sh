#!/bin/sh

UNICON_VERSION=13.3
UNICON_VERSION_DATE="December 22, 2020"

# Interested in version only
if [ "x$1" = "xversion"  ]; then
    echo $UNICON_VERSION
    exit 0
fi

# cd to top level directory
SCRIPT_DIR=`dirname "$0"`
cd $SCRIPT_DIR/../..

REV_FILE=./src/h/revision.h

# If we have .git directory let us assume we are in tree
if [ -d .git ]; then
  UNICON_VERSION_DATE=`LC_ALL=C git log -1 --format=%cd --date=format:'%B %d, %Y'`
  REPO_REV_DESCR=`git describe --long --always --dirty='-modified'`
  REPO_REV_BRANCH=`git rev-parse --abbrev-ref HEAD | sed -e 's!heads/!!'`
  REPO_REV_COUNT=`git rev-list --first-parent --count HEAD`
  REPO_REV_HASH=`git rev-parse --short HEAD`
  REPO_REV=${REPO_REV_COUNT}_${REPO_REV_HASH}
    
  if test ! -z ${REPO_REV} ; then 
      echo "#define REPO_REVISION \"${REPO_REV}\"" > $REV_FILE
  elif test ! -f $REV_FILE ; then
      echo "#define REPO_REVISION \"0\"" > $REV_FILE
  fi

  if test -z ${REPO_REV_DESCR} ; then 
      echo "#define gitDescription \"commit ${REPO_REV_HASH}\"" >> $REV_FILE
  else
      echo "#define gitDescription \"${REPO_REV_DESCR}\"" >> $REV_FILE
  fi

  echo "#define gitBranch \"${REPO_REV_BRANCH}\"" >> $REV_FILE
  echo "#define UNICON_VERSION \"${UNICON_VERSION}\"" >> $REV_FILE
  echo "#define UNICON_VERSION_DATE \"${UNICON_VERSION_DATE}\"" >> $REV_FILE

else # not under git revision control

  # fallback: no git, and no revision file
  if test ! -f $REV_FILE ; then
      echo "#define REPO_REVISION \"0\"" > $REV_FILE
      echo "#define gitDescription \"commit 0\"" >> $REV_FILE
      echo "#define gitBranch \"0\"" >> $REV_FILE
      echo "#define UNICON_VERSION \"${UNICON_VERSION}\"" >> $REV_FILE
      echo "#define UNICON_VERSION_DATE \"${UNICON_VERSION_DATE}\"" >> $REV_FILE
  fi 

  REPO_REV=`cat src/h/revision.h | sed -n -e 's/^.*REPO_REVISION //p'`
  
fi

# Interested in version only
if [ "x$1" = "xrevision"  ]; then
    echo $REPO_REV
    exit 0
fi

