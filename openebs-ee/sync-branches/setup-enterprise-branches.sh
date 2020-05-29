#!/bin/bash

# This script helps to check if the enterprise release branch 
# for the corresponding community release branch is created.
# If not created, then a new enterprise release branch is created. 

usage()
{
	echo "Usage: $0 <community release branch>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

rm -rf repos
mkdir -p repos

REL_BRANCH=$1

setup_repo()
{
  ./setup-update-repo $1  
}

fetch_rel_branch()
{
  setup_repo ${1}
  ./checkout-upstream-branch ${1} ${2}
}

create_ee_rel_branch()
{
  ./create-branch ${1} ${2}
}

check_ee_branch()
{
  REPO=$1
  BRANCH=$2
  echo 
  #Check that community branch exists
  ./git-get-branch openebs/${REPO} ${BRANCH}
  if [ $? -eq 0 ]; then
    if [ "$BRANCH" == "master" ] ; then
      echo "Skipping $REPO"
    else
      #Fetch upstream community release branch if it is missing
      ./git-get-branch mayadata-io/${REPO} ${BRANCH}
      if [ $? -ne 0 ]; then
        fetch_rel_branch $1 $2
      fi

      #Create enterprise release branch if it is missing
      ./git-get-branch mayadata-io/${REPO} ${BRANCH}-ee
      if [ $? -ne 0 ]; then
         create_ee_rel_branch $1 $2
      else
         echo "Success: Found mayadata-io/${REPO} has enterprise release branch ${BRANCH}"
      fi
      
    fi
  else
    echo "Error: openebs/${REPO} is missing release branch ${BRANCH}"
  fi
}

REPO_LIST=$(cat openebs-repos.txt |tr "\n" " ")

for REPO in $REPO_LIST
do
  if [[ $REPO =~ ^# ]]; then
    echo "Skipping $REPO"
  else
    check_ee_branch ${REPO} ${REL_BRANCH}
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
    if [ "$ALPHABRANCH" == "master" ] ; then
      echo "Skipping ${ALPHAREPO}"
    else
      check_ee_branch ${ALPHAREPO} ${ALPHABRANCH}
    fi
  fi
done

