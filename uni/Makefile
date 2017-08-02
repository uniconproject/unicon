include ../Makedefs

.PHONY: all iyacc unicon lib xml gui

all: nographics $(GRAPHICS)

iyacc:
	cd iyacc; $(MAKE)

unicon: iyacc
	cd unicon; $(MAKE)

lib: unicon
	cd lib; $(MAKE)

xml: lib
	cd xml; $(MAKE)

nographics: xml
	cd udb; $(MAKE)
	cd udb; $(MAKE) tools
	cd progs; $(MAKE)
	cd parser; $(MAKE)
	cd unidep; $(MAKE)
	cd util; $(MAKE)
	cd unidoc; $(MAKE)


gui: nographics
	cd gui; $(MAKE)
	cd gui/ivib; $(MAKE)

graphics: gui
	cd ide; $(MAKE)
	cd 3d; $(MAKE)

clean Clean:
	if [ -f iyacc/Makefile ] ; then \
		cd iyacc; $(MAKE) Clean;\
	fi
	cd unicon; $(MAKE) Clean
	cd udb; $(MAKE) Clean
	cd ivib; $(MAKE) Clean
	cd lib; $(MAKE) clean
	cd gui; $(MAKE) clean
	cd gui/ivib; $(MAKE) clean
	cd xml; $(MAKE) clean
	cd parser; $(MAKE) clean
	cd unidep; $(MAKE) clean
	cd util; $(MAKE) clean
	cd unidoc; $(MAKE) clean
	cd unidoc/partlett; $(MAKE) clean
	cd unidoc/partlett/docs; $(MAKE) clean
	cd ide; $(MAKE) clean
	cd 3d; $(MAKE) clean
