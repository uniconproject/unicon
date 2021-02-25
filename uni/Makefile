TOPDIR=..

default: all

include $(TOPDIR)/Makedefs
include $(TOPDIR)/Makedefs.uni

.PHONY: all unicon lib xml gui

all: nographics $(GRAPHICS)  $(UDBTOOLS)

unicon:
	cd unicon; $(MAKE)

lib: unicon
	cd lib; $(MAKE)

xml: lib
	cd xml; $(MAKE)

nographics: xml
	cd udb; $(MAKE)
	cd parser; $(MAKE)
	cd progs; $(MAKE)
	cd unidep; $(MAKE)
	cd util; $(MAKE)
	cd unidoc; $(MAKE)

udbtools:
	cd udb; $(MAKE) tools

uniprogs:
	cd progs; $(MAKE)

gui: nographics
	cd gui; $(MAKE)
	cd gui/ivib; $(MAKE)

graphics: gui
	cd ide; $(MAKE)
	cd 3d; $(MAKE)

clean Clean Pure:
	if [ -f iyacc/Makefile ] ; then \
		cd iyacc; $(MAKE) Clean;\
	fi
	cd unicon && $(MAKE) Clean
	cd udb && $(MAKE) Clean
	cd udb && $(MAKE) cleantools
	cd lib && $(MAKE) clean
	cd gui && $(MAKE) clean
	cd gui/ivib && $(MAKE) clean
	cd xml && $(MAKE) clean
	cd parser && $(MAKE) clean
	cd unidep && $(MAKE) clean
	cd progs && $(MAKE) clean
	cd util && $(MAKE) clean
	cd unidoc && $(MAKE) clean
	cd unidoc/parlett && $(MAKE) clean
	cd unidoc/parlett/docs && $(MAKE) clean
	cd ide && $(MAKE) clean
	cd 3d && $(MAKE) clean
