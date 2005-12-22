
SOURCES=stepmotor1.c stepmotor2.c

include ../../picmake.inc

CFLAGS += -DPORT=2

$(BUILDDIR)/stepmotor.hex:	$(OBJS)
	cd $(BUILDDIR) && gplink -m -c -o stepmotor.hex $(SOURCES:.c=.o) $(LDFLAGS)
	perl $(BASEDIR)/tools/checkmap $(BUILDDIR)/stepmotor.map

include ../../make.inc
include $(SOURCES:.c=.dep)
