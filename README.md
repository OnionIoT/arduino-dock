# oboot-a
Set of tools for ATMega328p on the Onion Arduino Dock

## twibootloader
ATmega Bootloader based on TWI (Two Wire Interface/I2C) communication

### AVR-DUDE COMMANDS

#### Fuse Setup
`avrdude -p atmega328p -c linuxgpio -P gpio -b 115200 -e -u -U lock:w:0x3f:m -U efuse:w:0x05:m -U hfuse:w:0xDA:m -U lfuse:w:0x62:m`

##### Lock
Unlock : `0x3f`

| Section     | Lock |
|-------------|------|
| Application | None |
| Bootloader  | None |


##### Low Fuse
Value : `0xff`

| Bit   | Field                                        | Setting                                                                                                               | Value  |
|-------|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|--------|
| 7     | CKDIV8 Internally divide clock by 8          | Disabled                                                                                                              | 1      |
| 6     | CKOUT Clock output on PORTB0                 | Disabled                                                                                                              | 1      |
| [5:4] | SUT - Start Up Time Sets start up delay time | Crystal Oscillator, slowly rising power Startup Time from Power-down: 16K CK Additional delay from RESET: 14CK + 65ms | 0b11   |
| [3:0] | CKSEL Device clocking option                 | External low power crystal oscillator Frequency: 8 MHz to 16 MHz                                                      | 0b1111 |



##### High Fuse
Value : `0xda`

| Bit   | Field                                                  | Setting                                       | Value |
|-------|--------------------------------------------------------|-----------------------------------------------|-------|
| 7     | RSTDISBL External reset disable                        | External reset enabled                        | 1     |
| 6     | DWEN debugWIRE enabled                                 | Debug Wire disabled                           | 1     |
| 5     | SPIEN Enable Serial programming and data download      | SPI Programming enabled                       | 0     |
| 4     | WDTON Watchdog timer always-on                         | Watchdog timer NOT always-on                  | 1     |
| 3     | EESAVE Preserve EEPROM memory through Chip Erase Cycle | EESAVE disabled                               | 1     |
| [2:1] | BOOTSZ Bootloader size                                 | Bootloader section is 1024 words (2048 bytes) | 0b01  |
| 0     | BOOTRST Select reset vector                            | Reset vector  = bootloader                    | 0     |

###### BOOTSZ Settings
| BOOTSZ | Size (words) | Size (bytes | Pages | Application Start | Bootloader Start |
|--------|--------------|-------------|-------|-------------------|------------------|
| 0b11   | 256          | 512         | 4     | 0x0000            | 0x7f00           |
| 0b10   | 512          | 1024        | 8     | 0x0000            | 0x7e00           |
| 0b01   | 1024         | 2048        | 16    | 0x0000            | 0x7c00           |
| 0b00   | 2048         | 4095        | 1     | 0x0000            | 0x7800           |

BOOTRST must be SET (0b0) for BOOTSZ setting to take effect.


##### Extended Fuse
Value : `0x05`

Brown-out detection level at 2.7 V, b101




#### Flash bootloader
`avrdude -p atmega328p -c linuxgpio -P gpio -b 115200 -U flash:w:bootloader.hex -U lock:w:0x0f:m`

##### Lock Fuse
Lock : `0x0f`

| Section     | Lock                   |
|-------------|------------------------|
| Application | None                   |
| Bootloader  | LPM and SPM Prohibited |


#### Read Fuse Values
`efuse:r:efuse.hex:h -U hfuse:r:hfuse.hex:h -U lfuse:r:lfuse.hex:h`

To read the files:
`cat lock.hex ; cat efuse.hex ; cat hfuse.hex ; cat lfuse.hex`

## twidude
Utility to flash ATmega memory (flash and eeprom) via I2C

### Usage
For flashing HEX file
`twidude -a <i2c device address> -w <flash|eeprom>:<file>`

Optionally:
* `-d <I2C dev name>`
 * uses `/dev/i2c-0` by default
