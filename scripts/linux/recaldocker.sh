#!/bin/bash

# Quick'n'dirty checks
if [[ -z "$ARCH" ]] ; then
  echo "You must set the ARCH variable" >&2
  exit 1
fi

[[ -z $RECALBOX_VERSION_LABEL ]] && RECALBOX_VERSION_LABEL=recalbox-dev

docker build -t "recalbox-dev" \
	--build-arg USERNAME="`whoami`" \
	--build-arg USER_ID="`id -u`" \
	--build-arg GROUP_ID="`id -g`" \
	--build-arg LOCAL_PWD="$PWD" \
	-f scripts/Dockerfile.local .

#~ docker run --rm -d \
	#~ -v $(pwd):/work \
	#~ -v $(pwd):$(pwd) \
	#~ -v "${PWD}/dl":/share/dl \
	#~ -e "ARCH=${ARCH}" \
	#~ -e "RECALBOX_VERSION_LABEL=${RECALBOX_VERSION}" \
	#~ "recalbox-dev"


#~ docker run --rm \
	#~ -w="$(pwd)" \
	#~ -v $(pwd):$(pwd) \
	#~ -v "${PWD}/dl":/share/dl \
	#~ -e "ARCH=${ARCH}" \
	#~ -e "RECALBOX_VERSION_LABEL=${RECALBOX_VERSION}" \
	#~ --user="`id -u`:`id -g`" \
	#~ "recalbox-dev"

NPM_PREFIX_OUTPUT_PATH="`pwd`/output/build/.npm"
mkdir -p "$NPM_PREFIX_OUTPUT_PATH"
docker run --rm \
	-w="$(pwd)" \
	-v $(pwd):$(pwd) \
	-v "$NPM_PREFIX_OUTPUT_PATH":"/.npm" \
	-v "${PWD}/dl":/share/dl \
	-e "ARCH=${ARCH}" \
	-e "PACKAGE=${PACKAGE}" \
	-e "RECALBOX_VERSION_LABEL=${RECALBOX_VERSION}" \
	--user="`id -u`:`id -g`" \
	"recalbox-dev"
