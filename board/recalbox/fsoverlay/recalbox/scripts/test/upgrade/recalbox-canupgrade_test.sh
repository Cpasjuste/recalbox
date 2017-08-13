#!/bin/bash

basedir=$(dirname $(realpath $0))

source "$basedir/../bunit.sh"
export PATH="$(bunitPath):$PATH"

recalboxcanupgrade="${basedir}/../../upgrade/recalbox-canupgrade.sh"



###################################################################################
init "when calling for update and curl returns error then returns error"

when curl isCalled thenExit 1

assertThat "$recalboxcanupgrade --uuid 10 --from-version 4.1.0-0001 --service-url https://url-to-use.com --arch rpi1" exitedWith 1



###################################################################################
init "when calling for update and service returns 200 and url of update then display update url"

when curl isCalled with "-f https://url-to-use.com/v1/upgrade?arch=rpi1&boardversion=4.1.0-0001&uuid=10" thenEcho 'https://master.com:8443'
when curl isCalled with "-f https://master.com:8443/v1/upgrade/rpi1/recalbox.version?arch=rpi1&boardversion=4.1.0-0001&uuid=10&source=recalbox" thenEcho '4.1.0-0002'

assertThat "$recalboxcanupgrade --uuid 10 --from-version 4.1.0-0001 --service-url https://url-to-use.com --arch rpi1" echoed "https://master.com:8443"



###################################################################################
init "when calling for update and service returns 200 but same version then exit with 1"

when curl isCalled with "-f https://url-to-use.com/v1/upgrade?arch=rpi1&boardversion=4.1.0-0001&uuid=10" thenEcho 'https://master.com:8443'
when curl isCalled with "-f https://master.com:8443/v1/upgrade/rpi1/recalbox.version?arch=rpi1&boardversion=4.1.0-0001&uuid=10&source=recalbox" thenEcho '4.1.0-0001'

assertThat "$recalboxcanupgrade --uuid 10 --from-version 4.1.0-0001 --service-url https://url-to-use.com --arch rpi1" exitedWith 1



###################################################################################
end