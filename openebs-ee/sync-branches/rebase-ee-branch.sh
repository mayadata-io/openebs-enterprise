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


cherrypick_rel_branch()
{
  REPODIR="repos/$1"
  BRANCH=$2

  echo "Cherry picking from $2 to $2-ee for $1"

  cd $REPODIR && \
 git checkout ${BRANCH}-ee && \
 git rebase -i ${BRANCH} && \
 git status && \
 git push && \
 cd ../..
}

REPO_LIST=$(cat  openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    cherrypick_rel_branch ${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
cherrypick_rel_branch node-disk-manager v0.5.x
cherrypick_rel_branch zfs-localpv v0.7.x

#The following repositories do not have release
#branches yet. 
#cherrypick_rel_branch linux-utils master
#cherrypick_rel_branch monitor-pv master
#cherrypick_rel_branch Mayastor master

