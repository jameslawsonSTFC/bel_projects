# Two examples are provided
# - miniExample: 'hello world' for lm32
# - example: demo program including
# -- shared memory for exchange of data via Wishbone
# -- access to other Wishbone devices
# -- receive commands via shared memory
# -- get actions from the ECA by polling
#
# Example usage:
#   make TARGET=example
#   ... will compile the more complex example program
TARGET		?= miniExample
.DEFAULT_GOAL := fwbin
DEVICE		= 5AGXMA3D4
FLASH		= EPCQ256
SPI_LANES	= ASx4
RAM_SIZE	= 49152 
SHARED_SIZE     = 8K
USRCPUCLK       = 125000
VERSION         = 0.0.1

PATHFW 	= .
PATHPKG	= $(shell python2.7 ../../ip_cores/hdl-make/hdlmake list-mods | grep -G '^[^\#]' | grep top | grep -o '^\S*')
PREFIX 	?= /usr/local
CFLAGS 	= -I$(PATHFW) 


include ../../syn/build.mk


fwbin: $(TARGET).bin

$(TARGET).elf: $(PATHFW)/$(TARGET).c $(PATHFW)/../../top/gsi_scu/scu_mil.c

clean::
	rm -f $(PATHFW)/*.o $(PATHFW)/*.a $(PATHFW)/*.elf $(PATHFW)/*.bin


