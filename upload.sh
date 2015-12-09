#!/bin/sh

# check for argument
if [ "$1" == "" ]
then
	echo "ERROR: expecting Omega hex code as argument!"
	echo "$0 <hex code>"
	exit
fi

###############
localPath="bin/arduino-dock-lib.sh"
remotePath="/usr/share/arduino-dock/arduino-dock-lib.sh"

cmd="rsync -va --progress $localPath root@omega-$1.local:$remotePath"
echo "$cmd"
eval "$cmd"

###############
localPath="bin/arduino-dock.sh"
remotePath="/usr/bin/arduino-dock"

cmd="rsync -va --progress $localPath root@omega-$1.local:$remotePath"
echo "$cmd"
eval "$cmd"

###############
localPath="bin/run-avrdude.sh"
remotePath="/usr/bin/run-avrdude"

cmd="rsync -va --progress $localPath root@omega-$1.local:$remotePath"
echo "$cmd"
eval "$cmd"

###############
localPath="bin/merge-sketch-with-bootloader.lua"
remotePath="/usr/bin/merge-sketch-with-bootloader.lua"

cmd="rsync -va --progress $localPath root@omega-$1.local:$remotePath"
echo "$cmd"
eval "$cmd"

