#!/bin/bash

# This script helps to sync (rebase) 
# enterprise release branch with community 
# release branch.
# Prior to running this script sync-release-branch.sh
# should be executed and confirmed that release
# branches are available.

usage()
{
	echo "Usage: $0 <release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

REL_BRANCH=$1


rebase_rel_branch()
{
  REPODIR="repos/$1"
  BRANCH=$2

  echo "Rebase $2-ee from $2 for repo $1"

  cd $REPODIR && \
 git checkout ${BRANCH}-ee && \
 git rebase -i ${BRANCH} && \
 git status && \
 git push && \
 cd ../..
}

REPO_LIST=$(cat openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
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
    else
      rebase_rel_branch ${ALPHAREPO} ${ALPHABRANCH}
    fi
  fi
done

