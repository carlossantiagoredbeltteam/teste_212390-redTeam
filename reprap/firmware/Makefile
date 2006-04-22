
# These might need configuring:
GPUTILSBASE=/usr/local/share/gputils

ifndef PROCESSOR
PROCESSOR=16f628
endif

PWD=$(CURDIR)
BASEDIR=$(PWD)

BUILDDIR=$(PWD)/build/$(PROCESSOR)
BASEBUILDDIR=$(BUILDDIR)
SUBDIRS=share devices tools

ifdef DEVICES
SUBDIRS=share devices
endif

export
.PHONY: $(SUBDIRS) sim

SDCC=sdcc -I/usr/local/share/sdcc/include/

all:	$(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	rm -rf build *~
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done

distclean:	clean
	rm -rf sdcc sdcc-build



sim:
	cd build/16f628/stepmotor && gpsim -p16f628 stepmotor.hex \
		-s stepmotor.cod
