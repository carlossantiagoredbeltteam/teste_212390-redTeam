cartesian.hex:	obj/cartesian.o
	gplink -m -c -o cartesian.hex obj/cartesian.o lib/pic14.a

obj/cartesian.o:	asm/cartesian.asm
	gpasm -c -o obj/cartesian.o asm/cartesian.asm

asm/cartesian.asm:	src/cartesian.c include/cartesian.h
	sdcc -Iinclude -S -V -mpic14 -p16f628 -o asm/cartesian.asm src/cartesian.c

ran-light:	src/ran-light.cxx include/ran-light.h
	g++ -g -Wno-deprecated -I./include -o ran_light src/ran-light.cxx

clean:
	rm -f asm/cartesian.asm cartesian.hex asm/cartesian.p obj/cartesian.o cartesian.cod \
	cartesian.cof cartesian.lst cartesian.map obj/cartesian.lst cartesian.p asm/cartesian.d

