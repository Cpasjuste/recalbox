#!/bin/bash

# Quick'n'dirty checks
if [[ -z "$ARCH" ]] ; then
  echo "You must set the ARCH variable" >&2
  exit 1
fi

[[ -z $RECALBOX_VERSION_LABEL ]] && RECALBOX_VERSION_LABEL=recalbox-dev

docker build -t "recalbox-dev" .

NPM_PREFIX_OUTPUT_PATH="`pwd`/output/build/.npm"
mkdir -p "$NPM_PREFIX_OUTPUT_PATH" "${PWD}/dl" "${PWD}/host"

docker run -ti --rm \
	-w="$(pwd)" \
	-v "$(pwd):$(pwd)" \
	-v "$NPM_PREFIX_OUTPUT_PATH:/.npm" \
	-v "${PWD}/dl:/share/dl" \
	-v "${PWD}/host:/share/host" \
	-e "ARCH=${ARCH}" \
	-e "PACKAGE=${PACKAGE}" \
	-e "RECALBOX_VERSION_LABEL=${RECALBOX_VERSION}" \
	--user="`id -u`:`id -g`" \
	"recalbox-dev" ${@}
