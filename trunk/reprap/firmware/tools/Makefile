
POKE=poke.cc snap.cc snap_packet.cc

ALLCXX=$(POKE)

poke:	$(POKE:.cc=.o)
	g++ -g -o poke $(POKE:.cc=.o)

clean:
	rm -f poke $(ALLCXX:.cc=.o) *~
