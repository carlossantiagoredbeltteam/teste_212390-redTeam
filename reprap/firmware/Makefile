
MASTER=master1.c master2.c
STEPMOTOR=stepmotor1.c stepmotor2.c
MOTOR=motor1.c motor2.c
COMMTEST=commtest.cc
POKE=poke.cc snap.cc snap_packet.cc
ALLC=$(MASTER) $(STEPMOTOR) $(MOTOR)
ALLCXX=$(COMMTEST) $(POKE)
CXXFLAGS=-g

.c.o:
	sdcc -S -V --debug -mpic14 -p16f627 --fommit-frame-pointer $<
	gpasm -c $*.asm

all:	master.hex motor.hex

commtest.o:
	$(CXX) $(CXXFLAGS) -pthread -c $<

commtest:	$(COMMTEST:.cc=.o)
	g++ -g -pthread -o commtest $(COMMTEST:.cc=.o) \
		-lboost_unit_test_framework \
		-lboost_thread

poke:	$(POKE:.cc=.o)
	g++ -g -o poke $(POKE:.cc=.o)

master.hex:	$(MASTER:.c=.o)
	gplink -m -c -o master.hex $(MASTER:.c=.o) pic14.a

stepmotor.hex:	$(STEPMOTOR:.c=.o)
	gplink -m -c -o stepmotor.hex $(STEPMOTOR:.c=.o) pic14.a

motor.hex:	$(MOTOR:.c=.o)
	gplink -m -c -o motor.hex $(MOTOR:.c=.o) pic14.a

sart.stim: Makefile
	./usartsthex -f 0 -o usart.stim -n rx1 -r 25 \
	500 54513201000030 +1000 5451320100010030

sim:	master.hex usart.stim
	gpsim -pp16f627a master.hex -s master.cod -c master.stc

clean:
	rm -f $(ALLC:.c=.asm) *.p *.lst *.map \
		*.adb *~ *.d usart.stim \
		*.hex *.cod *.cof *.o *.o.gcc *.dep commtest poke \
		nodes.tar.gz

%.dep: %.c
	$(SHELL) -ec 'gcc -MM -MG $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

%.dep: %.cc
	$(SHELL) -ec 'g++ -pthread -MM -MG $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

dist:
	tar cvfz nodes.tar.gz \
		Makefile *.c *.h *.cc usartst usartsthex \
		master.stc pic14.a

include $(ALLC:.c=.dep)
include $(ALLCXX:.cc=.dep)
