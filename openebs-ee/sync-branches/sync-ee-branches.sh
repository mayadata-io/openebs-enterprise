#!/bin/bash

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

REPO_LIST=$(cat  openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    fetch_rel_branch ${REPO} ${REL_BRANCH}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
fetch_rel_branch linux-utils master
fetch_rel_branch node-disk-manager v0.5.x
fetch_rel_branch zfs-localpv v0.7.x
fetch_rel_branch monitor-pv master
fetch_rel_branch Mayastor master

