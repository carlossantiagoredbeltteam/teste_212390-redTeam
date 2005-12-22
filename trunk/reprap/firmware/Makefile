
# These might need configuring:
GPUTILSBASE=/usr/share/gputils

ifndef PROCESSOR
PROCESSOR=16f628
endif

PWD=$(CURDIR)
BASEDIR=$(PWD)
SDCCBASE=$(PWD)/sdcc
BUILDDIR=$(PWD)/build/$(PROCESSOR)
SUBDIRS=share devices

export
.PHONY: $(SUBDIRS)

SDCC=$(SDCCBASE)/bin/sdcc

all:	buildarea procheader $(SUBDIRS)

buildarea: $(BUILDDIR)

$(BUILDDIR):
	if [ ! -d $(BUILDDIR) ]; then mkdir -p $(BUILDDIR); fi

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	rm -rf build *~
	$(MAKE) -C share clean
	$(MAKE) -C devices clean

distclean:	clean
	rm -rf sdcc sdcc-build

sdcc: $(SDCCBASE)/share/sdcc/include/pic $(SDCCBASE)/inc2h.pl

# Build header files for required processor if necessary
procheader:	sdcc $(SDCCBASE)/share/sdcc/include/pic/pic$(PROCESSOR).h

$(SDCCBASE)/share/sdcc/include/pic/pic$(PROCESSOR).h:
	$(SDCCBASE)/inc2h.pl 16f627 $(GPUTILSBASE) > \
		$(SDCCBASE)/share/sdcc/include/pic/pic16f627.h

# Build sdcc (and extra pic include directory)
$(SDCCBASE)/share/sdcc/include/pic:
	if [ ! -d sdcc-build ]; then mkdir sdcc-build; fi
	cd sdcc-build && \
		CVSROOT=:pserver:anonymous@cvs.sourceforge.net:/cvsroot/sdcc cvs co -D 20051210 sdcc && \
		cd sdcc && \
		./configure --prefix=$(SDCCBASE) && \
		make clean && \
		make && \
		make install && \
		mkdir $(SDCCBASE)/share/sdcc/include/pic

# Install tool for creating header files
$(SDCCBASE)/inc2h.pl:
	cp sdcc-build/sdcc/support/scripts/inc2h.pl $(SDCCBASE)
