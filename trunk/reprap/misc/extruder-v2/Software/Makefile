#
# Reprap
# 
# Makefile for the C code for the PIC in the extruder
#
# see http://reprap.org
#

# You may need to change this line for your system:

SDCCLIB=/usr/local/share/sdcc/lib/pic/



extruder.hex:	obj/extruder.o
	gplink -m -c -o extruder.hex obj/extruder.o  $(SDCCLIB)/libsdcc.lib

obj/extruder.o:	asm/extruder.asm
	gpasm -c -o obj/extruder.o asm/extruder.asm

asm/extruder.asm:	src/extruder.c include/extruder.h
	sdcc -Iinclude -S -V -mpic14 -p16f628 -o asm/extruder.asm src/extruder.c

clean:
	rm -f asm/extruder.asm extruder.hex asm/extruder.p obj/extruder.o extruder.cod \
	extruder.cof extruder.lst extruder.map obj/extruder.lst extruder.p asm/extruder.d

