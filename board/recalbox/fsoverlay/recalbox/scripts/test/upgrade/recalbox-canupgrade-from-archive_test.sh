#!/bin/bash

basedir=$(dirname $(realpath $0))

source "$basedir/../bunit.sh"
export PATH="$(bunitPath):$PATH"

recalboxcanupgrade="${basedir}/../../upgrade/recalbox-canupgrade-from-archive.sh"



###################################################################################
init "when calling with a more recent version then return can upgrade exit code"

when curl isCalled thenEcho "4.1.0-0002"

assertThat "$recalboxcanupgrade --from-version 4.1.0-0001 --upgrade-url https://url-to-use.com --arch rpi1" exitedWith 0

assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi1/recalbox.version?source=recalbox"



###################################################################################
init "when calling with a same version then return cannot upgrade exit code"

when curl isCalled thenEcho "4.1.0-0002"

assertThat "$recalboxcanupgrade --from-version 4.1.0-0002 --upgrade-url https://url-to-use.com --arch rpi1" exitedWith 1

assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi1/recalbox.version?source=recalbox"



###################################################################################
#init "when calling can upgrade with older version then return cannot upgrade exit code"

#when curl isCalled thenEcho "4.1.0-0001"

#assertThat "$recalboxcanupgrade --from-version 4.1.0-0002 --upgrade-url https://url-to-use.com --arch rpi1" exitedWith 1

#assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi1/recalbox.version"



###################################################################################
init "when calling with branch name and same version then returns cannot update exit code"

when curl isCalled thenEcho "147-new-update-system-1145454"

assertThat "$recalboxcanupgrade --from-version 147-new-update-system-1145454 --upgrade-url https://url-to-use.com --arch rpi1" exitedWith 1

assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi1/recalbox.version?source=recalbox"



###################################################################################
init "when calling with branch name and newer version then returns cannot update exit code"

when curl isCalled thenEcho "147-new-update-system-1145470"

assertThat "$recalboxcanupgrade --from-version 147-new-update-system-1145454 --upgrade-url https://url-to-use.com --arch rpi1" exitedWith 0

assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi1/recalbox.version?source=recalbox"



###################################################################################
init "when calling with arch rpi then recalbox version is fetched from rpi3"

when curl isCalled thenEcho "aversion"

assertThat "$recalboxcanupgrade --from-version aversion --upgrade-url https://url-to-use.com --arch rpi3" exitedWith 1

assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi3/recalbox.version?source=recalbox"



###################################################################################
init "when calling with arch rpi3 then recalbox version is fetched from rpi3"

when curl isCalled thenEcho "aversion"

assertThat "$recalboxcanupgrade --from-version aversion --upgrade-url https://url-to-use.com --arch rpi3" exitedWith 1

assertThat curl hasBeenCalledWith "https://url-to-use.com/v1/upgrade/rpi3/recalbox.version?source=recalbox"



###################################################################################
init "when calling and new version available then returns the available version"

when curl isCalled thenEcho "aNewVersion"

assertThat "$recalboxcanupgrade --from-version aversion --upgrade-url https://url-to-use.com --arch rpi3" echoed "aNewVersion"



###################################################################################
init "when calling and no version available then returns 'no upgrade available"

when curl isCalled thenEcho "aversion"

assertThat "$recalboxcanupgrade --from-version aversion --upgrade-url https://url-to-use.com --arch rpi3" echoed "no upgrade available"



###################################################################################
end