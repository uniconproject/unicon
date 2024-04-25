#  Makefile for the (Un)Icon run-time system.

include ../../Makedefs

REPO_REV='"$(shell LC_ALL=C svnversion -cn ../../ | sed -e "s/.*://" -e "s/\([0-9]*\).*/\1/" | grep "[0-9]" )"'
RTT=../../bin/rtt

RM=rm -f
O=o

HDRS = ../h/define.h ../h/config.h ../h/typedefs.h ../h/monitor.h\
	  ../h/proto.h ../h/cstructs.h ../h/cpuconf.h ../h/grttin.h\
	  ../h/rmacros.h ../h/rexterns.h ../h/rstructs.h \
	  ../h/rproto.h ../h/mproto.h ../h/version.h ../h/sys.h

GRAPHICSHDRS = ../h/graphics.h ../h/xwin.h
GRAPHICSRI = rmac.ri rxwin.ri rmswin.ri rwin3d.ri ropengl.ri rd3d.ri

default: iconx
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


xcnv.$(O): cnv.r $(HDRS)
	$(RTT) -x cnv.r
	$(CC) $(CFLAGS) -c xcnv.c
	$(RM) xcnv.c

xdata.$(O): data.r $(HDRS) ../h/kdefs.h ../h/fdefs.h ../h/odefs.h
	$(RTT) -x data.r
	$(CC) $(CFLAGS) -c xdata.c
	$(RM) xdata.c

xdef.$(O): def.r $(HDRS)
	$(RTT) -x def.r
	$(CC) $(CFLAGS) -c xdef.c
	$(RM) xdef.c

xerrmsg.$(O): errmsg.r $(HDRS)
	$(RTT) -x errmsg.r
	$(CC) $(CFLAGS) -c xerrmsg.c
	$(RM) xerrmsg.c

xextcall.$(O): extcall.r $(HDRS)
	$(RTT) -x extcall.r
	$(CC) $(CFLAGS) -c xextcall.c
	$(RM) xextcall.c

xfconv.$(O): fconv.r $(HDRS)
	$(RTT) -x fconv.r
	$(CC) $(CFLAGS) -c xfconv.c
	$(RM) xfconv.c

xfload.$(O): fload.r $(HDRS)
	$(RTT) -x fload.r
	$(CC) $(CFLAGS) -c xfload.c
	$(RM) xfload.c

xfmath.$(O): fmath.r $(HDRS)
	$(RTT) -x fmath.r
	$(CC) $(CFLAGS) -c xfmath.c
	$(RM) xfmath.c

xfmisc.$(O): fmisc.r $(HDRS)
	$(RTT) -x fmisc.r
	$(CC) $(CFLAGS) -c xfmisc.c
	$(RM) xfmisc.c

xfmonitr.$(O): fmonitr.r $(HDRS)
	$(RTT) -x fmonitr.r
	$(CC) $(CFLAGS) -c xfmonitr.c
	$(RM) xfmonitr.c

xfscan.$(O): fscan.r $(HDRS)
	$(RTT) -x fscan.r
	$(CC) $(CFLAGS) -c xfscan.c
	$(RM) xfscan.c

xfstr.$(O): fstr.r $(HDRS)
	$(RTT) -x fstr.r
	$(CC) $(CFLAGS) -c xfstr.c
	$(RM) xfstr.c

xfstranl.$(O): fstranl.r $(HDRS)
	$(RTT) -x fstranl.r
	$(CC) $(CFLAGS) -c xfstranl.c
	$(RM) xfstranl.c

xfstruct.$(O): fstruct.r $(HDRS)
	$(RTT) -x fstruct.r
	$(CC) $(CFLAGS) -c xfstruct.c
	$(RM) xfstruct.c

xfsys.$(O): fsys.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) -x fsys.r
	$(CC) $(CFLAGS) -c xfsys.c
	$(RM) xfsys.c

xfwindow.$(O): fwindow.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) -x fwindow.r
	$(CC) $(CFLAGS) -c xfwindow.c
	$(RM) xfwindow.c

ximain.$(O): imain.r $(HDRS)
	$(RTT) -x imain.r
	$(CC) $(CFLAGS) -c ximain.c
	$(RM) ximain.c

ximisc.$(O): imisc.r $(HDRS)
	$(RTT) -x imisc.r
	$(CC) $(CFLAGS) -c ximisc.c
	$(RM) ximisc.c

xinit.$(O): init.r $(HDRS)
	$(RTT) -x init.r
	$(CC) $(CFLAGS) -c xinit.c
	$(RM) xinit.c

xinterp.$(O): interp.r $(HDRS)
	$(RTT) -x interp.r
	$(CC) $(CFLAGS) -c xinterp.c
	$(RM) xinterp.c

xinvoke.$(O): invoke.r $(HDRS)
	$(RTT) -x invoke.r
	$(CC) $(CFLAGS) -c xinvoke.c
	$(RM) xinvoke.c


xkeyword.$(O): keyword.r $(HDRS) ../h/feature.h
	$(RTT) -DREPO_REVISION=$(REPO_REV) -x keyword.r
	$(CC) $(CFLAGS) -DREPO_REVISION=$(REPO_REV) -c xkeyword.c
	$(RM) xkeyword.c

xlmisc.$(O): lmisc.r $(HDRS)
	$(RTT) -x lmisc.r
	$(CC) $(CFLAGS) -c xlmisc.c
	$(RM) xlmisc.c

xoarith.$(O): oarith.r $(HDRS)
	$(RTT) -x oarith.r
	$(CC) $(CFLAGS) -c xoarith.c
	$(RM) xoarith.c

xoasgn.$(O): oasgn.r $(HDRS)
	$(RTT) -x oasgn.r
	$(CC) $(CFLAGS) -c xoasgn.c
	$(RM) xoasgn.c

xocat.$(O): ocat.r $(HDRS)
	$(RTT) -x ocat.r
	$(CC) $(CFLAGS) -c xocat.c
	$(RM) xocat.c

xocomp.$(O): ocomp.r $(HDRS)
	$(RTT) -x ocomp.r
	$(CC) $(CFLAGS) -c xocomp.c
	$(RM) xocomp.c

xomisc.$(O): omisc.r $(HDRS)
	$(RTT) -x omisc.r
	$(CC) $(CFLAGS) -c xomisc.c
	$(RM) xomisc.c

xoref.$(O): oref.r $(HDRS)
	$(RTT) -x oref.r
	$(CC) $(CFLAGS) -c xoref.c
	$(RM) xoref.c

xoset.$(O): oset.r $(HDRS)
	$(RTT) -x oset.r
	$(CC) $(CFLAGS) -c xoset.c
	$(RM) xoset.c

xovalue.$(O): ovalue.r $(HDRS)
	$(RTT) -x ovalue.r
	$(CC) $(CFLAGS) -c xovalue.c
	$(RM) xovalue.c

xralc.$(O): ralc.r $(HDRS)
	$(RTT) -x ralc.r
	$(CC) $(CFLAGS) -c xralc.c
	$(RM) xralc.c

xrcoexpr.$(O): rcoexpr.r $(HDRS)
	$(RTT) -x rcoexpr.r
	$(CC) $(CFLAGS) -c xrcoexpr.c
	$(RM) xrcoexpr.c

xrcomp.$(O): rcomp.r $(HDRS)
	$(RTT) -x rcomp.r
	$(CC) $(CFLAGS) -c xrcomp.c
	$(RM) xrcomp.c

xrdebug.$(O): rdebug.r $(HDRS)
	$(RTT) -x rdebug.r
	$(CC) $(CFLAGS) -c xrdebug.c
	$(RM) xrdebug.c

xrlocal.$(O): rlocal.r $(HDRS)
	$(RTT) -x rlocal.r
	$(CC) $(CFLAGS) -c xrlocal.c
	$(RM) xrlocal.c

xrlrgint.$(O): rlrgint.r $(HDRS)
	$(RTT) -x rlrgint.r
	$(CC) $(CFLAGS) -c xrlrgint.c
	$(RM) xrlrgint.c

xrmemmgt.$(O): rmemmgt.r $(HDRS)
	$(RTT) -x rmemmgt.r
	$(CC) $(CFLAGS) -c xrmemmgt.c
	$(RM) xrmemmgt.c

xrmisc.$(O): rmisc.r $(HDRS)
	$(RTT) -x rmisc.r
	$(CC) $(CFLAGS) -c xrmisc.c
	$(RM) xrmisc.c

xrstruct.$(O): rstruct.r $(HDRS)
	$(RTT) -x rstruct.r
	$(CC) $(CFLAGS) -c xrstruct.c
	$(RM) xrstruct.c

xrsys.$(O): rsys.r $(HDRS)
	$(RTT) -x rsys.r
	$(CC) $(CFLAGS) -c xrsys.c
	$(RM) xrsys.c

xrposix.$(O): rposix.r $(HDRS) ../h/posix.h
	$(RTT) -x rposix.r
	$(CC) $(CFLAGS) -c xrposix.c
	$(RM) xrposix.c

xfdb.$(O): fdb.r $(HDRS)
	$(RTT) -x fdb.r
	$(CC) $(CFLAGS) -c xfdb.c
	$(RM) xfdb.c

xrdb.$(O): rdb.r $(HDRS)
	$(RTT) -x rdb.r
	$(CC) $(CFLAGS) -c xrdb.c
	$(RM) xrdb.c

xrmsg.$(O): rmsg.r $(HDRS) ../h/messagin.h
	$(RTT) -x rmsg.r
	$(CC) $(CFLAGS) -c xrmsg.c
	$(RM) xrmsg.c

xfxtra.$(O): fxtra.r fxposix.ri fxaudio.ri $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri fxaudio.ri
	$(RTT) -x fxtra.r
	$(CC) $(CFLAGS) -c xfxtra.c
	$(RM) xfxtra.c

xrgfxsys.$(O): rgfxsys.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) -x rgfxsys.r
	$(CC) $(CFLAGS) -c xrgfxsys.c
	$(RM) xrgfxsys.c

xrwinsys.$(O): rwinsys.r $(HDRS) $(GRAPHICSHDRS) $(GRAPHICSRI)
	$(RTT) -x rwinsys.r
	$(CC) $(CFLAGS) -c xrwinsys.c
	$(RM) xrwinsys.c

xrwindow.$(O): rwindow.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) -x rwindow.r
	$(CC) $(CFLAGS) -c xrwindow.c
	$(RM) xrwindow.c

xrwinrsc.$(O): rwinrsc.r $(HDRS) $(GRAPHICSHDRS) rxrsc.ri
	$(RTT) -x rwinrsc.r
	$(CC) $(CFLAGS) -c xrwinrsc.c
	$(RM) xrwinrsc.c

xraudio.$(O): raudio.r $(HDRS)
	$(RTT) -x raudio.r
	$(CC) $(CFLAGS) -c xraudio.c
	$(RM) xraudio.c

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

comp_all:
	cd ../common; $(MAKE) $(ICOBJS) dlrgint.o $(XPM) $(GDBM) $(LIBTP)
	$(MAKE) db_lib

comp_all_uniconc:
	cd ../common; $(MAKE) $(ICOBJS) dlrgint.o $(XPM) $(GDBM) $(LIBTP)
	$(MAKE) db_lib_uniconc

db_lib: rt.db rt.a
db_lib_uniconc: rt.db.uniconc rt.a

#
# if rt.db is missing or any header files have been updated, recreate
# rt.db from scratch along with the .$(O) files.
#
rt.db: $(HDRS)
	$(RM) rt.db rt.a
	$(RTT) $(RTLSRC)
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rt.db.uniconc: $(HDRS)
	$(RM) rt.db rt.a
	$(RTT) -DUniconc $(RTLSRC)
	$(CC) $(CFLAGS) -DUniconc -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rt.a: ../common/rswitch.$(O) ../common/long.$(O) ../common/time.$(O) ../common/mlocal.$(O)\
      cnv.$(O) data.$(O) def.$(O) errmsg.$(O) fconv.$(O) fload.$(O) fmath.$(O) fmisc.$(O) fmonitr.$(O) \
      fscan.$(O) fstr.$(O) fstranl.$(O) fstruct.$(O) fsys.$(O) fwindow.$(O) init.$(O) invoke.$(O)\
      keyword.$(O) lmisc.$(O) oarith.$(O) oasgn.$(O) ocat.$(O) ocomp.$(O) omisc.$(O) oref.$(O) oset.$(O)\
      ovalue.$(O) ralc.$(O) rcoexpr.$(O) rcomp.$(O) rdebug.$(O) rlrgint.$(O) rlocal.$(O) rmemmgt.$(O)\
      rmisc.$(O) rstruct.$(O) rsys.$(O) rwinrsc.$(O) rgfxsys.$(O) rwinsys.$(O) fxtra.$(O) raudio.$(O)\
      rmsg.$(O) rposix.$(O) rwindow.$(O)\
      ../common/xwindow.$(O) ../common/alloc.$(O) $(COMMONDRAWSTRING)
	 $(RM) rt.a
	ar qc rt.a `sed 's/$$/.o/' rttfull.lst` ../common/rswitch.$(O)\
	    ../common/long.$(O) ../common/time.$(O) ../common/mlocal.$(O)\
	    ../common/xwindow.$(O) ../common/alloc.$(O) $(COMMONDRAWSTRING)
	cp rt.a rt.db ../common/dlrgint.$(O) ../../bin
	-(test -f ../../NoRanlib) || (ranlib ../../bin/rt.a)

cnv.$(O): cnv.r $(HDRS)
	$(RTT) cnv.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

data.$(O): data.r $(HDRS)
	$(RTT) data.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

def.$(O): def.r $(HDRS)
	$(RTT) def.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

errmsg.$(O): errmsg.r $(HDRS)
	$(RTT) errmsg.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fconv.$(O): fconv.r $(HDRS)
	$(RTT) fconv.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fload.$(O): fload.r $(HDRS)
	$(RTT) fload.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fmath.$(O): fmath.r $(HDRS)
	$(RTT) fmath.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fmisc.$(O): fmisc.r $(HDRS)
	$(RTT) fmisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fmonitr.$(O): fmonitr.r $(HDRS)
	$(RTT) fmonitr.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fscan.$(O): fscan.r $(HDRS)
	$(RTT) fscan.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fstr.$(O): fstr.r $(HDRS)
	$(RTT) fstr.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fstranl.$(O): fstranl.r $(HDRS)
	$(RTT) fstranl.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fstruct.$(O): fstruct.r $(HDRS)
	$(RTT) fstruct.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fsys.$(O): fsys.r $(HDRS)
	$(RTT) fsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fwindow.$(O): fwindow.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) fwindow.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

init.$(O): init.r $(HDRS)
	$(RTT) init.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

invoke.$(O): invoke.r $(HDRS)
	$(RTT) invoke.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

keyword.$(O): keyword.r $(HDRS)
	$(RTT) keyword.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

lmisc.$(O): lmisc.r $(HDRS)
	$(RTT) lmisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

oarith.$(O): oarith.r $(HDRS)
	$(RTT) oarith.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

oasgn.$(O): oasgn.r $(HDRS)
	$(RTT) oasgn.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

ocat.$(O): ocat.r $(HDRS)
	$(RTT) ocat.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

ocomp.$(O): ocomp.r $(HDRS)
	$(RTT) ocomp.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

omisc.$(O): omisc.r $(HDRS)
	$(RTT) omisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

oref.$(O): oref.r $(HDRS)
	$(RTT) oref.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

oset.$(O): oset.r $(HDRS)
	$(RTT) oset.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

ovalue.$(O): ovalue.r $(HDRS)
	$(RTT) ovalue.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

ralc.$(O): ralc.r $(HDRS)
	$(RTT) ralc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rcoexpr.$(O): rcoexpr.r $(HDRS)
	$(RTT) rcoexpr.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rcomp.$(O): rcomp.r $(HDRS)
	$(RTT) rcomp.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rdebug.$(O): rdebug.r $(HDRS)
	$(RTT) rdebug.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rlrgint.$(O): rlrgint.r $(HDRS)
	$(RTT) rlrgint.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rlocal.$(O): rlocal.r $(HDRS)
	$(RTT) rlocal.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rmemmgt.$(O): rmemmgt.r $(HDRS)
	$(RTT) rmemmgt.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rmisc.$(O): rmisc.r $(HDRS)
	$(RTT) rmisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rstruct.$(O): rstruct.r $(HDRS)
	$(RTT) rstruct.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rsys.$(O): rsys.r $(HDRS)
	$(RTT) rsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rmsg.$(O): rmsg.r $(HDRS) ../h/messagin.h
	$(RTT) rmsg.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

fxtra.$(O): fxtra.r $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri fxaudio.ri
	$(RTT) fxtra.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

raudio.$(O): raudio.r $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri
	$(RTT) -x raudio.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rposix.$(O): rposix.r $(HDRS) ../h/posix.h
	$(RTT) rposix.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rwinrsc.$(O): rwinrsc.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) rwinrsc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rgfxsys.$(O): rgfxsys.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) rgfxsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rwinsys.$(O): rwinsys.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) rwinsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`

rwindow.$(O): rwindow.r $(HDRS) $(GRAPHICSHDRS)
	$(RTT) rwindow.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	$(RM) `sed 's/$$/.c/' rttcur.lst`


../common/drawstring3d.o: ../common/drawstring3d.cc
	cd ../common; $(MAKE) drawstring3d.o
