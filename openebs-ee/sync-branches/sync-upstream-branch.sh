#!/bin/bash

# Run this script that helps to merge(rebase) changes
# from community OpenEBS repository to the corresponding
# MayaData forked repository.
#
# After rebasing the master and community release branch, 
# the changes from community release branch are rebased to 
# corresponding enterprise release branch.

usage()
{
	echo "Usage: $0 <repo> <master-branch> <release-branch>"
	exit 1
}

if [ $# -ne 3 ]; then
	usage
fi

mkdir -p repos
rm -rf repos/$1

./setup-update-repo $1
./sync-upstream-branch $1 $2
./sync-upstream-branch $1 $3
./rebase-forked-repo-branch $1 $3

