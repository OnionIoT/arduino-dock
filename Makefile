SUBDIRS = twidude
ifeq ($(shell uname -s),Darwin)
	# compile twibootloader only if on OS X (Requires AVR-lib)
	SUBDIRS += twibootloader
endif

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
		done