#!/bin/sh

# For the repos that do not have enterprises builds
# get the community image and push them to 
# enterprise container image registry with ci tag

COMMUNITY_REG="openebs/"
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

tag_std_rel_image()
{
  IMG=$1
  docker pull ${COMMUNITY_REG}${IMG}:${C_REL}
  docker tag ${COMMUNITY_REG}${IMG}:${C_REL} ${ENTERPRISE_REG}${IMG}:${CI_TAG}
  docker push ${ENTERPRISE_REG}${IMG}:${CI_TAG}
}

tag_custom_rel_image()
{
  TIMG=$1
  docker pull ${COMMUNITY_REG}${TIMG}
  IMG=$(echo $TIMG | cut -d ':' -f1)
  docker tag ${COMMUNITY_REG}${TIMG} ${ENTERPRISE_REG}${IMG}:${CI_TAG}
  docker push ${ENTERPRISE_REG}${IMG}:${CI_TAG}
}

tag_std_rel_image "jiva-csi"

tag_custom_rel_image "monitor-pv:0.2.0"

tag_custom_rel_image "mayastor:0.1.0"
tag_custom_rel_image "mayastor-grpc:0.1.0"
tag_custom_rel_image "moac:0.1.0"
