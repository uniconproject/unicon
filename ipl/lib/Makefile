TOPDIR = ../..
UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs.uni
all:
	$(MAKE) Cfun
	cd ../procs; $(MAKE)
	cd ../gprocs; $(MAKE)
	cd ../mprocs; $(MAKE)

Cfun:
	cd ../cfuncs; LPATH= $(MAKE) ICONT=../../bin/$(UNICONT)
	-cd ../cfuncs; $(CP) cfunc.u ../lib
	-cd ../cfuncs; cp libcfunc.so ../../bin

clean Clean Pure:
	cd ../procs; $(MAKE) Clean
	cd ../gprocs; $(MAKE) Clean
	cd ../mprocs; $(MAKE) Clean
	rm -f *.u
