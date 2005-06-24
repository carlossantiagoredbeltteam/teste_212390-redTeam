
MASTER=master1.c master2.c

.c.o:
	sdcc -S -V --debug -mpic14 -p16f628 --fommit-frame-pointer $<
	gpasm -c $*.asm

all:	master.hex

master.hex:	$(MASTER:.c=.o)
	gplink -m -c -o master.hex $(MASTER:.c=.o) pic14.a

clean:
	rm -f *.asm *.p *.lst *.map \
		*.adb *~ *.d \
		*.hex *.cod *.cof *.o *.o.gcc *.dep

%.dep: %.c
	$(SHELL) -ec 'gcc -MM -MG $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

include $(MASTER:.c=.dep)
