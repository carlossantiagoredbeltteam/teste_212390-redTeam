TARGET=extruder

SOURCES=extruder1.c extruder2.c

include ../../picmake.inc

CFLAGS += -DPORT=5

$(BUILDDIR)/$(TARGET).hex:	$(OBJS) $(PICDEPS)
	cd $(BUILDDIR) && gplink -m -c -o $(TARGET).hex $(SOURCES:.c=.o) $(LDFLAGS)
	perl $(BASEDIR)/tools/checkmap $(BUILDDIR)/$(TARGET).map

include ../../make.inc
include $(SOURCES:.c=.dep)
