#!/bin/sh

## Script to reflash ATmega328p on Onion Arduino Dock


# include the arduino dock sh library
. /usr/share/arduino-dock/arduino-dock-lib.sh


##################
# check the argument points to a file that exists
arg=$(CheckHexFile "$1")

if [ "$arg" != "valid" ]; then
	echo "ERROR: hex file argument $arg"
	exit
fi


# find any additional required arguments based on communication interface
arg=""
intf=$(GetIntfConfig)
if [ "$intf" == "twi" ]; then
	# 	note: -n disables verification of flash after write
	#		required since Arduino IDE copies hex file with stock bootloader included
	arg="-n"
fi


# flash the ATmega
FlashApplication "$1" "$arg"

echo "> Flash complete!"
