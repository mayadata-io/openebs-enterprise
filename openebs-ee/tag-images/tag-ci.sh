#!/bin/sh

# Get the community images and push them to 
# enterprise container image registry

COMMUNITY_REG="quay.io/openebs/"
ENTERPRISE_REG="mayadataio/"

usage()
{
  echo "Usage: $0 <community version>"
  echo "Example: To tag community version 1.10.0 as ci, use: $0 1.10.0"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

C_REL=$1
CI_TAG="ci"

IMGLIST=$(cat openebs-release-tag-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  docker pull ${COMMUNITY_REG}${IMG}:${C_REL}
  docker tag ${COMMUNITY_REG}${IMG}:${C_REL} ${ENTERPRISE_REG}${IMG}:${CI_TAG}
  docker push ${ENTERPRISE_REG}${IMG}:${CI_TAG}
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat openebs-custom-tag-images.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  docker pull ${COMMUNITY_REG}${TIMG}
  IMG=$(echo $TIMG | cut -d ':' -f1)
  docker tag ${COMMUNITY_REG}${TIMG} ${ENTERPRISE_REG}${IMG}:${CI_TAG}
  docker push ${ENTERPRISE_REG}${IMG}:${CI_TAG}
done
