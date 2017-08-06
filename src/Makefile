#  Icon source Makefile, normally used only for cleanup.

include ../Makedefs

# Common components.

all: Common Icont Iconx $(ICONCTARGET)


Common: libs
	$(MAKE) -C common
	$(MAKE) -C rtt


libs: gdbm tp $(XPM)

tp:
	$(MAKE) -C libtp

gdbm:
	$(MAKE) -C gdbm

xpm:
	$(MAKE) -C xpm/lib

# The interpreter: icont and iconx.

Icont:	Common Iconx
	$(MAKE) -C icont

Iconx:	Common
	$(MAKE) -C runtime interp_all

# force Iconx to always build first to avoid building part of both at the same time
Iconc: Common Iconx
	$(MAKE) -j1 -C runtime comp_all_uniconc
	$(MAKE) -C iconc

.PHONY: Common Icont Iconx Iconc Clean Pure tp gdbm xpm libs

clean Clean:
	cd iconc;	rm -f *.o iconc
	cd common;	rm -f *.o doincl patchstr
	cd preproc;	rm -f *.o pp
	cd rtt;		rm -f *.o rtt
	cd runtime;	rm -f *.o *.c rt.db rt.a rttcur.lst rttfull.lst iconx
	cd icont;	rm -f *.o icont
	cd xpm;		rm -f *.o *.a
	cd xpm/lib;	rm -f *.o *.a
	cd libtp;	rm -f *.o *.a config.cache
	cd libtp/uri;	rm -f *.o *.a
	cd libtp/tests;	rm -f *.o *.a
	cd gdbm;        rm -f *.o *.a


Pure: Clean
	cd iconc;	rm -f *.o iconc
	cd common;	rm -f *.o doincl patchstr
	cd preproc;	rm -f *.o pp
	cd rtt;		rm -f *.o rtt
	cd runtime;	rm -f *.o *.c rt.db rt.a rttcur.lst rttfull.lst iconx
	cd icont;	rm -f *.o icont
	cd xpm;		rm -f *.o *.a
	cd xpm/lib;	rm -f *.o *.a
	cd libtp;	rm -f *.o *.a config.cache
	cd libtp/uri;	rm -f *.o *.a
	cd libtp/tests;	rm -f *.o *.a
	cd gdbm;        rm -f *.o *.a
# force full runtime system rebuild
	touch h/define.h


#  The following entry forces rebuilding of everthing from first-generation
#  files, even files not normally recreated.  Doing this requires uncommenting
#  some lines in common/Makefile, icont/Makefile, and iconc/Makefile.

Force-rebuild: Clean
	cd h; rm -f kdefs.h
	cd common; rm -f *.o yacctok.h lextab.h icontype.h \
		doincl fixgram mktoktab patchstr pscript typespec
	cd icont; rm -f *.o icont mkkwd trash \
		hdr.h keyword.h tgram.g ttoken.h tparse.c
	cd iconc; rm -f *.o iconc cgram.g ctoken.h cparse.h
