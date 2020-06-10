#!/bin/bash

# Check if release tag is available on enteprise containers 

ENTERPRISE_REG="mayadataio/"

usage()
{
  echo "Usage: $0 <release tag>"
  echo "Example: To check if release tag 1.10.0-ee-RC3 is available use: $0 1.10.0-ee-RC3"
  echo "Example: To check if release tag 1.10.0-ee is available use: $0 1.10.0-ee"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

E_TAG=$1

MISSING_REPOS=""

check_tag()
{
  docker pull ${1}
  if [ $? -eq 0 ]; then
    echo "Found ${1}"
  else
    echo "Missing ${1}"
    MISSING_REPOS="${1}\n${MISSING_REPOS}"
  fi
}

IMGLIST=$(cat openebs-ent-release-tag-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  check_tag "${ENTERPRISE_REG}${IMG}:${E_TAG}"
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat openebs-ent-custom-rel-tag-images.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  check_tag "${ENTERPRISE_REG}${TIMG}"
done

echo 
if [ ! -z ${MISSING_REPOS} ]; then 
  echo "Error: unable to locate required tag on the following repos:"
  printf ${MISSING_REPOS}
  echo
else
  echo "Success: Found tag $1 on all repos"
fi 
