#!/bin/bash

if [ ! "$1" ];then
	echo -e "usage : recalbox-config.sh [command] [args]\nWith command in\n\toverscan [enable|disable]\n\toverclock [none|high|turbo|extrem]\n\taudio [hdmi|jack|auto|string]\n\tlsaudio\n\tcanupdate\n\tupdate\n\twifi [enable|disable] ssid key\n\tstorage [current|list|INTERNAL|ANYEXTERNAL|RAM|DEV UUID]\n\tsetRootPassword [password]\n\tgetRootPassword"
	exit 1
fi
configFile="/boot/config.txt"
storageFile="/boot/recalbox-boot.conf"
command="$1"
mode="$2"
extra1="$3"
extra2="$4"
arch=`cat /recalbox/recalbox.arch`

recalboxupdateurl="http://archive.recalbox.com/updates/v1.0"

preBootConfig() {
    mount -o remount,rw /boot
}

postBootConfig() {
    mount -o remount,ro /boot
}

function getSubNum () {
	# $1 : version number. ex 4.0.2
	# $2 : separator. ex : "."
	# $3 : the position you need. ex : 2
	result=`echo $1 | cut -d "$2" -f "$3" 2>/dev/null`
	[[ -z $result ]] && echo "0" || echo $result
}

function isNewer () {
	# compare $1 and $2
	# if $1 >= $2 return 0
	# else return 1
	newVersion="$1"
	oldVersion="$2"

	for i in 1 2 3 ; do
		oldNum=`getSubNum $oldVersion "." "$i"`
		newNum=`getSubNum $newVersion "." "$i"`
		[[ $newNum -eq $oldNum ]] && continue 
		[[ $newNum -gt $oldNum ]] && return 0
		[[ $newNum -lt $oldNum ]] && return 1
	done
	return 1
}

log=/recalbox/share/system/logs/recalbox.log
systemsetting="python /usr/lib/python2.7/site-packages/configgen/settings/recalboxSettings.pyc"

echo "---- recalbox-config.sh ----" >> $log

if [ "$command" == "getRootPassword" ]; then
    # security disabled, force the default one without changing boot configuration
    securityenabled="`$systemsetting  -command load -key system.security.enabled`"
    if [ "$securityenabled" != "1" ];then
	echo "recalboxroot"
	exit 0
    fi
    
    ENCPASSWD=$(grep -E '^[ \t]*rootshadowpassword[ \t]*=' "${storageFile}" | sed -e s+'^[ \t]*rootshadowpassword[ \t]*='++)
    if test -z "${ENCPASSWD}"
    then
	exit 1
    fi
    if ! /recalbox/scripts/recalbox-encode.sh decode "${ENCPASSWD}"
    then
	exit 1
    fi
    exit 0
fi

if [ "$command" == "setRootPassword" ]; then
    PASSWD=${2}

    # security disabled, don't change
    securityenabled="`$systemsetting  -command load -key system.security.enabled`"
    if [ "$securityenabled" != "1" ];then
	exit 0
    fi
    
    # if no password if provided, generate one
    if test -z "${PASSWD}"
    then
	PASSWD=$(tr -cd _A-Z-a-z-0-9 < /dev/urandom | fold -w8 | head -n1)
    fi
    PASSWDENC=$(/recalbox/scripts/recalbox-encode.sh encode "${PASSWD}")
    
    preBootConfig
    if grep -qE '^[ \t]*rootshadowpassword[ \t]*=' "${storageFile}"
    then
	# update it
	if ! sed -i -e s@'^[ \t]*rootshadowpassword[ \t]*=.*$'@"rootshadowpassword=${PASSWDENC}"@ "${storageFile}"
	then
	    postBootConfig
	    exit 1
	fi
	postBootConfig
	exit 0
    else
	# create it
	if ! echo "rootshadowpassword=${PASSWDENC}" >> "${storageFile}"
	then
	    postBootConfig
	    exit 1
	fi
	postBootConfig
	exit 0
    fi    
fi

if [ "$command" == "overscan" ]; then
if [ -f "$configFile" ];then
        preBootConfig
        cat "$configFile" | grep "disable_overscan"
	overscanPresent=$?

	if [ "$overscanPresent" != "0" ];then
		echo "disable_overscan=1" >> "$configFile"
	fi
	cat "$configFile" | grep "overscan_scale"
	overscanScalePresent=$?

	if [ "$overscanScalePresent" != "0" ];then
		echo "overscan_scale=1" >> "$configFile"
	fi

	if [ "$mode" == "enable" ];then
		echo "`logtime` : enabling overscan" >> $log
		sed -i "s/#\?disable_overscan=.*/disable_overscan=0/g" "$configFile"
		sed -i "s/#\?overscan_scale=.*/overscan_scale=1/g" "$configFile"
	elif [ "$mode" == "disable" ];then
                echo "`logtime` : disabling overscan" >> $log
                sed -i "s/#\?disable_overscan=.*/disable_overscan=1/g" "$configFile"
                sed -i "s/#\?overscan_scale=.*/overscan_scale=0/g" "$configFile"
	else
                postBootConfig
		exit 1
	fi
	postBootConfig
	exit 0
else
	exit 2
fi
fi

if [ "$command" == "overclock" ]; then

declare -A arm_freq
arm_freq["rpi3-extrem"]=1375
arm_freq["rpi3-turbo"]=1350
arm_freq["rpi3-high"]=1300
arm_freq["rpi2-extrem"]=1100
arm_freq["rpi2-turbo"]=1050
arm_freq["rpi2-high"]=1050
arm_freq["extrem"]=1100
arm_freq["turbo"]=1000
arm_freq["high"]=950

declare -A core_freq
core_freq["rpi3-extrem"]=500
core_freq["rpi3-turbo"]=500
core_freq["rpi3-high"]=500
core_freq["rpi2-extrem"]=550
core_freq["rpi2-turbo"]=525
core_freq["rpi2-high"]=525
core_freq["extrem"]=550
core_freq["turbo"]=500
core_freq["high"]=250

declare -A sdram_freq
sdram_freq["rpi3-extrem"]=575
sdram_freq["rpi3-turbo"]=575
sdram_freq["rpi3-high"]=575
sdram_freq["rpi2-extrem"]=480
sdram_freq["rpi2-turbo"]=480
sdram_freq["rpi2-high"]=450
sdram_freq["extrem"]=600
sdram_freq["turbo"]=600
sdram_freq["high"]=450

declare -A force_turbo
force_turbo["rpi3-extrem"]=0
force_turbo["rpi3-turbo"]=0
force_turbo["rpi3-high"]=0
force_turbo["rpi2-extrem"]=1
force_turbo["rpi2-turbo"]=0
force_turbo["rpi2-high"]=0
force_turbo["extrem"]=1
force_turbo["turbo"]=0
force_turbo["high"]=0

declare -A over_voltage
over_voltage["rpi3-extrem"]=4
over_voltage["rpi3-turbo"]=4
over_voltage["rpi3-high"]=4
over_voltage["rpi2-extrem"]=4
over_voltage["rpi2-turbo"]=4
over_voltage["rpi2-high"]=4
over_voltage["extrem"]=8
over_voltage["turbo"]=6
over_voltage["high"]=6

declare -A over_voltage_sdram_p
over_voltage_sdram_p["rpi3-extrem"]=6
over_voltage_sdram_p["rpi3-turbo"]=6
over_voltage_sdram_p["rpi3-high"]=6
over_voltage_sdram_p["rpi2-extrem"]=4
over_voltage_sdram_p["rpi2-turbo"]=2
over_voltage_sdram_p["rpi2-high"]=2
over_voltage_sdram_p["extrem"]=6
over_voltage_sdram_p["turbo"]=0
over_voltage_sdram_p["high"]=0

declare -A over_voltage_sdram_i
over_voltage_sdram_i["rpi3-extrem"]=4
over_voltage_sdram_i["rpi3-turbo"]=4
over_voltage_sdram_i["rpi3-high"]=4
over_voltage_sdram_i["rpi2-extrem"]=4
over_voltage_sdram_i["rpi2-turbo"]=2
over_voltage_sdram_i["rpi2-high"]=2
over_voltage_sdram_i["extrem"]=6
over_voltage_sdram_i["turbo"]=0
over_voltage_sdram_i["high"]=0

declare -A over_voltage_sdram_c
over_voltage_sdram_c["rpi3-extrem"]=4
over_voltage_sdram_c["rpi3-turbo"]=4
over_voltage_sdram_c["rpi3-high"]=4
over_voltage_sdram_c["rpi2-extrem"]=4
over_voltage_sdram_c["rpi2-turbo"]=2
over_voltage_sdram_c["rpi2-high"]=2
over_voltage_sdram_c["extrem"]=6
over_voltage_sdram_c["turbo"]=0
over_voltage_sdram_c["high"]=0

declare -A gpu_freq
gpu_freq["rpi3-extrem"]=500
gpu_freq["rpi3-turbo"]=500
gpu_freq["rpi3-high"]=500
gpu_freq["rpi2-extrem"]=366
gpu_freq["rpi2-turbo"]=350
gpu_freq["rpi2-high"]=350
gpu_freq["extrem"]=250
gpu_freq["turbo"]=250
gpu_freq["high"]=250

declare -A sdram_schmoo
sdram_schmoo["rpi3-extrem"]=0x02000020
sdram_schmoo["rpi3-turbo"]=0x02000020
sdram_schmoo["rpi3-high"]=0x02000020
sdram_schmoo["rpi2-extrem"]=0x02000020
sdram_schmoo["rpi2-turbo"]=0x02000020
sdram_schmoo["rpi2-high"]=0x02000020
sdram_schmoo["extrem"]=0x02000020
sdram_schmoo["turbo"]=0x02000020
sdram_schmoo["high"]=0x02000020

if [ -f "$configFile" ];then
        preBootConfig
        if [[ "$mode" == "none" ]]; then
          for entry in arm_freq core_freq sdram_freq force_turbo over_voltage over_voltage_sdram_p over_voltage_sdram_i over_voltage_sdram_c gpu_freq sdram_schmoo; do
	    sed -i "/^${entry}/d" "$configFile"
          done
        else
	cat "$configFile" | grep "arm_freq"
	if [ "$?" != "0" ];then
		echo "arm_freq=" >> "$configFile"
	fi
	cat "$configFile" | grep "core_freq"
	if [ "$?" != "0" ];then
		echo "core_freq=" >> "$configFile"
	fi
	cat "$configFile" | grep "sdram_freq"
	if [ "$?" != "0" ];then
		echo "sdram_freq=" >> "$configFile"
	fi
	cat "$configFile" | grep "force_turbo"
	if [ "$?" != "0" ];then
		echo "force_turbo=" >> "$configFile"
	fi
	cat "$configFile" | grep "over_voltage"
	if [ "$?" != "0" ];then
		echo "over_voltage=" >> "$configFile"
	fi
	cat "$configFile" | grep "over_voltage_sdram_p"
	if [ "$?" != "0" ];then
		echo "over_voltage_sdram_p=" >> "$configFile"
	fi
	cat "$configFile" | grep "over_voltage_sdram_i"
	if [ "$?" != "0" ];then
		echo "over_voltage_sdram_i=" >> "$configFile"
	fi
	cat "$configFile" | grep "over_voltage_sdram_c"
	if [ "$?" != "0" ];then
		echo "over_voltage_sdram_c=" >> "$configFile"
	fi
	cat "$configFile" | grep "gpu_freq"
	if [ "$?" != "0" ];then
		echo "gpu_freq=" >> "$configFile"
	fi
	cat "$configFile" | grep "sdram_schmoo"
	if [ "$?" != "0" ];then
		echo "sdram_schmoo=" >> "$configFile"
	fi

	sed -i "s/#\?arm_freq=.*/arm_freq=${arm_freq[$mode]}/g" "$configFile"
	sed -i "s/#\?core_freq=.*/core_freq=${core_freq[$mode]}/g" "$configFile"
	sed -i "s/#\?sdram_freq=.*/sdram_freq=${sdram_freq[$mode]}/g" "$configFile"
	sed -i "s/#\?force_turbo=.*/force_turbo=${force_turbo[$mode]}/g" "$configFile"
	sed -i "s/#\?over_voltage=.*/over_voltage=${over_voltage[$mode]}/g" "$configFile"
	sed -i "s/#\?over_voltage_sdram_p=.*/over_voltage_sdram_p=${over_voltage_sdram_p[$mode]}/g" "$configFile"
	sed -i "s/#\?over_voltage_sdram_i=.*/over_voltage_sdram_i=${over_voltage_sdram_i[$mode]}/g" "$configFile"
	sed -i "s/#\?over_voltage_sdram_c=.*/over_voltage_sdram_c=${over_voltage_sdram_c[$mode]}/g" "$configFile"
	sed -i "s/#\?gpu_freq=.*/gpu_freq=${gpu_freq[$mode]}/g" "$configFile"
	sed -i "s/#\?sdram_schmoo=.*/sdram_schmoo=${sdram_schmoo[$mode]}/g" "$configFile"
        fi
        echo "`logtime` : enabled overclock mode : $mode" >> $log

	postBootConfig
	
	exit 0
else
	exit 2
fi

fi

if [ "$command" == "getaudio" ];then
    $systemsetting -command load -key audio.device
    exit 0
fi

if [ "$command" == "audio" ];then
    # this code is specific to the rpi
    # don't set it on other boards
    # find a more generic way would be nice
    rm /recalbox/share/system/.asoundrc 2>/dev/null
    if [[ "${arch}" =~ "rpi" && "auto hdmi jack" =~ "${mode}" ]]
    then
	# this is specific to the rpi
	cmdVal="0"
	if [ "$mode" == "hdmi" ];then
	    cmdVal="2"
	elif [ "$mode" == "jack" ];then
	    cmdVal="1"
	fi
        echo "`logtime` : setting audio output mode : $mode" >> $log
	amixer cset numid=3 $cmdVal || exit 1
    elif echo "$mode" | grep -qE "^\[[0-9]:[0-9]\]"
    then
        cardId=`echo $mode | sed "s+^\[\([0-9]\)\:\([0-9]\)\].*+\1+g"`
        deviceId=`echo $mode | sed "s+^\[\([0-9]\)\:\([0-9]\)\].*+\2+g"`
        recallog "setting audio output mode : '$mode' => $cardId $deviceId"
        cat > /recalbox/share/system/.asoundrc << EOF
pcm.!default {
        type hw
        card ${cardId}
        device ${deviceId}
}
 
ctl.!default {
        type hw           
        card ${cardId}
}
EOF
        exit $?
    else
        recallog -e "Uknown audio format : $mode"
        exit 1
    fi
    exit 0
fi

if [ "$command" == "lsaudio" ];then
    # lists audio devices
    echo "auto"
    if [[ "${arch}" =~ "rpi" ]] ; then
        echo "hdmi"
        echo "jack"
    fi
    # Now other embedded devices
    find /proc/asound -type d -name "pcm*p" | while read fileDev ; do
        cardId=`echo $fileDev | sed "s+.*card\([0-9]\).*+\1+g"`
        deviceId=`echo $fileDev | sed "s+.*pcm\([0-9]\)p$+\1+g"`
        cardName=`grep " ${cardId} \[" /proc/asound/cards | cut -d ":" -f 2 | sed "s+^ ++g"`
        echo "$cardName" | grep -q "bcm2835" && continue # Exclude Pi3 internal audio
        deviceName=`cat /proc/asound/card${cardId}/pcm${deviceId}p/info | grep "^id:" | cut -d ":" -f 2 | sed "s+^ ++g"`
        echo "[${cardId}:${deviceId}] ${cardName} + ${deviceName}"
    done
    exit 0
fi

if [ "$command" == "volume" ];then
	if [ "$mode" != "" ];then
		echo "`logtime` : setting audio volume : $mode" >> $log
		
		if ( amixer scontrols | grep -q 'Master' ); then
		# on my pc, the master is turned off at boot
		# i don't know what are the rules to set here.
			amixer set Master unmute      || exit 1
		fi
		if ( amixer scontrols | grep -q 'PCM' ); then
			amixer set PCM    unmute      || exit 1
		fi
		# Odroids have no sound controller. Too bad, exit 0 anyway
		# Force the sound volume to every mixer on the default sound card
		for param in `amixer controls | cut -d ',' -f 1` ; do echo Setting volume for $param ; amixer -q cset ${param} ${mode}% ; done
		exit 0
	fi
	exit 12
fi

if [ "$command" == "gpiocontrollers" ];then
	command="module"
	mode="load"
	extra1="mk_arcade_joystick_rpi"
	extra2="map=1,2"
fi

if [ "$command" == "module" ];then
	modulename="$extra1"
	map="$extra2"
	# remove in all cases
	rmmod /lib/modules/`uname -r`/extra/${modulename}.ko >> $log

        if [ "$mode" == "load" ];then
	        echo "`logtime` : loading module $modulename args = $map" >> $log
		insmod /lib/modules/`uname -r`/extra/${modulename}.ko $map >> $log
		[ "$?" ] || exit 1
        fi
	exit 0
fi

if [ "$command" == "canupdate" ];then
	updatetype="`$systemsetting  -command load -key updates.type`"
	if test "${updatetype}" = "beta"
	then
		updatetype="stable"
	fi
	available=`wget -qO- ${recalboxupdateurl}/${updatetype}/${arch}/recalbox.version`
	if [[ "$?" != "0" ]];then
		exit 2
	fi
	installed=`cat /recalbox/recalbox.version`
	
	archiveVersion=`echo ${available} | cut -d '-' -f 1`
	localVersion=`echo ${installed} | cut -d '-' -f 1`
	
	if [[ ${updatetype} == "stable" ]] ; then
		if isNewer $archiveVersion $localVersion ; then
			echo "update available"
			exit 0
		fi
	elif [[ "$available" != "$installed" ]]; then
		echo "update available"
		exit 0
	fi
	echo "no update available"
	exit 12
fi

if [ "$command" == "update" ];then
	/recalbox/scripts/recalbox-upgrade.sh
	exit $?
fi

if [[ "$command" == "wifi" ]]; then
        ssid="$3"
        psk="$4"

        if [[ "$mode" == "enable" ]]; then
            echo "`logtime` : configure wifi" >> $log
	    mkdir -p "/var/lib/connman" || exit 1
	    cat > "/var/lib/connman/recalbox.config" <<EOF
[global]
Name=recalbox

[service_recalbox_default]
Type=wifi
Name=${ssid}
EOF
	    if test "${psk}" != ""
	    then
		echo "Passphrase=${psk}" >> "/var/lib/connman/recalbox.config"
	    fi

	    connmanctl enable wifi || exit 1
	    connmanctl scan   wifi || exit 1
            exit 0
        fi
  	if [[ "$mode" =~ "start" ]]; then
            if [[ "$mode" != "forcestart" ]]; then
                settingsWlan="`$systemsetting -command load -key wifi.enabled`"
                if [ "$settingsWlan" != "1" ];then
                    exit 1
                fi
            fi
	    connmanctl enable wifi || exit 1
	    connmanctl scan   wifi || exit 1
	    exit 0
        fi
        if [[ "$mode" == "disable" ]]; then
	    connmanctl disable wifi
            exit $?
        fi
	if [[ "$mode" == "list" ]]; then
	    WAVAILABLE=$(connmanctl services | cut -b 5- | sed -e s+'^\([^ ]*\).*$'+'\1'+ | grep -vE '^Wired$|^<hidden>$')
	    if test -n "${ssid}"
	    then
		echo "${WAVAILABLE}" | grep -qE '^'"${ssid}"'$' || echo "${ssid}"
	    fi
	    echo "${WAVAILABLE}"
            exit 0
	fi
fi
if [[ "$command" == "hcitoolscan" ]]; then
	/recalbox/scripts/bluetooth/test-device list
	exit 0
fi

if [[ "$command" == "hiddpair" ]]; then
	name="$extra1"
	mac1="$mode"
	mac=`echo $mac1 | grep -oEi "([0-9A-F]{2}[:-]){5}([0-9A-F]{2})" | tr '[:lower:]' '[:upper:]'`
	macLowerCase=`echo $mac | tr '[:upper:]' '[:lower:]'`
	if [ "$?" != "0" ]; then 
		exit 1
	fi
	echo "pairing $name $mac" >>  $log
	echo $name | grep "8Bitdo\|other" >> $log
        if [ "$?" == "0" ]; then
                echo "8Bitdo detected" >> $log
                cat "/run/udev/rules.d/99-8bitdo.rules" | grep "$mac" >> /dev/null
                if [ "$?" != "0" ]; then
                        echo "adding rule for $mac" >> $log
                        echo "SUBSYSTEM==\"input\", ATTRS{uniq}==\"$macLowerCase\", MODE=\"0666\", ENV{ID_INPUT_JOYSTICK}=\"1\"" >> "/run/udev/rules.d/99-8bitdo.rules"
                fi
        fi
        /recalbox/scripts/bluetooth/simple-agent hci0 "$mac"
        connected=$?
	if [ $connected -eq 0 ]; then
                hcitool con | grep $mac1
                if [[ $? == "0" ]]; then
                        echo "bluetooth : $mac1 connected !" >> $log
                        /recalbox/scripts/bluetooth/test-device trusted "$mac" yes
                        # Save the configuration
                        btTar=/recalbox/share/system/bluetooth/bluetooth.tar
                        rm "$btTar" ; tar cvf "$btTar" /var/lib/bluetooth/
                else
                        echo "bluetooth : $mac1 failed connection" >> $log
                fi
        else
                echo "bluetooth : $mac1 failed connection" >> $log
        fi
        exit $connected
fi

if [[ "$command" == "storage" ]]; then
    if [[ "$mode" == "current" ]]; then
	if test -e $storageFile
	then
            SHAREDEVICE=`cat ${storageFile} | grep "sharedevice=" | head -n1 | cut -d'=' -f2`
            [[ "$?" -ne "0" || "$SHAREDEVICE" == "" ]] && SHAREDEVICE=INTERNAL
	    echo "$SHAREDEVICE"
	else
	    echo "INTERNAL"
	fi
	exit 0
    fi
    if [[ "$mode" == "list" ]]; then
	echo "INTERNAL"
	echo "ANYEXTERNAL"
	echo "RAM"
	(blkid | grep -vE '^/dev/mmcblk' | grep ': LABEL="'
	 blkid | grep -vE '^/dev/mmcblk' | grep -v ': LABEL="' | sed -e s+':'+': LABEL="NO_NAME"'+
	) | sed -e s+'^[^:]*: LABEL="\([^"]*\)" UUID="\([^"]*\)" TYPE="[^"]*"$'+'DEV \2 \1'+
	exit 0
    fi
    if [[ "${mode}" == "INTERNAL" || "${mode}" == "ANYEXTERNAL" || "${mode}" == "RAM" || "${mode}" == "DEV" ]]; then
	preBootConfig
	if [[ "${mode}" == "INTERNAL" || "${mode}" == "ANYEXTERNAL" || "${mode}" == "RAM" ]]; then
            if grep -qE "^sharedevice=" "${storageFile}"
	    then
               sed -i "s|sharedevice=.*|sharedevice=${mode}|g" "${storageFile}"
            else
               echo "sharedevice=${mode}" >> "${storageFile}"
            fi
	fi
	if [[ "${mode}" == "DEV" ]]; then
            if grep -qE "^sharedevice=" "${storageFile}"
	    then
               sed -i "s|sharedevice=.*|sharedevice=${mode} $extra1|g" "${storageFile}"
            else
               echo "sharedevice=${mode} ${extra1}" >> "${storageFile}"
            fi
	fi
	postBootConfig
	exit 0
    fi
fi

if [[ "$command" == "forgetBT" ]]; then
   killall -9 hcitool
   /etc/init.d/S32bluetooth stop
   rm -rf /var/lib/bluetooth
   mkdir /var/lib/bluetooth
   rm -f /recalbox/share/system/bluetooth/bluetooth.tar
   /etc/init.d/S32bluetooth start
   exit 0
fi

exit 10
