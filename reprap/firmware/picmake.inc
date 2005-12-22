

ifdef TARGET
BUILDDIR=$(BASEBUILDDIR)/$(TARGET)
endif

$(BUILDDIR)/%.o: %.c
	mkdir -p $(BUILDDIR)
	cd $(BUILDDIR) && $(SDCC) -S -mpic14 -p$(PROCESSOR) -o $*.asm $(CFLAGS) $(PWD)/$< && \
		gpasm -c $*.asm

%.o: %.c
	echo $< to $*

OBJS=$(SOURCES:%.c=$(BUILDDIR)/%.o)
CC=$(SDCC)
CFLAGS=-I$(BASEDIR)/share -D__$(PROCESSOR)
CXXFLAGS=$(CFLAGS)
PWD=$(CURDIR)
LDFLAGS=$(BASEDIR)/share/pic14.a $(BASEBUILDDIR)/serial.lib
