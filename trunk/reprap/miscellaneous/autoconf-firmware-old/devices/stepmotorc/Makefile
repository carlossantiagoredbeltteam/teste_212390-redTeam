
# This is a special target that just rebuilds another copy
# of stepmotor, but with a different address

CFLAGS += -DPORT=4
TARGET=stepmotorc



SOURCES=stepmotor1.c stepmotor2.c
include ../../picmake.inc

CFLAGS += -I$(CURDIR)/../stepmotor

$(BUILDDIR)/$(TARGET).hex:	$(SOURCES) $(OBJS) $(PICDEPS)
	cd $(BUILDDIR) && gplink -m -c -o $(TARGET).hex $(OBJS) $(LDFLAGS)
	perl $(BASEDIR)/tools/checkmap $(BUILDDIR)/$(TARGET).map

$(SOURCES):
	ln -sf ../stepmotor/$*.c .

include ../../make.inc
include $(SOURCES:.c=.dep)
