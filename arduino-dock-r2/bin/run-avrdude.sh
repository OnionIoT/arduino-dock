#!/bin/sh

## Script to reflash ATmega328p on Onion Arduino Dock R2


# include the arduino dock sh library
. /usr/share/arduino-dock/arduino-dock-lib.sh


##################
# check the argument points to a file that exists
arg=$(CheckHexFile "$1")

if [ "$arg" != "valid" ]; then
	echo "ERROR: hex file argument $arg"
	exit
fi


# flash the ATmega
FlashApplication "$1" "$arg"

echo "> Flash complete!"
