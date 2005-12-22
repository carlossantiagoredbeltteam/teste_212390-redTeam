CLEANFILES=*.dep *~

clean:
	rm -f $(CLEANFILES)


%.dep: %.c
	$(SHELL) -ec 'gcc -MM $(CFLAGS) $< \
		| sed '\''s#\($*\)\.o[ :]*#$(BUILDDIR)/\1.o $@ : #g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

