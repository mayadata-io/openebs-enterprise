#!/bin/bash

# This script helps to sync (rebase) 
# enterprise release branch with community 
# release branch.
#
# Prior to running this script setup-enterprise-branches.sh
# should be executed and confirm that release
# branches are available.

usage()
{
	echo "Usage: $0 <community release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

REL_BRANCH=$1

sync_upstream_branch()
{
  ./sync-upstream-branch $1 $2
}

rebase_rel_branch()
{
  ./rebase-forked-repo-branch $1 $2
}

REPO_LIST=$(cat openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    sync_upstream_branch ${REPO} master
    sync_upstream_branch ${REPO} ${REL_BRANCH}
    rebase_rel_branch ${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
ALPHA_REPO_LIST=$(cat  openebs-alpha-repos.txt |tr "\n" " ")
for REPOWITHBRANCH in $ALPHA_REPO_LIST
do
  ALPHAREPO=$(echo ${REPOWITHBRANCH} | cut -d ':' -f1)
  ALPHABRANCH=$(echo ${REPOWITHBRANCH} | cut -d ':' -f2)
  if [[ $ALPHAREPO =~ ^# ]]; then
    echo "Skipping ${ALPHAREPO}"
  else
    if [ "$ALPHABRANCH" == "master" ] ; then
      echo "Skipping $ALPHAREPO which has only master branch"
      sync_upstream_branch ${ALPHAREPO} master
    else
      sync_upstream_branch ${ALPHAREPO} master
      sync_upstream_branch ${ALPHAREPO} ${ALPHABRANCH}
      rebase_rel_branch ${ALPHAREPO} ${ALPHABRANCH}
    fi
  fi
done

#The following repositories master branch is
#unconventional
sync_upstream_branch cstor develop
sync_upstream_branch istgt replication
sync_upstream_branch external-storage release
