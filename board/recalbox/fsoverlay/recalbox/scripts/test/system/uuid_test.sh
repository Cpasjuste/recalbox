#!/bin/bash

basedir=$(dirname $(realpath $0))

source "$basedir/../bunit.sh"
export PATH="$(bunitPath):$PATH"

uuid="${basedir}/../../system/uuid.sh"


function uuidinit {
  rm -rf "/tmp/uuid"
}


###################################################################################
init "when asking for existing uuid then return newly created uuid" uuidinit

echo "dc8a4e33-ce6b-4c0f-9e9d-f6af315fbfde" > /tmp/uuid

assertThat "$uuid --uuid-file /tmp/uuid" echoed "dc8a4e33-ce6b-4c0f-9e9d-f6af315fbfde"



###################################################################################
init "when asking for uuid then return newly created uuid" uuidinit

when cat isCalled with "/proc/sys/kernel/random/uuid" thenEcho "dc8a4e33-ce6b-4c0f-9e9d-f6af315fbfdf"

assertThat "$uuid --uuid-file /tmp/uuid" echoed "dc8a4e33-ce6b-4c0f-9e9d-f6af315fbfdf"
assertThat "/tmp/uuid" contains "dc8a4e33-ce6b-4c0f-9e9d-f6af315fbfdf"


###################################################################################
end