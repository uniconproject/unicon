#  Makefile for the (Un)Icon run-time system.

TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs


HDRS = ../h/define.h ../h/config.h ../h/typedefs.h ../h/monitor.h\
	  ../h/proto.h ../h/cstructs.h ../h/cpuconf.h ../h/grttin.h\
	  ../h/rmacros.h ../h/rexterns.h ../h/rstructs.h ../h/auto.h\
	  ../h/rproto.h ../h/mproto.h ../h/version.h ../h/sys.h

GRAPHICSHDRS = ../h/graphics.h ../h/xwin.h
GRAPHICSRI = rxwin.ri rmswin.ri rwin3d.ri ropengl.ri rd3d.ri ropengl2d.ri

.PHONY: update_rev

# default: iconx

all:	interp_all comp_all

update_rev:
	@../../config/scripts/version.sh

####################################################################
#
# Make entries for iconx
#

XOBJS=	xcnv.$(O)     xdata.$(O)    xdef.$(O)     xerrmsg.$(O)  xextcall.$(O) xfconv.$(O)  \
	xfload.$(O)   xfmath.$(O)   xfmisc.$(O)   xfmonitr.$(O) xfscan.$(O)   xfstr.$(O)   \
	xfstranl.$(O) xfstruct.$(O) xfsys.$(O)    xfwindow.$(O) ximain.$(O)   ximisc.$(O)  \
	xinit.$(O)    xinterp.$(O)  xinvoke.$(O)  xfdb.$(O)     xkeyword.$(O) xlmisc.$(O)  \
	xoarith.$(O)  xoasgn.$(O)   xocat.$(O)    xocomp.$(O)	xomisc.$(O)   xoref.$(O)   \
	xoset.$(O)    xovalue.$(O)  xralc.$(O)    xrcoexpr.$(O) xrcomp.$(O)   xrdb.$(O)    \
	xrdebug.$(O)  xrlocal.$(O)  xrlrgint.$(O) xrmemmgt.$(O) xrmisc.$(O)   xrstruct.$(O)\
	xrsys.$(O)    xrgfxsys.$(O) xrwinsys.$(O) xrwindow.$(O) xfxtra.$(O)   xrwinrsc.$(O)\
	xrposix.$(O)  xrmsg.$(O)    xraudio.$(O)

COBJS=	cnv.$(O)     data.$(O)    def.$(O)     errmsg.$(O)  extcall.$(O) fconv.$(O)  \
	fload.$(O)   fmath.$(O)   fmisc.$(O)   fmonitr.$(O) fscan.$(O)   fstr.$(O)   \
	fstranl.$(O) fstruct.$(O) fsys.$(O)    fwindow.$(O) imain.$(O)   imisc.$(O)  \
	init.$(O)    interp.$(O)  invoke.$(O)  fdb.$(O)     keyword.$(O) lmisc.$(O)  \
	oarith.$(O)  oasgn.$(O)   ocat.$(O)    ocomp.$(O)   omisc.$(O)   oref.$(O)   \
	oset.$(O)    ovalue.$(O)  ralc.$(O)    rcoexpr.$(O) rcomp.$(O)   rdb.$(O)    \
	rdebug.$(O)  rlocal.$(O)  rlrgint.$(O) rmemmgt.$(O) rmisc.$(O)   rstruct.$(O)\
	rsys.$(O)    rgfxsys.$(O) rwinsys.$(O) rwindow.$(O) fxtra.$(O)   rwinrsc.$(O)\
	rposix.$(O)  rmsg.$(O)    raudio.$(O)  $(COMMONDRAWSTRING)

# These files are affected by NTConsole on Windows
CONSOLEOBJS=  xrwindow.$(O) xrsys.$(O) xinit.$(O) xfwindow.$(O) xfsys.$(O) xrwinsys.$(O) xkeyword.$(O)

OBJS=	$(XOBJS) $(EXEICONTARGET)

interp_all: update_rev 
	$(MAKE) $(UNICONX)

# Some systems require global symbols to be left in iconx for loadfunc() to work
# but some versions of strip don't have the -x flag (e.g. strict POSIX compliance),
# so only use strip -x when it is known to be needed and available (MacOS).

# NTCONDEP is set to NTCON on windows only to add a dependency that sets NTCONSOLE
$(UNICONX) $(ICONXEXE): $(NTCONDEP) $(OBJS) ../../rt/lib/libucommon.a ../../rt/lib/libuconsole.a ../../rt/lib/libgdbm.a ../../rt/lib/libtp.a
	$(CC) $(LDFLAGS) $(WSUBSYS) $(WSTKLDFLAG) $(RLINK) -o $(UNICONX)  $(OBJS) $(XLIBS) $(RLIBS) $(XL) $(LIBSTDCPP) $(WGLIBS) -luconsole
	cp $(UNICONX)$(EXE) ../../bin
	strip $(DASHX) ../../bin/$(UNICONX)$(EXE);

# on windows, always add WNTCON dependency to set NTCONSOLE accordingly
$(UNICONWX) $(WICONEXE): WNTCON $(OBJS) ../../rt/lib/libucommon.a ../../rt/lib/libwuconsole.a ../../rt/lib/libgdbm.a ../../rt/lib/libtp.a
	$(CC) $(LDFLAGS) -Wl,--subsystem,windows $(WSTKLDFLAG) $(RLINK) -o $(UNICONWX)  $(OBJS) $(XLIBS) $(RLIBS) $(XL) $(LIBSTDCPP) $(WGLIBS) -lwuconsole
	cp $(UNICONWX)$(EXE) ../../bin
	strip $(DASHX) ../../bin/$(UNICONWX)$(EXE);

# prepare the icon for the executables
icon.$(O):
	cp -u ../../config/win32/gcc/icon.rc .
	cp -u ../../config/win32/gcc/unicon.ico .
	windres $(RCFLAGS) icon.rc icon.$(O)

#
# The following three rules are needed on windows
#

#iconx needs NTConsole to be defined/set, make this a dependency for iconx to set it
NTCON: CONSOLE icon.$(O)
	@echo set NTCONSOLE=-DNTConsole -DMSWindows
	$(eval NTCONSOLE=-DNTConsole -DMSWindows)

# set NTConsole for wiconx
WNTCON: CONSOLE icon.$(O)
	@echo set NTCONSOLE=-DMSWindows
	$(eval NTCONSOLE=-DMSWindows )

# make sure to clean the files affected by NTConsole to force rebuild them
CONSOLE:
	$(RM) $(CONSOLEOBJS)	


x%.$(O): %.r $(HDRS)
	$(CMNT)	@echo "   [ICONX RTT] $<"
	$(SLNT)$(RTT) $(NTCONSOLE) -x $<
	$(SLNT)$(CC) $(NTCONSOLE) $(CPPFLAGS) $(CFLAGS) -c x$*.c
	$(SLNT)$(RM) x$*.c

xdata.$(O): data.r $(HDRS) ../h/kdefs.h ../h/fdefs.h ../h/odefs.h

xfsys.$(O): fsys.r $(HDRS) $(GRAPHICSHDRS)

xfwindow.$(O): fwindow.r $(HDRS) $(GRAPHICSHDRS)

xkeyword.$(O): keyword.r $(HDRS) ../h/feature.h ../h/revision.h
	$(CMNT)	@echo "   [ICONX RTT] $< "
	$(SLNT)$(RTT) $(NTCONSOLE) -x keyword.r
	$(SLNT)$(CC) $(NTCONSOLE) $(CPPFLAGS) $(CFLAGS) -c xkeyword.c
	$(SLNT)$(RM) xkeyword.c

xrposix.$(O): rposix.r $(HDRS) ../h/posix.h

xrmsg.$(O): rmsg.r $(HDRS) ../h/messagin.h

xfxtra.$(O): fxtra.r fxposix.ri fxaudio.ri $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri fxaudio.ri

xrgfxsys.$(O): rgfxsys.r $(HDRS) $(GRAPHICSHDRS)

xrwinsys.$(O): rwinsys.r $(HDRS) $(GRAPHICSHDRS) $(GRAPHICSRI)

xrwindow.$(O): rwindow.r $(HDRS) $(GRAPHICSHDRS)

xrwinrsc.$(O): rwinrsc.r $(HDRS) $(GRAPHICSHDRS) rxrsc.ri


####################################################################
#
# Make entries for the compiler library
#
RTLSRC= cnv.r data.r def.r errmsg.r fconv.r fdb.r fload.r fmath.r\
	fmisc.r fmonitr.r fscan.r fstr.r fstranl.r fstruct.r\
	fsys.r fwindow.r init.r invoke.r keyword.r\
	lmisc.r oarith.r oasgn.r ocat.r ocomp.r omisc.r\
	oref.r oset.r ovalue.r ralc.r rcoexpr.r rcomp.r\
	rdb.r rdebug.r rlrgint.r rlocal.r rmemmgt.r rmisc.r rstruct.r\
	rsys.r rwinrsc.r rgfxsys.r rwinsys.r rwindow.r fxtra.r raudio.r\
	rposix.r rmsg.r

comp_all comp_all_uniconc: update_rev
	@echo "   [ICONC] This might take a while..."
	$(MAKE) rt.a

rt.a: ../../rt/lib/libucommon.a ../../rt/lib/libgdbm.a ../../rt/lib/libtp.a ../../rt/lib/libuconsole.a $(COBJS)
	$(CMNT) @echo [ICONC RTT] "-A -O ... # rt.a: "
	$(RTT) $(DASHS) -A -O  "$(COBJS) f_*.$(O) o_*$(O)"
	$(RANLIB) $@
	$(CP) rt.a ../common/dlrgint.$(O) ../../rt/lib/
	$(CP) rt.db ../../rt/lib/

keyword.$(O) : keyword.r $(HDRS) ../h/feature.h ../h/revision.h
	$(CMNT)	@echo "   [ICONC RTT] $< "
	$(SLNT)$(RTT) $(DASHS) -c -O "$(CFLAGS) $(CPPFLAGS)" keyword.r

%.$(O): %.r $(HDRS)
	$(CMNT)@echo "   [ICONC RTT] $<"
	$(SLNT)$(RTT) $(DASHS) $(WCONSOLE) -c -O "$(CFLAGS) $(CPPFLAGS)"  $<

fwindow.$(O): fwindow.r $(HDRS) $(GRAPHICSHDRS)

rmsg.$(O): rmsg.r $(HDRS) ../h/messagin.h

fxtra.$(O): fxtra.r $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri fxaudio.ri

raudio.$(O): raudio.r $(HDRS) ../h/posix.h

rposix.$(O): rposix.r $(HDRS) ../h/posix.h

rwinrsc.$(O): rwinrsc.r $(HDRS) $(GRAPHICSHDRS)

rgfxsys.$(O): rgfxsys.r $(HDRS) $(GRAPHICSHDRS)

rwinsys.$(O): rwinsys.r $(HDRS) $(GRAPHICSHDRS)

rwindow.$(O): rwindow.r $(HDRS) $(GRAPHICSHDRS)

../common/drawstring3d.o: ../common/drawstring3d.cc
	cd ../common; $(MAKE) drawstring3d.o

Pure Clean clean:
	$(RM) *.$(O)
