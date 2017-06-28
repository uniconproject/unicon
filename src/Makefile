#  Icon source Makefile, normally used only for cleanup.

include ../Makedefs

# Common components.

Common:
	$(MAKE) -C common
	$(MAKE) -C rtt

# The interpreter: icont and iconx.

Icont:	Common Iconx
	$(MAKE) -C icont

Iconx:	Common
	$(MAKE) -C runtime interp_all


Iconc: Common
	$(MAKE) -C runtime comp_all_uniconc
	$(MAKE) -C iconc

Clean Pure:
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


Clean Pure:
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
