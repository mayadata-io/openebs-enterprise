#!/bin/bash

# Check if "ci" tag on community and enteprise release branches
# is available

COMMUNITY_REG="openebs/"
ENTERPRISE_REG="mayadataio/"

usage()
{
  echo "Usage: $0 <community branch ci tag>"
  echo "Example: To check community version v1.10.x-ci and corresponding v1.10.x-ee-ci use: $0 v1.10.x-ci"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

C_TAG=$1

MISSING_REPOS=""

check_tag()
{
  docker pull ${1}
  if [ $? -eq 0 ]; then
    echo "Found ${1}"
  else
    echo "Missing ${1}"
    MISSING_REPOS = $(echo "${1}\n${MISSING_REPOS}")
  fi
}

parse_image()
{
  IMG=$(echo $1 | cut -d ':' -f1)
  TAG=$(echo $1 | cut -d ':' -f2)
  check_tag "${COMMUNITY_REG}${IMG}:${TAG}"

  TAG_SUFFIX=$(echo $TAG | rev | cut -d '-' -f1 | rev)
  TAG_PREFIX=$(echo $TAG | cut -d '-' -f1 )
  if [ "$TAG_SUFFIX" == "$TAG_PREFIX" ]; then 
    E_TAG="${TAG_PREFIX}-ee"
  else
    E_TAG="${TAG_PREFIX}-ee-${TAG_SUFFIX}"
  fi
  check_tag "${ENTERPRISE_REG}${IMG}:${E_TAG}"
}

IMGLIST=$(cat openebs-release-tag-ci-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  parse_image "${IMG}:${C_TAG}"
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat openebs-custom-tag-ci-images.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  parse_image ${TIMG}
done

echo 
if [ ! -z ${MISSING_REPOS} ]; then 
  echo "Error: unable to locate required tag on the following repos: ${MISSING_REPOS}"
else
  echo "Success: Found tag $1 on all repos"
fi 
