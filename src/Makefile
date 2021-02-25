#  Icon source Makefile, normally used only for cleanup.

TOPDIR=..

default: all

include $(TOPDIR)/Makedefs

# Common components.

all: Common Icont iyacc Iconx $(WICONTTARGET) $(WICONXTARGET) $(ICONCTARGET)

Common: libs
	$(MAKE) -C common
	$(MAKE) -C rtt


libs:  $(XPM) gdbm tp

tp:
	$(MAKE) -C libtp

gdbm:
	$(MAKE) -C gdbm

xpm:
	$(MAKE) -C xpm/lib


iyacc: Icont
	$(MAKE) -C iyacc

# The interpreter: icont and iconx.

Icont:	Common Iconx
	$(MAKE) -C icont

Iconx:	Common
	$(MAKE) -C runtime interp_all

#force wiconx and wicont to be built at the end
wuniconx wiconx Wiconx:	Icont
	$(MAKE) -C runtime $(UNICONWX)
wunicont wicont Wicont: Wiconx
	$(MAKE) -C icont $(UNICONWT)

# force Iconx to always build first to avoid building part of both at the same time
Iconc: Common Iconx
	$(RM) iconc/*.$(O)
	$(RM) common/doincl$(EXE)
	$(MAKE) -j1 -C runtime comp_all_uniconc
	$(MAKE) -C iconc
	$(MAKE) -C common doincl

# Force a rebuild of a fresh Iconc  
FreshIconc:
	$(RM) runtime/*.$(O) runtime/rt.a runtime/rt.db
	$(RM) iconc/*.$(O)
	$(RM) ../bin/rt.h
	$(RM) common/doincl$(EXE)
	$(MAKE) -j1 -C runtime comp_all_uniconc
	$(MAKE) -C iconc
	$(MAKE) -C common doincl

.PHONY: Common Icont Iconx Iconc Clean Pure tp gdbm xpm iyacc libs

clean Clean:
	cd iconc;	$(RM) *.o $(UNICONC)$(EXE)
	cd common;	$(RM) *.o doincl$(EXE) patchstr$(EXE)
	cd preproc;	$(RM) *.o pp$(EXE)
	cd rtt;		$(RM) *.o rtt$(EXE)
	cd runtime;	$(RM) *.o *.c rt.db rt.a rttcur.lst rttfull.lst $(UNICONX)$(EXE) $(UNICONWX)$(EXE)
	cd icont;	$(RM) *.o $(UNICONT)$(EXE) $(UNICONWT)$(EXE)
	cd xpm;		$(RM) *.o *.a
	cd xpm/lib;	$(RM) *.o *.a
	cd libtp;	$(RM) *.o *.a config.cache
	cd libtp/uri;	$(RM) *.o *.a
	make -C libtp/tests Pure
	cd gdbm;        $(RM) *.o *.a


Pure: Clean
	$(RM) h/auto.h
	$(RM) common/rswitch.s 


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
