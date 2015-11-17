# oboot-a
Set of tools for ATMega328p on the Onion Arduino Dock

## twibootloader
ATmega Bootloader based on TWI (Two Wire Interface/I2C) communication

### AVR-DUDE COMMANDS

#### Fuse Setup
`avrdude -p atmega328p -c linuxgpio -P gpio -b 115200 -e -u -U lock:w:0x3f:m -U efuse:w:0x05:m -U hfuse:w:0xDA:m -U lfuse:w:0x62:m`

##### Lock
Unlock : `0x3f` 
Allow writing to the bootloader section

##### Low Fuse
Value : `0xff`

##### High Fuse
Value : `0xda`

##### Extended Fuse
Value : `0x05`

#### Flash bootloader
`avrdude -p atmega328p -c linuxgpio -P gpio -b 115200 -U flash:w:bootloader.hex -U lock:w:0x0f:m`

#### Read Fuse Values
`efuse:r:efuse.hex:h -U hfuse:r:hfuse.hex:h -U lfuse:r:lfuse.hex:h`

To read the files:
`cat lock.hex ; cat efuse.hex ; cat hfuse.hex ; cat lfuse.hex`

## twidude
Utility to flash ATmega memory (flash and eeprom) via I2C

