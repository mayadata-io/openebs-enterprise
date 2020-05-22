#!/bin/bash

# This script helps to sync (rebase) OpenEBS
# repositories forked into MayaData with the
# upstream changes on master and release branch.

usage()
{
	echo "Usage: $0 <release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

mkdir -p repos

REL_BRANCH=$1

setup_repo()
{
  REPODIR="repos/$1"

  if [[ -d $REPODIR ]]; then 
    echo "Syncing $1"
    cd $REPODIR && git pull && cd ../..
  else 
    REPOURL="https://github.com/mayadata-io/$1"
    echo "Cloning $REPOURL into $REPODIR"
    cd repos && git clone $REPOURL && cd ..

    cd $REPODIR && \
 git remote add upstream https://github.com/openebs/$1 && \
 git remote set-url --push upstream no_push && \
 git remote -v && \
 cd ../..

  fi 
}

fetch_rel_branch()
{
  REPODIR="repos/$1"
  BRANCH=$2

  setup_repo ${1}

  ./git-get-branch mayadata-io/${1} ${BRANCH}
  if [ $? -eq 0 ]; then
    echo "$1 already has ${BRANCH}"

  else
    echo "Syncing $1 with ${BRANCH}"

    cd $REPODIR && \
 git fetch upstream ${BRANCH}:${BRANCH} && \
 git checkout ${BRANCH} && \
 git push --set-upstream origin ${BRANCH} && \
 cd ../..

  fi
}

sync_rel_branch()
{
  REPODIR="repos/$1"
  BRANCH=$2

  fetch_rel_branch $1 $2

  cd $REPODIR && \
 git checkout ${BRANCH} && \
 git fetch upstream ${BRANCH} && \
 git rebase upstream/${BRANCH} && \
 git status && \
 git push && \
 cd ../..

}

create_ee-rel_branch()
{
  REPODIR="repos/$1"
  BRANCH=$2

  cd $REPODIR && \
 git checkout ${BRANCH} && \
 git branch ${BRANCH}-ee && \
 git checkout ${BRANCH}-ee && \
 git push --set-upstream origin ${BRANCH}-ee && \
 cd ../..

}

check_ee_branch()
{
  REPO=$1
  BRANCH=$2
  #Check that community branch exists
  ./git-get-branch openebs/${REPO} ${BRANCH}
  if [ $? -eq 0 ]; then
    fetch_rel_branch $1 $2

    if [ "$BRANCH" == "master" ] ; then
      echo "Skipping $REPO"
    else
      ./git-get-branch mayadata-io/${REPO} ${BRANCH}
      if [ $? -eq 0 ]; then
        ./git-get-branch mayadata-io/${REPO} ${BRANCH}-ee
        if [ $? -ne 0 ]; then
           echo "Need enterprise release branch for  $REPO"
           create_ee-rel_branch $1 $2
        fi
      fi
    fi
  else
    echo "Error: ${REPO} is missing release branch ${BRANCH}"
  fi
}

REPO_LIST=$(cat  openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    echo "Skipping $REPO"
    sync_rel_branch ${REPO} master
    check_ee_branch ${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
check_ee_branch node-disk-manager v0.5.x
check_ee_branch zfs-localpv v0.7.x
sync_rel_branch node-disk-manager master
sync_rel_branch zfs-localpv master

#The following repositories do not have release
#branches yet. 
sync_rel_branch linux-utils master
sync_rel_branch monitor-pv master
sync_rel_branch Mayastor master

#The following repositories master branch is
#unconventional
sync_rel_branch cstor develop
sync_rel_branch istgt replication
sync_rel_branch external-storage release

