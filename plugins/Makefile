TOPDIR=..

default: all

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

all: 
	cd src; $(MAKE)
	cd rngLibraries; $(MAKE)

Clean clean:
	cd src; $(MAKE) clean
	cd rngLibraries; $(MAKE) clean
	rm -rf lib/*

Pure:
	cd src; $(MAKE) clean
	cd rngLibraries; $(MAKE) Pure
	rm -rf lib/*

install:
	cd rngLibraries; $(MAKE) install

