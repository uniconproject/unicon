#  Icon source Makefile, normally used only for cleanup.

TOPDIR=..

default: all

UNICON_TOP_BUILDDIR ?= $(TOPDIR)
include $(UNICON_TOP_BUILDDIR)/Makedefs

# Sub-makes often get --jobserver-auth without -jN in MAKEFLAGS; export N so runtime/urtt matches top-level -j.
ifneq ($(filter -j%,$(MAKEFLAGS)),)
export RTT_CC_JOBS := $(patsubst -j%,%,$(filter -j%,$(MAKEFLAGS)))
endif

# Common components.
#
# Windows builds console (iconx/icont) and GUI (wiconx/wicont) variants that
# share object files rebuilt with different -DNTConsole flags. Those variants
# must stay sequential; unrelated work (iyacc, Iconc RTL, etc.) can still -j.

all: Common Icont iyacc Iconx $(WICONXTARGET) $(WICONTTARGET) $(ICONCTARGET)

Common: libs
	$(MAKE) -C common
	$(MAKE) -C rtt


libs:  $(XPM) gdbm tp

# libtp includes <ndbm.h> via sys.h (-I rt/include). gdbm copies that
# header; with -j, tp used to compile before the copy finished.
gdbm-headers:
	$(MAKE) -C gdbm CP_HEADERS

tp: gdbm-headers
	$(MAKE) -C libtp

gdbm: gdbm-headers
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

# GUI interpreter (Windows). CONSOLEOBJS are rebuilt with different -DNTConsole
# than console iconx, so these must not run in parallel with Iconx (via Icont).
#
# Important: only $(WICONXTARGET) gets the recipe. Listing Wiconx on the same
# multi-target rule as wiconx made GNU make -j run two links when "all" wanted
# wiconx and wicont depended on Wiconx.
ifneq ($(WICONXTARGET),)
$(WICONXTARGET): Icont
	$(MAKE) -C runtime $(UNICONWX)

Wiconx: $(WICONXTARGET)
ifneq ($(WICONXTARGET),wiconx)
wiconx: $(WICONXTARGET)
endif
ifneq ($(WICONXTARGET),wuniconx)
wuniconx: $(WICONXTARGET)
endif

$(WICONTTARGET): $(WICONXTARGET)
	$(MAKE) -C icont $(UNICONWT)

Wicont: $(WICONTTARGET)
ifneq ($(WICONTTARGET),wicont)
wicont: $(WICONTTARGET)
endif
ifneq ($(WICONTTARGET),wunicont)
wunicont: $(WICONTTARGET)
endif
endif

# force Iconx to always build first (shared runtime tree with compiler RTL).
Iconc: Common Iconx
	$(RM) iconc/*.$(O)
	$(RM) common/doincl$(EXE)
	$(MAKE) -C runtime comp_all_uniconc
	$(MAKE) -C iconc
	$(MAKE) -C common doincl

# Force a rebuild of a fresh Iconc  
FreshIconc:
	$(RM) runtime/*.$(O) runtime/rt.a runtime/rt.db
	$(RM) iconc/*.$(O)
	$(RM) ../bin/rt.h
	$(RM) common/doincl$(EXE)
	$(MAKE) -C runtime comp_all_uniconc
	$(MAKE) -C iconc
	$(MAKE) -C common doincl

.PHONY: Common Icont Iconx Iconc Clean Pure tp gdbm gdbm-headers xpm iyacc libs \
	Wiconx wiconx wuniconx Wicont wicont wunicont

clean Clean:
	if [ -f iyacc/Makefile ] ; then \
		cd iyacc; $(MAKE) Clean;\
	fi
	cd iconc;	$(RM) *.o $(UNICONC)$(EXE)
	cd common;	$(RM) *.o doincl$(EXE) patchstr$(EXE)
	cd preproc;	$(RM) *.o pp$(EXE)
	cd rtt;		$(RM) *.o rtt$(EXE)
	cd runtime;	$(RM) *.o *.c rt.db rt.a rttcur.lst rttfull.lst compiler-rtl-stamp $(UNICONX)$(EXE) $(UNICONWX)$(EXE)
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
