include ../../Makedefs


OBJS=	long.o getopt.o time.o filepart.o identify.o strtbl.o rtdb.o\
	mlocal.o literals.o rswitch.o alloc.o\
	save.o rswitch.o redirerr.o xwindow.o dlrgint.o ipp.o

common:		doincl.o patchstr.o
		$(CC) $(LDFLAGS) -o doincl doincl.o
		$(CC) $(LDFLAGS) -o patchstr patchstr.o
		-./doincl -o ../../bin/rt.h ../h/rt.h
		cp patchstr ../../bin

gdbm:
	cd ../gdbm; $(MAKE) libgdbm.a
	cp ../gdbm/libgdbm.a ../../bin
	-(test -f ../../NoRanlib) || (ranlib ../../bin/libgdbm.a)

libtp:
	cd ../libtp; $(MAKE)
	cp ../libtp/libtp.a ../../bin
	-(test -f ../../NoRanlib) || (ranlib ../../bin/libtp.a)

xpm:
	cd ../xpm/lib; $(MAKE) libXpm.a
	cp ../xpm/lib/libXpm.a ../../bin
	-(test -f ../../NoRanlib) || (ranlib ../../bin/libXpm.a)

$(OBJS): ../h/define.h ../h/config.h ../h/cstructs.h ../h/mproto.h \
	  ../h/typedefs.h ../h/proto.h ../h/cpuconf.h

identify.o: ../h/version.h

ipp.o: ../h/feature.h

literals.o: ../h/esctab.h

rtdb.o: ../h/version.h icontype.h

drawstring3d.o: drawstring3d.cc
	if test "`which $(CXX)`" != "" ; then \
		echo "Got C++, building drawstring3d.o"; \
		$(CXX) -c $(CFLAGS) -I/usr/include/freetype2 -I/opt/X11/include/freetype2 -o drawstring3d.o drawstring3d.cc; \
	else \
		echo "No C++, too bad"; \
		echo "extern void syserr(char*); int cpp_drawstring3d(double x, double y, double z, char *s, char *f, int t, int size, void **tfont) { syserr(\"no C++; it is required for 3d fonts\"); return -1; } " > drawstring3d.c ; \
		$(CC) -c $(CFLAGS) drawstring3d.c; \
		rm drawstring3d.c ; \
	fi

dlrgint.o: ../h/rproto.h ../h/rexterns.h ../h/rmacros.h ../h/rstructs.h

xwindow.o: ../h/graphics.h ../h/xwin.h

rswitch.o: FORCE
	$(CC) $(CFLAGS) -c rswitch.[cs]
FORCE:

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
