include ../Makedefs

all :
	cd iyacc; $(MAKE)
	cd unicon; $(MAKE)
	cd lib; $(MAKE)
	cd udb; $(MAKE)
#	cd udb; $(MAKE) tools
	cd xml; $(MAKE)
	cd progs; $(MAKE)
	cd gui; $(MAKE)
	cd gui/ivib; $(MAKE)
	cd parser; $(MAKE)
	cd unidep; $(MAKE)
	cd util; $(MAKE)
	cd unidoc; $(MAKE)
	cd ide; $(MAKE)
	cd 3d; $(MAKE)

clean Clean:
	cd iyacc; $(MAKE) Clean
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
