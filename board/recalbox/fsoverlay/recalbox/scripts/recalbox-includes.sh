#!/bin/bash

#
## This is a kind of header file that can be used to declare variables and functions
## That could turn useful in any recalbox script
#

#
## Variables
#

_RBX=/recalbox
_SHAREINIT=$_RBX/share_init
_SHARE=$_RBX/share

#
## Functions
#
function shouldUpdate {
  rbxVersion=$_RBX/recalbox.version
  curVersion=$_SHARE/system/logs/lastrecalbox.conf.update
  diff -qN "$curVersion" "$rbxVersion" 2>/dev/null && return 1
  return 0
}
# Checks if $1 exists in the array passed for $2
function containsElement {
  # local e
  # for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  [[ "${@:2}" =~ "$1" ]] && return 0
  return 1
}

function doRecalboxUpgrades {
  if ! shouldUpdate;then 
    recallog -e "No need to upgrade configuration files" && return 0
  fi
  doRbxConfUpgrade
  upgradeConfiggen
  upgradeInputs
  upgradeTheme
}

# Upgrade the recalbox.conf if necessary
function doRbxConfUpgrade {
  # Update recalbox.conf
  rbxVersion=$_RBX/recalbox.version
  curVersion=$_SHARE/system/logs/lastrecalbox.conf.update
  
  # Check if an update is necessary
  if ! shouldUpdate;then 
    recallog -e "recalbox.conf already up-to-date" && return 0
  fi 
  cfgIn=$_SHAREINIT/system/recalbox.conf
  cfgOut=$_SHARE/system/recalbox.conf
  forced=(controllers.ps3.driver) # Used as a regex, need to escape .
  savefile=${cfgOut}-pre-$(cat $rbxVersion | sed "s+[/ :]++g")
  tmpFile=/tmp/recalbox.conf

  recallog -e "UPDATE : recalbox.conf to $(cat $rbxVersion)"
  cp $cfgIn $tmpFile || { recallog -e "ERROR : Couldn't copy $cfgIn to $tmpFile" ; return 1 ; }
  
  while read -r line ; do
    name=`echo $line | cut -d '=' -f 1`
    value=`echo $line | cut -d '=' -f 2-`
    # echo "$name => $value"
    # Don't update forced values
    if containsElement $name $forced ; then
      recallog "FORCING : $name=$value"
      continue
    fi

    # Check if the property exists or has to be added
    if grep -qE "^[;]?$name=" $cfgIn; then
      recallog "ADDING user defined to $cfgOut : $name=$value"
      sed -i s$'\001'"^[;]\?$name=.*"$'\001'"$name=$value"$'\001' $tmpFile || { recallog "ERROR : Couldn't replace $name=$value in $tmpFile" ; return 1 ; }
    else
      recallog "ADDING custom property to $cfgOut : $name=$value"
      echo "$name=$value" >> $tmpFile || { recallog "ERROR : Couldn't write $name=$value in $tmpFile" ; return 1 ; }
    fi

  done < <(grep -E "^[[:alnum:]\-]+\.[[:alnum:].\-]+=[[:print:]]+$" $cfgOut)
  
  cp $cfgOut $savefile || { recallog -e "ERROR : Couldn't backup $cfgOut to $savefile" ; return 1 ; }
  rm -f $cfgOut
  mv $tmpFile $cfgOut || { recallog -e "ERROR : Couldn't apply the new recalbox.conf" ; return 1 ; }
  cp "$rbxVersion" "$curVersion" || { recallog -e "ERROR : Couldn't set the new recalbox.conf version" ; return 1 ; }
  recallog "UPDATE done !"
}

function upgradeConfiggen {
  
  NEW_VERSION=$(sed -rn "s/^\s*([0-9a-zA-Z.]*)\s*.*$/\1/p" /recalbox/recalbox.version)
  python -c "import sys; sys.path.append('/usr/lib/python2.7/site-packages/configgen'); from emulatorlauncher import config_upgrade; config_upgrade('$NEW_VERSION')"
}

function upgradeInputs {
  /recalbox/scripts/recalbox-config.sh updateesinput "Microsoft X-Box 360 pad" "030000005e0400008e02000014010000"
  /recalbox/scripts/recalbox-config.sh updateesinput "Xbox 360 Wireless Receiver (XBOX)" "030000005e040000a102000007010000"
  /recalbox/scripts/recalbox-config.sh updateesinput "Xbox 360 Wireless Receiver" "030000005e0400001907000000010000"
}

function upgradeTheme {
  /recalbox/scripts/recalbox-themes.sh
}
