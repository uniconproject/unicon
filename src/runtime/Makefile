#  Makefile for the (Un)Icon run-time system.

include ../../Makedefs

REPO_REV='"$(shell LC_ALL=C svnversion -cn ../../ | sed -e "s/.*://" -e "s/\([0-9]*\).*/\1/" | grep "[0-9]" )"'
RTT=../../bin/rtt

RM=rm -f
O=o

HDRS = ../h/define.h ../h/config.h ../h/typedefs.h ../h/monitor.h\
	  ../h/proto.h ../h/cstructs.h ../h/cpuconf.h ../h/grttin.h\
	  ../h/rmacros.h ../h/rexterns.h ../h/rstructs.h ../h/auto.h\
	  ../h/rproto.h ../h/mproto.h ../h/version.h ../h/sys.h

GRAPHICSHDRS = ../h/graphics.h ../h/xwin.h
GRAPHICSRI = rmac.ri rxwin.ri rmswin.ri rwin3d.ri ropengl.ri rd3d.ri

# default: iconx

all:	interp_all comp_all

####################################################################
#
# Make entries for iconx
#

XOBJS=	xcnv.$(O) xdata.$(O) xdef.$(O) xerrmsg.$(O) xextcall.$(O) xfconv.$(O) xfload.$(O) xfmath.$(O)\
	xfmisc.$(O) xfmonitr.$(O) xfscan.$(O) xfstr.$(O) xfstranl.$(O) xfstruct.$(O) xfsys.$(O)\
	xfwindow.$(O) ximain.$(O) ximisc.$(O) xinit.$(O) xinterp.$(O) xinvoke.$(O) xfdb.$(O)\
	xkeyword.$(O) xlmisc.$(O) xoarith.$(O) xoasgn.$(O) xocat.$(O) xocomp.$(O)\
	xomisc.$(O) xoref.$(O) xoset.$(O) xovalue.$(O) xralc.$(O) xrcoexpr.$(O) xrcomp.$(O) xrdb.$(O)\
	xrdebug.$(O) xrlocal.$(O) xrlrgint.$(O) xrmemmgt.$(O) xrmisc.$(O) xrstruct.$(O) xrsys.$(O)\
	xrgfxsys.$(O) xrwinsys.$(O) xrwindow.$(O) xfxtra.$(O) xrwinrsc.$(O) xrposix.$(O) xrmsg.$(O)\
  xraudio.$(O)

COBJS=	../common/long.$(O) ../common/time.$(O) ../common/save.$(O) \
	../common/redirerr.$(O) ../common/xwindow.$(O) ../common/alloc.$(O)\
	../common/rswitch.$(O) ../common/filepart.$(O) ../common/mlocal.$(O) $(COMMONDRAWSTRING)

ICOBJS=	long.$(O) time.$(O) save.$(O) rswitch.$(O) redirerr.$(O) xwindow.$(O) alloc.$(O) filepart.$(O) mlocal.$(O) $(DRAWSTRING)

OBJS=	$(XOBJS) $(COBJS)

interp_all:
	cd ../common; $(MAKE) $(ICOBJS) $(XPM) $(GDBM) $(LIBTP) $(DRAWSTRING)
	$(MAKE) iconx

iconx: $(OBJS)
	$(CC) $(RLINK) -o iconx  $(OBJS) $(XLIBS) $(RLIBS) $(XL) $(LIBSTDCPP)
	cp iconx ../../bin
# Some systems require global symbols to be left in iconx for loadfunc() to work
# but some versions of strip don't have the -x flag (e.g. strict POSIX compliance),
# so only use -x when it is known to be needed and available.
	@if grep -q "MacOS" ../../src/h/define.h; then \
		strip -x ../../bin/iconx; \
	else \
		strip ../../bin/iconx; \
	fi

x%.$(O): %.r $(HDRS)
	$(CMNT)	@echo "   [ICONX RTT] $<"
	$(SLNT)$(RTT) -x $<
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -c x$*.c
	$(SLNT)$(RM) x$*.c

xdata.$(O): data.r $(HDRS) ../h/kdefs.h ../h/fdefs.h ../h/odefs.h

xfsys.$(O): fsys.r $(HDRS) $(GRAPHICSHDRS)

xfwindow.$(O): fwindow.r $(HDRS) $(GRAPHICSHDRS)

xkeyword.$(O): keyword.r $(HDRS) ../h/feature.h
	$(CMNT)	@echo "   [ICONX RTT] $<  (revision:$(REPO_REV))"
	$(SLNT)$(RTT) -DREPO_REVISION=$(REPO_REV) -x keyword.r
	$(SLNT)$(CC) $(CPPFLAGS) $(CFLAGS) -DREPO_REVISION=$(REPO_REV) -c xkeyword.c
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

comp_all comp_all_uniconc:
	cd ../common; $(MAKE) $(ICOBJS) dlrgint.o $(XPM) $(GDBM) $(LIBTP)
	$(MAKE) db_lib

db_lib: rt.db rt.a

#
# if rt.db is missing or any header files have been updated, recreate
# rt.db from scratch along with the .$(O) files.
#
rt.db: $(HDRS)
	@echo "   [ICONC] This might take a while..."
	$(SLNT)$(RM) rt.db rt.a
	$(MAKE) rt.a

rt.a: ../common/rswitch.$(O) ../common/long.$(O) ../common/time.$(O) ../common/mlocal.$(O)\
      cnv.$(O) data.$(O) def.$(O) errmsg.$(O) fconv.$(O) fdb.$(O) fload.$(O) fmath.$(O) fmisc.$(O) fmonitr.$(O) \
      fscan.$(O) fstr.$(O) fstranl.$(O) fstruct.$(O) fsys.$(O) fwindow.$(O) init.$(O) invoke.$(O)\
      keyword.$(O) lmisc.$(O) oarith.$(O) oasgn.$(O) ocat.$(O) ocomp.$(O) omisc.$(O) oref.$(O) oset.$(O)\
      ovalue.$(O) ralc.$(O) rcoexpr.$(O) rcomp.$(O) rdebug.$(O) rlrgint.$(O) rlocal.$(O) rmemmgt.$(O)\
      rmisc.$(O) rstruct.$(O) rsys.$(O) rwinrsc.$(O) rgfxsys.$(O) rwinsys.$(O) fxtra.$(O) raudio.$(O)\
      rmsg.$(O) rposix.$(O) rwindow.$(O) rdb.$(O)\
      ../common/xwindow.$(O) ../common/alloc.$(O) $(COMMONDRAWSTRING)
	$(RTT) -A -O "../common/rswitch.$(O) ../common/long.$(O) ../common/time.$(O) ../common/mlocal.$(O) ../common/xwindow.$(O) ../common/alloc.$(O) $(COMMONDRAWSTRING)"
	cp rt.a rt.db ../common/dlrgint.$(O) ../../bin
	-(test -f ../../NoRanlib) || (ranlib ../../bin/rt.a)

%.$(O): %.r $(HDRS)
	$(CMNT)@echo "   [ICONC RTT] $<"
	$(SLNT)$(RTT) $(DASHS) -c -O "$(CFLAGS)" $<

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
