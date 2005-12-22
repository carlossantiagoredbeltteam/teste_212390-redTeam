
POKE=poke.cc snap.cc snap_packet.cc

ALLCXX=$(POKE)

poke:	$(POKE:.cc=.o)
	g++ -g -o poke $(POKE:.cc=.o)

clean:
	rm -f poke $(ALLCXX:.cc=.o) *~ $(ALLCXX:.cc=.dep)

%.dep: %.cc
	$(SHELL) -ec 'g++ -pthread -MM -MG $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

include $(ALLCXX:.cc=.dep)
