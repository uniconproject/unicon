TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs

HDRS= ../h/auto.h ../h/define.h ../h/config.h ../h/cstructs.h ../h/mproto.h \
	  ../h/typedefs.h ../h/proto.h ../h/cpuconf.h

OBJS=   long.$(O) getopt.$(O) time.$(O) filepart.$(O) identify.$(O) strtbl.$(O) rtdb.$(O)\
	mlocal.$(O) literals.$(O) rswitch.$(O) alloc.$(O) \
	save.$(O) redirerr.$(O) xwindow.$(O) dlrgint.$(O) ipp.$(O) drawstring3d.$(O)

PROGS= libucommon.a doincl$(EXE) patchstr$(EXE) libuconsole.a $(LIBWUCONSOLE)

all: $(PROGS) 

doincl$(EXE):doincl.$(O)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o doincl doincl.$(O)
	-./doincl -o ../../bin/rt.h ../h/rt.h

# TODO: if the above rule doesn't work on windows we have to make switch to the rule below
TMPdoincl.exe:     doincl.$(O)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o doincl.exe doincl.$(O) -Llibc -Lkernel64 -Lntdll -Luser64 -Lgdi64 -Lwinspool -Lcomdlg64 -LVERSION


patchstr$(EXE): patchstr.$(O)
		$(CC) $(CPPFLAGS) $(LDFLAGS) -o patchstr patchstr.$(O)
		$(CP) patchstr$(EXE) ../../bin/
		strip ../../bin/patchstr$(EXE)

# iconx needs NTConsole to be defined/set,
# make this a dependency for iconx to set it
NTCON:
	$(RM) uconsole.$(O)
	@echo set NTCONSOLE=-DNTConsole -DMSWindows
	$(eval NTCONSOLE=-DNTConsole -DMSWindows)

# set NTConsole for wiconx
WNTCON:
	$(RM) uconsole.$(O)
	@echo set NTCONSOLE=-DMSWindows
	$(eval NTCONSOLE=-DMSWindows )

libucommon.a: $(OBJS) $(HDRS)
	$(RM) $@
	$(AR) q $@ $(OBJS)
	$(RANLIB) $@
	$(CP) $@ ../../bin/

libuconsole.a: $(NTCONDEP) uconsole.$(O)
	$(RM) $@
	$(AR) q $@ uconsole.$(O)
	$(RANLIB) $@
	$(CP) $@ ../../bin/

libwuconsole.a: WNTCON wuconsole.$(O)
	$(RM) $@
	$(AR) q $@ wuconsole.$(O)
	$(RANLIB) $@
	$(CP) $@ ../../bin/

common:         doincl$(EXE) patchstr$(EXE)
		./doincl -o ../../bin/rt.h ../h/rt.h

$(OBJS): $(HDRS)

dconsole.$(O): dconsole.c
	$(CMNT)@echo "   [COMMON] $<"
	$(SLNT) $(CC) $(CPPFLAGS) $(CFLAGS) -DMSWindows -c $<

%.$(O): %.c
	$(CMNT)@echo "   [COMMON] $<"
	$(SLNT)$(CC) $(NTCONSOLE) $(CPPFLAGS) $(CFLAGS) -c $<

wuconsole.$(O): uconsole.c
	$(CMNT)@echo "   [COMMON] $<"
	$(SLNT)$(CC) $(NTCONSOLE) $(CPPFLAGS) $(CFLAGS) -c -o wuconsole.o uconsole.c

identify.$(O): ../h/version.h

ipp.$(O): ../h/feature.h

literals.$(O): ../h/esctab.h

rtdb.$(O): ../h/version.h icontype.h

#FIX: we are using $(O) everywhere but the string below is hradcoded to .o
drawstring3d.$(O): drawstring3d.cc
	@if test "`which $(CXX)`" != "" ; then \
		echo "Got C++, building drawstring3d.o"; \
		$(CXX) -c $(CPPFLAGS) $(CFLAGS) -I/usr/include/freetype2 -I/opt/X11/include/freetype2 -o drawstring3d.o drawstring3d.cc; \
	else \
		echo "No C++, too bad"; \
		echo "extern void syserr(char*); int cpp_drawstring3d(double x, double y, double z, char *s, char *f, int t, int size, void **tfont) { syserr(\"no C++; it is required for 3d fonts\"); return -1; } " > drawstring3d.c ; \
		$(CC) -c $(CPPFLAGS) $(CFLAGS) drawstring3d.c; \
		rm drawstring3d.c ; \
	fi

dlrgint.$(O): ../h/auto.h ../h/rproto.h ../h/rexterns.h ../h/rmacros.h ../h/rstructs.h

xwindow.$(O): ../h/auto.h ../h/graphics.h ../h/xwin.h

rswitch.$(O): FORCE
	$(SLNT) $(CC) $(CPPFLAGS) $(CFLAGS) -c rswitch.[cs]
FORCE:

distclean clean:
	$(RM) $(PROGS) *.o core junk*


#  The following section is needed if changes are made to the Icon grammar,
#  but it is not run as part of the normal installation process.  If it is
#  needed, it is run by changing ../icont/Makefile and/or ../iconc/Makefile;
#  see the comments there for details.  icont must be in the search path
#  for this section to work.

gfiles:			lextab.h yacctok.h fixgram pscript

lextab.h yacctok.h:	tokens.txt op.txt mktoktab
			./mktoktab

mktoktab:		mktoktab.icn
			icont -s mktoktab.icn

fixgram:		fixgram.icn
			icont -s fixgram.icn

pscript:		pscript.icn
			icont -s pscript.icn

#  The following section is commented out because it does not need to be
#  performed unless changes are made to typespec.txt. Such changes
#  and are not part of the installation process.  However, if the
#  distribution files are unloaded in a fashion such that their dates
#  are not set properly, the following section would be attempted.
#
#  Note that if any changes are made to the file mentioned above, the
#  comment characters at the beginning of the following lines should be
#  removed.
#
#  Note that icont must be on your search path for this.
#
#
#icontype.h: typespec.txt typespec
#	typespec <typespec.txt >icontype.h
#
#typespec: typespec.icn
#	icont typespec
