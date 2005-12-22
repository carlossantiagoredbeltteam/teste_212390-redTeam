
SOURCES=stepmotor1.c stepmotor2.c

include ../../picmake.inc

$(BUILDDIR)/stepmotor.hex:	$(OBJS)
	cd $(BUILDDIR) && gplink -m -c -o stepmotor.hex $(SOURCES:.c=.o) $(LDFLAGS)

include ../../make.inc
include $(SOURCES:.c=.dep)
