#!/bin/sh

## Library to provide all required Arduino Dock functionality


# variable setup
UNLOCK="0x3f"
LOCK="0x0f"
EFUSE="0x05"
HFUSE="0xDA"
LFUSE="0xFF"

DOCK_LIB="/usr/share/arduino-dock"
DOCK_CONFIG="dock.conf"
AVRDUDE_CONFIG="avrdude.conf"

TWI_BOOTLOADER="twibootloader.hex"



# read the arduino dock communication interface
#	returns config via echo
#	returns 'invalid if not recognized'
GetIntfConfig () {
	# read the config file
	configFile=$(cat $DOCK_LIB/$DOCK_CONFIG | grep -v '^#')
	configIntf=$(echo $configFile | grep 'interface')

	# isolate the interface type from the config file
	interface=$(echo $configIntf | sed -e 's/^[[:space:]]*interface[[:space:]]*=[[:space:]]*//' -e 's/[[:space:]]*&//')

	# check if interface is valid
	if [ "$interface" == "twi" ]; then
		echo "twi"
	else
		echo "invalid"
	fi
}

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

### bootloader
# flash specified bootloader
#	arg1	- path to bootloader
_FlashBootloader () {
	# set the fuses
	avrdude -C $DOCK_LIB/$AVRDUDE_CONFIG -p atmega328p -c linuxgpio -P gpio -b 115200 -e -u -U lock:w:$UNLOCK:m -U efuse:w:$EFUSE:m -U hfuse:w:$HFUSE:m -U lfuse:w:$LFUSE:m

	# flash the bootloader and lock the section
	avrdude -C $DOCK_LIB/$AVRDUDE_CONFIG -p atmega328p -c linuxgpio -P gpio -b 115200 -U flash:w:$1 -U lock:w:$LOCK:m
}

# flash Onion bootloader (based on intf type)
FlashBootloader () {
	# find the interface type
	intf=$(GetIntfConfig)

	# select the appropriate bootloader
	bootloader=""
	if [ "$intf" == "twi" ]; then
		bootloader="$DOCK_LIB/$TWI_BOOTLOADER"
	else
		echo "ERROR: invalid Arduino Dock communication interface '$intf' ..."
		echo "> Not flashing bootloader ..."
		return
	fi

	# flash the bootloader
	echo "> Flashing bootloader..."
	_FlashBootloader "$bootloader"
	echo "> Done"
}


### application
# flash application via I2C/TWI
#	arg1	- path to application hex file
#	arg2	- additional arguments to twidude
_TwiFlashApplication () {
	# use I2C to initiate a reset to bootloader
	i2cset -y 0 0x08 0xde 0xad
	sleep 1

	# flash the sketch via I2C
	# 	note: -n disables verification of flash after write
	#		required since Arduino IDE copies hex file with stock bootloader included
	twidude -a 0x29 -w flash:$1
}

# flash application (based on intf type)
#	arg1	- path to application hex file
#	arg2	- additional arguments to flashing program
FlashApplication () {
	# find the interface type
	intf=$(GetIntfConfig)

	# check if invalid interface
	if [ "$intf" == "invalid" ]; then
		echo "ERROR: invalid Arduino Dock communication interface '$intf' ..."
		echo "> Not flashing application ..."
		return
	fi

	# check 

	# run the appropriate flashing subroutine
	echo "> Flashing application ..."
	if [ "$intf" == "twi" ]; then
		_TwiFlashApplication "$1" "$2"
	fi
	echo "> Done"
}


