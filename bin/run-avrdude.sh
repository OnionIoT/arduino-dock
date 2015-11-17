#!/bin/sh

## Script to reflash ATmega328p on Onion Arduino Dock


# flash via I2C/TWI
twiFlash () {
	# use I2C to initiate a reset to bootloader
	i2cset -y 0 0x08 0xde 0xad
	sleep 1

	# flash the sketch via I2C
	# 	note: -n disables verification of flash after write
	#		required since Arduino IDE copies hex file with stock bootloader included
	twidude -a 0x29 -w flash:$1 -n
}



##################

# check the argument points to a file that exists
bExit=0
if [ "$1" == "" ]; then
	echo "ERROR: requires HEX file argument"
	exit
fi

if [ ! -f "$1" ]; then
	echo "ERROR: HEX file '$1' does not exist!"
	exit
fi


# flash the ATmega
twiFlash $1

echo "> Flash complete!"
