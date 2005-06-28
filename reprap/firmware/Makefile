
MASTER=master1.c master2.c
COMMTEST=commtest.cc
ALL=$(MASTER)
CXXFLAGS=-g

.c.o:
	sdcc -S -V --debug -mpic14 -p16f627 --fommit-frame-pointer $<
	gpasm -c $*.asm

all:	master.hex commtest

commtest:	$(COMMTEST:.cc=.o)
	g++ -g -o commtest $(COMMTEST:.cc=.o)

master.hex:	$(MASTER:.c=.o)
	gplink -m -c -o master.hex $(MASTER:.c=.o) pic14.a

usart.stim: Makefile
	./usartsthex -f 0 -o usart.stim -n rx1 -r 25 500 545132010001ff30

sim:	master.hex usart.stim
	gpsim -pp16f627a master.hex -s master.cod -c master.stc

clean:
	rm -f *.asm *.p *.lst *.map \
		*.adb *~ *.d usart.stim \
		*.hex *.cod *.cof *.o *.o.gcc *.dep commtest

%.dep: %.c
	$(SHELL) -ec 'gcc -MM -MG $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

%.dep: %.cc
	$(SHELL) -ec 'g++ -MM -MG $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

include $(ALL:.c=.dep)
include commtest.dep
