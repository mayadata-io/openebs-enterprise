#!/bin/sh

# Get the community images and push them to 
# enterprise container image registry

COMMUNITY_REG="quay.io/openebs/"
ENTERPRISE_REG="mayadata-io/"

usage()
{
	echo "Usage: $0 <openebs version>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

RELEASE_TAG=$1

IMGLIST=$(cat  openebs-community-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  docker pull ${COMMUNITY_REG}${IMG}:$RELEASE_TAG
  docker tag ${COMMUNITY_REG}${IMG}:$RELEASE_TAG ${ENTERPRISE_REG}${IMG}:$RELEASE_TAG-ee
  docker push ${ENTERPRISE_REG}${IMG}:$RELEASE_TAG-ee
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat  openebs-community-fixed-tags.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  docker pull ${COMMUNITY_REG}${TIMG}
  docker tag ${COMMUNITY_REG}${TIMG} ${ENTERPRISE_REG}${TIMG}-ee
  docker push ${ENTERPRISE_REG}${TIMG}-ee
done
