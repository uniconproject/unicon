TOPDIR=..

default: all

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

all:
	$(MAKE) -C book
	$(MAKE) -C ib
	$(MAKE) -C utr

Clean clean Pure:
	cd book; $(MAKE) clean
	cd ib;   $(MAKE) clean
	cd utr;  $(MAKE) clean
