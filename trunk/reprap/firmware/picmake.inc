
$(BUILDDIR)/%.o: %.c
	cd $(BUILDDIR) && $(SDCC) -I$(BASEDIR)/share -S -mpic14 -p$(PROCESSOR) $(PWD)/$< && \
		gpasm -c $*.asm

%.o: %.c
	echo $< to $*

OBJS=$(SOURCES:%.c=$(BUILDDIR)/%.o)
CC=$(SDCC)
CFLAGS=-I$(BASEDIR)/share
CXXFLAGS=$(CFLAGS)
PWD=$(CURDIR)
LDFLAGS=$(BASEDIR)/share/pic14.a serial.lib
