
SUBDIRS=stepmotor stepmotor2

export
.PHONY: $(SUBDIRS)

subdirs:	$(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	rm -f *~
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir clean; done
