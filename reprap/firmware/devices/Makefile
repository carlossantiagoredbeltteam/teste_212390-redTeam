
SUBDIRS=stepmotor stepmotorb stepmotorc stepmotor-small extruder_0_ extruder_1_ iobox

ifdef DEVICES
SUBDIRS=$(DEVICES)
endif

export
.PHONY: $(SUBDIRS)

subdirs:	$(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	rm -f *~
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done
