
SOURCES=serial1.c serial2.c

include ../picmake.inc

$(BUILDDIR)/serial.lib:	$(OBJS)
	gplib -c $(BUILDDIR)/serial.lib $(OBJS)

include ../make.inc

include $(SOURCES:.c=.dep)
