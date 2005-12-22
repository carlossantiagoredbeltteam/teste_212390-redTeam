
SUBDIRS=stepmotor

export
.PHONY: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	rm -f *~
	$(MAKE) -C stepmotor clean
