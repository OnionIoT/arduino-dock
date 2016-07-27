#!/bin/sh

## Library to provide all required Arduino Dock R2 functionality


# variable setup
UNLOCK="0x3f"
LOCK="0x0f"
EFUSE="0x05"
HFUSE="0xDA"
LFUSE="0xFF"

DOCK_LIB="/usr/share/arduino-dock"
AVRDUDE_CONFIG="avrdude.conf"


# check if file exists
#	arg1	- path to file
CheckHexFile () {
	# check for argument
	if [ "$1" == "" ]; then
		echo "is missing"
		return
	fi

	# check if file exists
	if [ ! -f "$1" ]; then
		echo "does not exist"
		return
	fi

	echo "valid"
}

# set avrdude linuxgpio pins to output
_SetAvrPins () {
	gpioctl dirout 15 >& /dev/null
	gpioctl dirout 16 >& /dev/null
	gpioctl dirout 17 >& /dev/null
	gpioctl dirout 19 >& /dev/null
}

# flash application 
#	arg1	- path to application hex file
_FlashApplication () {
	# set avrdude gpio pins to output
	_SetAvrPins

	# set the fuses
	avrdude -C $DOCK_LIB/$AVRDUDE_CONFIG -p atmega328p -c linuxgpio -P gpio -b 115200 -e -u -U lock:w:$UNLOCK:m -U efuse:w:$EFUSE:m -U hfuse:w:$HFUSE:m -U lfuse:w:$LFUSE:m

	# flash the bootloader and lock the section
	avrdude -C $DOCK_LIB/$AVRDUDE_CONFIG -p atmega328p -c linuxgpio -P gpio -b 115200 -U flash:w:$1 -U lock:w:$LOCK:m

}

# flash application (based on intf type)
#	arg1	- path to application hex file
#	arg2	- additional arguments to flashing program
FlashApplication () {
	# run the appropriate flashing subroutine
	echo "> Flashing application '$1' ..."
	_FlashApplication "$1" "$2"
	
	echo "> Done"
}


