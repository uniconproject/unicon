TOPDIR=..

default: all

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

all: 
	cd src; $(MAKE)

Clean clean:
	cd src; $(MAKE) clean
	rm -rf lib/*

Pure:
	cd src; $(MAKE) clean
	rm -rf lib/*
