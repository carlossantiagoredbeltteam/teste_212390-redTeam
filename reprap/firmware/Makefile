
# These might need configuring:
GPUTILSBASE=/usr/share/gputils

ifndef PROCESSOR
PROCESSOR=16f628
endif

PWD=$(CURDIR)
BASEDIR=$(PWD)
SDCCBASE=$(PWD)/sdcc
BUILDDIR=$(PWD)/build/$(PROCESSOR)
BASEBUILDDIR=$(BUILDDIR)
SUBDIRS=share devices tools

export
.PHONY: $(SUBDIRS)

SDCC=$(SDCCBASE)/bin/sdcc

all:	procheader $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	rm -rf build *~
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done

distclean:	clean
	rm -rf sdcc sdcc-build

sdcc: $(SDCCBASE)/share/sdcc/include/pic $(SDCCBASE)/inc2h.pl

# Build header files for required processor if necessary
procheader:	sdcc $(SDCCBASE)/share/sdcc/include/pic/pic$(PROCESSOR).h

$(SDCCBASE)/share/sdcc/include/pic/pic$(PROCESSOR).h:
	$(SDCCBASE)/inc2h.pl $(PROCESSOR) $(GPUTILSBASE) > \
		$(SDCCBASE)/share/sdcc/include/pic/pic$(PROCESSOR).h

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
