#!bin/sh

## Script to provide all required Arduino Dock functionality

# include the arduino dock sh library
. /usr/share/arduino-dock/arduino-dock-lib.sh

usage () {
	echo "Functionality:"
	echo "	Setup and use the Onion Arduino Dock"
	echo ""
	echo "Usage:"
	echo "$0 flash bootloader"
	echo "	Flashes any connected ATmega chip with Onion-customized ATmega bootloader"
	echo "		Pin mapping:"
	echo "		Omega GPIO		Arduino ICSP Pin"
	echo "		1 				miso"
	echo "		6 				sck"
	echo "		7 				reset"
	echo "		19 				mosi"
	echo "" 
	echo "Usage:"
	echo "$0 flash <hex file>"
	echo "	Flashes ATmega on Arduino Dock with specified hex file"
	echo ""
}



# setup variables
bUsage=1
bFlashBootloader=0
bFlashApplication=0
applicationHex=""
options=""

# parse the arguments
while [ "$1" != "" ]
do
	case "$1" in
		flash|-flash)
			bUsage=0
			shift
			case "$1" in
				bootloader)
					# flash the bootloader
					bFlashBootloader=1
				;;
				*)	
					# flash an application hex file
					bFlashApplication=1
					applicationHex="$1"
				;;
			esac	
		;;
		option|-option)
			shift 
			options="$1"
		;;	
		*)
			echo "ERROR: Invalid Argument: $1"
			echo ""
			bUsage=1
			shift
		;;
	esac
	shift
done

if [ $bUsage == 1 ]
then
	# print the usage instructions
	usage
	exit
fi

if [ $bFlashBootloader == 1 ]
then
	FlashBootloader
	exit
fi

if [ $bFlashApplication == 1 ]
then
	FlashApplication "$applicationHex" "$options"
	exit
fi

