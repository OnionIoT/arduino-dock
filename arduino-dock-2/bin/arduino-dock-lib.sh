#!/bin/sh

# include the Onion sh lib
. /usr/lib/onion/lib.sh

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
	if  [ "$(GetDeviceType)" == "$DEVICE_OMEGA2" ] ||
            [ "$(GetDeviceType)" == "$DEVICE_OMEGA2P" ];
	then
		omega2-ctrl gpiomux set pwm1 gpio >& /dev/null
	fi

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
	AVRDUDE_RESULT=$?

	# flash the bootloader and lock the section
	if [ $AVRDUDE_RESULT -eq 0 ]
	then
		avrdude -C $DOCK_LIB/$AVRDUDE_CONFIG -p atmega328p -c linuxgpio -P gpio -b 115200 -U flash:w:$1 -U lock:w:$LOCK:m
		AVRDUDE_RESULT=$?
	fi

	echo "$AVRDUDE_RESULT"
}

# flash application (based on intf type)
#	arg1	- path to application hex file
#	arg2	- additional arguments to flashing program
FlashApplication () {
	# run the appropriate flashing subroutine
	echo "> Flashing application '$1' ..."
	success=$(_FlashApplication "$1" "$2")

	if [ $success -eq 0 ]
	then
		echo "> Done, flash successful"
	else
		echo "> ERROR, flash NOT successful"
	fi
}
