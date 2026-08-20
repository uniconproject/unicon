TOPDIR = ../..
UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs.uni
all:
	$(MAKE) Cfun
	cd ../procs; $(MAKE)
	cd ../gprocs; $(MAKE)
	cd ../mprocs; $(MAKE)

# CFUNCTARGET is "windows" / "disabled" when the shared lib is not built; only
# copy artifacts when they exist (avoids noisy ignored cp errors on Windows).
Cfun:
	cd ../cfuncs; LPATH= $(MAKE) ICONT=../../bin/$(UNICONT)
	@if test -f ../cfuncs/cfunc.u; then $(CP) ../cfuncs/cfunc.u ../lib; fi
	@if test -f ../cfuncs/libcfunc.so; then $(CP) ../cfuncs/libcfunc.so ../../bin; fi

clean Clean Pure:
	cd ../procs; $(MAKE) Clean
	cd ../gprocs; $(MAKE) Clean
	cd ../mprocs; $(MAKE) Clean
	rm -f *.u
