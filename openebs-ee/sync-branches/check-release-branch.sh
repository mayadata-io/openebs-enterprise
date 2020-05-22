#!/bin/bash

usage()
{
	echo "Usage: $0 <release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

REL_BRANCH=$1

check_ee_branch()
{
  REPO=$1
  BRANCH=$2

  #Check that community branch exists
  ./git-get-branch openebs/${REPO} ${BRANCH}
  if [ $? -eq 0 ]; then
    if [ "$BRANCH" == "master" ] ; then
      echo "Skipping $REPO which has only master branch"
    else
      ./git-get-branch mayadata-io/${REPO} ${BRANCH}
      ./git-get-branch mayadata-io/${REPO} ${BRANCH}-ee
    fi
  else
    echo "Error: ${REPO} is missing release branch ${BRANCH}"
  fi
}

REPO_LIST=$(cat  openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping ${REPO}"
  else
    check_ee_branch ${REPO} ${REL_BRANCH}
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
    check_ee_branch ${ALPHAREPO} ${ALPHABRANCH}
  fi
done
