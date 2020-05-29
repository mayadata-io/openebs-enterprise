#!/bin/sh

# For the repos that do not have enterprises builds
# get the community image and push them to 
# enterprise container image registry


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

COMMUNITY_REG="openebs/"
ENTERPRISE_REG="mayadataio/"

tag_std_rel_image()
{
  IMG=$1
  docker pull ${COMMUNITY_REG}${IMG}:${C_REL}
  docker tag ${COMMUNITY_REG}${IMG}:${C_REL} ${ENTERPRISE_REG}${IMG}:${C_REL}${EE_SUFFIX}
  docker push ${ENTERPRISE_REG}${IMG}:${C_REL}${EE_SUFFIX}
}

tag_custom_rel_image()
{
  TIMG=$1
  docker pull ${COMMUNITY_REG}${TIMG}
  docker tag ${COMMUNITY_REG}${TIMG} ${ENTERPRISE_REG}${TIMG}${EE_SUFFIX}
  docker push ${ENTERPRISE_REG}${TIMG}${EE_SUFFIX}
}

tag_std_rel_image "jiva-csi"

tag_custom_rel_image "monitor-pv:0.2.0"

tag_custom_rel_image "mayastor:0.1.0"
tag_custom_rel_image "mayastor-grpc:0.1.0"
tag_custom_rel_image "moac:0.1.0"
