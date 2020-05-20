#!/bin/sh

# Get the community images and push them to 
# enterprise container image registry

COMMUNITY_REG="quay.io/openebs/"
ENTERPRISE_REG="mayadataio/"

usage()
{
  echo "Usage: $0 <community version> [<rc-tag>]"
  echo "Example: To tag 1.10.0-ee from 1.10.0, use: $0 1.10.0"
  echo "Example: to tag 1.10.0-ee-RC3 from 1.10.0, use: $0 1.10.0 RC3"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

C_REL=$1
EE_SUFFIX="-ee"
if [ ! -z $2 ]; then 
  EE_SUFFIX="-ee-${2}"
fi

IMGLIST=$(cat  openebs-community-images.txt |tr "\n" " ")

for IMG in $IMGLIST
do
  echo "docker pull ${COMMUNITY_REG}${IMG}:${C_REL}"
  echo "docker tag ${COMMUNITY_REG}${IMG}:${C_REL} ${ENTERPRISE_REG}${IMG}:${C_REL}${EE_SUFFIX}"
  echo "docker push ${ENTERPRISE_REG}${IMG}:${C_REL}${EE_SUFFIX}"
done

#Images that do not follow the openebs release version
TIMGLIST=$(cat  openebs-community-fixed-tags.txt |tr "\n" " ")

for TIMG in $TIMGLIST
do
  echo "docker pull ${COMMUNITY_REG}${TIMG}"
  echo "docker tag ${COMMUNITY_REG}${TIMG} ${ENTERPRISE_REG}${TIMG}${EE_SUFFIX}"
  echo "docker push ${ENTERPRISE_REG}${TIMG}"
done
