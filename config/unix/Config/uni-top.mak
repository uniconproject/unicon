include ../Makedefs

# check if we have #define Graphics 1"
GG=\#define Graphics 1
DOG=$(shell grep -o '$(GG)' ../src/h/define.h)

ifeq ($(DOG),$(GG))
GUI=graphics
endif

all: nographics $(GUI)

nographics:
	cd iyacc; $(MAKE)
	cd unicon; $(MAKE)
	cd lib; $(MAKE)
	cd udb; $(MAKE)
	cd udb; $(MAKE) tools
	cd progs; $(MAKE)
	cd xml; $(MAKE)
	cd parser; $(MAKE)
	cd unidep; $(MAKE)
	cd util; $(MAKE)
	cd unidoc; $(MAKE)


graphics:
	cd gui; $(MAKE)
	cd gui/ivib; $(MAKE)
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
	cd ide; $(MAKE) clean
	cd 3d; $(MAKE) clean
