#!/bin/bash

# This script helps to sync (rebase) OpenEBS
# repositories forked into MayaData with the
# upstream changes on master and release branch.

usage()
{
	echo "Usage: $0"
	exit 1
}

if [ $# -ne 0 ]; then
	usage
fi

rm -rf repos
mkdir -p repos


sync_tags()
{
  REPODIR="repos/$1"

  REPOURL="https://github.com/mayadata-io/$1"
  echo "Cloning $REPOURL into $REPODIR"
  cd repos && git clone $REPOURL && cd ..

  cd $REPODIR && \
 git remote add upstream https://github.com/openebs/$1 && \
 git remote set-url --push upstream no_push && \
 git remote -v && \
 git fetch upstream && \
 git push --tags && \
 cd ../..

}


REPO_LIST=$(cat openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    sync_tags ${REPO}
  fi
done

#OpenEBS Release repositories with non-mainstream 
#branching convention
ALPHA_REPO_LIST=$(cat openebs-alpha-repos.txt |tr "\n" " ")
for REPOWITHBRANCH in $ALPHA_REPO_LIST
do
  ALPHAREPO=$(echo ${REPOWITHBRANCH} | cut -d ':' -f1)
  ALPHABRANCH=$(echo ${REPOWITHBRANCH} | cut -d ':' -f2)
  if [[ $ALPHAREPO =~ ^# ]]; then
    echo "Skipping ${ALPHAREPO}"
  else
    sync_tags ${ALPHAREPO}
  fi
done

