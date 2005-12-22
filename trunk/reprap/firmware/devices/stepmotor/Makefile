TARGET=stepmotor

SOURCES=stepmotor1.c stepmotor2.c

include ../../picmake.inc

CFLAGS += -DPORT=2

$(BUILDDIR)/$(TARGET).hex:	$(OBJS)
	cd $(BUILDDIR) && gplink -m -c -o $(TARGET).hex $(SOURCES:.c=.o) $(LDFLAGS)
	perl $(BASEDIR)/tools/checkmap $(BUILDDIR)/$(TARGET).map

include ../../make.inc
include $(SOURCES:.c=.dep)
