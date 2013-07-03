#  Makefile for the (Un)Icon run-time system.

include ../../Makedefs

REPO_REV='"$(shell LC_ALL=C svnversion -cn ../../ | sed -e "s/.*://" -e "s/\([0-9]*\).*/\1/" | grep "[0-9]" )"'

RM=rm -f

HDRS = ../h/define.h ../h/config.h ../h/typedefs.h ../h/monitor.h\
	  ../h/proto.h ../h/cstructs.h ../h/cpuconf.h ../h/grttin.h\
	  ../h/rmacros.h ../h/rexterns.h ../h/rstructs.h \
	  ../h/rproto.h ../h/mproto.h ../h/sys.h

GRAPHICSHDRS = ../h/graphics.h ../h/xwin.h

default: iconx
all:	interp_all comp_all

####################################################################
#
# Make entries for iconx
#

XOBJS=	xcnv.o xdata.o xdef.o xerrmsg.o xextcall.o xfconv.o xfload.o xfmath.o\
	xfmisc.o xfmonitr.o xfscan.o xfstr.o xfstranl.o xfstruct.o xfsys.o\
	xfwindow.o ximain.o ximisc.o xinit.o xinterp.o xinvoke.o xfdb.o\
	xkeyword.o xlmisc.o xoarith.o xoasgn.o xocat.o xocomp.o\
	xomisc.o xoref.o xoset.o xovalue.o xralc.o xrcoexpr.o xrcomp.o xrdb.o\
	xrdebug.o xrlocal.o xrlrgint.o xrmemmgt.o xrmisc.o xrstruct.o xrsys.o\
	xrwinrsc.o xrgfxsys.o xrwinsys.o xrwindow.o xfxtra.o xraudio.o xrposix.o xrmsg.o

COBJS=	../common/long.o ../common/time.o ../common/save.o \
	../common/rswitch.o ../common/redirerr.o ../common/xwindow.o \
	../common/alloc.o ../common/mlocal.o ../common/filepart.o $(COMMONDRAWSTRING)

ICOBJS=	long.o time.o save.o rswitch.o redirerr.o xwindow.o alloc.o $(DRAWSTRING)

OBJS=	$(XOBJS) $(COBJS)

interp_all:
	cd ../common; $(MAKE) $(ICOBJS) $(XPM) $(GDBM) $(LIBTP) $(DRAWSTRING)
	$(MAKE) iconx

iconx: $(OBJS)
	$(CC) $(RLINK) -o iconx  $(OBJS) $(XLIBS) $(RLIBS) $(XL) $(LIBSTDCPP)
	cp iconx ../../bin
	strip ../../bin/iconx

xcnv.o: cnv.r $(HDRS)
	../../bin/rtt -x cnv.r
	$(CC) $(CFLAGS) -c xcnv.c
	$(RM) xcnv.c

xdata.o: data.r $(HDRS) ../h/kdefs.h ../h/fdefs.h ../h/odefs.h
	../../bin/rtt -x data.r
	$(CC) $(CFLAGS) -c xdata.c
	$(RM)  xdata.c

xdef.o: def.r $(HDRS)
	../../bin/rtt -x def.r
	$(CC) $(CFLAGS) -c xdef.c
	$(RM) xdef.c

xerrmsg.o: errmsg.r $(HDRS)
	../../bin/rtt -x errmsg.r
	$(CC) $(CFLAGS) -c xerrmsg.c
	$(RM) xerrmsg.c

xextcall.o: extcall.r $(HDRS)
	../../bin/rtt -x extcall.r
	$(CC) $(CFLAGS) -c xextcall.c
	$(RM) xextcall.c

xfconv.o: fconv.r $(HDRS)
	../../bin/rtt -x fconv.r
	$(CC) $(CFLAGS) -c xfconv.c
	$(RM) xfconv.c

xfdb.o: fdb.r $(HDRS)
	../../bin/rtt -x fdb.r
	$(CC) $(CFLAGS) -c xfdb.c
	$(RM) xfdb.c

xfload.o: fload.r $(HDRS)
	../../bin/rtt -x fload.r
	$(CC) $(CFLAGS) -c xfload.c
	$(RM) xfload.c

xfmath.o: fmath.r $(HDRS)
	../../bin/rtt -x fmath.r
	$(CC) $(CFLAGS) -c xfmath.c
	$(RM) xfmath.c

xfmisc.o: fmisc.r $(HDRS)
	../../bin/rtt -x fmisc.r
	$(CC) $(CFLAGS) -c xfmisc.c
	$(RM) xfmisc.c

xfmonitr.o: fmonitr.r $(HDRS)
	../../bin/rtt -x fmonitr.r
	$(CC) $(CFLAGS) -c xfmonitr.c
	$(RM) xfmonitr.c

xfscan.o: fscan.r $(HDRS)
	../../bin/rtt -x fscan.r
	$(CC) $(CFLAGS) -c xfscan.c
	$(RM) xfscan.c

xfstr.o: fstr.r $(HDRS)
	../../bin/rtt -x fstr.r
	$(CC) $(CFLAGS) -c xfstr.c
	$(RM) xfstr.c

xfstranl.o: fstranl.r $(HDRS)
	../../bin/rtt -x fstranl.r
	$(CC) $(CFLAGS) -c xfstranl.c
	$(RM) xfstranl.c

xfstruct.o: fstruct.r $(HDRS)
	../../bin/rtt -x fstruct.r
	$(CC) $(CFLAGS) -c xfstruct.c
	$(RM) xfstruct.c

xfsys.o: fsys.r $(HDRS)
	../../bin/rtt -x fsys.r
	$(CC) $(CFLAGS) -c xfsys.c
	$(RM) xfsys.c

xfwindow.o: fwindow.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt -x fwindow.r
	$(CC) $(CFLAGS) -c xfwindow.c
	$(RM) xfwindow.c

ximain.o: imain.r $(HDRS)
	../../bin/rtt -x imain.r
	$(CC) $(CFLAGS) -c ximain.c
	$(RM) ximain.c

ximisc.o: imisc.r $(HDRS)
	../../bin/rtt -x imisc.r
	$(CC) $(CFLAGS) -c ximisc.c
	$(RM) ximisc.c

xinit.o: init.r $(HDRS) ../h/odefs.h ../h/version.h
	../../bin/rtt -x init.r
	$(CC) $(CFLAGS) -c xinit.c
	$(RM) xinit.c

xinterp.o: interp.r $(HDRS)
	../../bin/rtt -x interp.r
	$(CC) $(CFLAGS) -c xinterp.c
	$(RM) xinterp.c

xinvoke.o: invoke.r $(HDRS)
	../../bin/rtt -x invoke.r
	$(CC) $(CFLAGS) -c xinvoke.c
	$(RM) xinvoke.c

xkeyword.o: keyword.r $(HDRS) ../h/feature.h ../h/version.h
	../../bin/rtt -DREPO_REVISION=$(REPO_REV) -x keyword.r
	$(CC) $(CFLAGS) -DREPO_REVISION=$(REPO_REV) -c xkeyword.c
	$(RM) xkeyword.c

xlmisc.o: lmisc.r $(HDRS)
	../../bin/rtt -x lmisc.r
	$(CC) $(CFLAGS) -c xlmisc.c
	$(RM) xlmisc.c

xoarith.o: oarith.r $(HDRS)
	../../bin/rtt -x oarith.r
	$(CC) $(CFLAGS) -c xoarith.c
	$(RM) xoarith.c

xoasgn.o: oasgn.r $(HDRS)
	../../bin/rtt -x oasgn.r
	$(CC) $(CFLAGS) -c xoasgn.c
	$(RM) xoasgn.c

xocat.o: ocat.r $(HDRS)
	../../bin/rtt -x ocat.r
	$(CC) $(CFLAGS) -c xocat.c
	$(RM) xocat.c

xocomp.o: ocomp.r $(HDRS)
	../../bin/rtt -x ocomp.r
	$(CC) $(CFLAGS) -c xocomp.c
	$(RM) xocomp.c

xomisc.o: omisc.r $(HDRS)
	../../bin/rtt -x omisc.r
	$(CC) $(CFLAGS) -c xomisc.c
	$(RM) xomisc.c

xoref.o: oref.r $(HDRS)
	../../bin/rtt -x oref.r
	$(CC) $(CFLAGS) -c xoref.c
	$(RM) xoref.c

xoset.o: oset.r $(HDRS)
	../../bin/rtt -x oset.r
	$(CC) $(CFLAGS) -c xoset.c
	$(RM) xoset.c

xovalue.o: ovalue.r $(HDRS)
	../../bin/rtt -x ovalue.r
	$(CC) $(CFLAGS) -c xovalue.c
	$(RM) xovalue.c

xralc.o: ralc.r $(HDRS)
	../../bin/rtt -x ralc.r
	$(CC) $(CFLAGS) -c xralc.c
	$(RM) xralc.c

xrcoexpr.o: rcoexpr.r $(HDRS)
	../../bin/rtt -x rcoexpr.r
	$(CC) $(CFLAGS) -c xrcoexpr.c
	$(RM) xrcoexpr.c

xrcomp.o: rcomp.r $(HDRS)
	../../bin/rtt -x rcomp.r
	$(CC) $(CFLAGS) -c xrcomp.c
	$(RM) xrcomp.c

xrdb.o: rdb.r $(HDRS)
	../../bin/rtt -x rdb.r
	$(CC) $(CFLAGS) -c xrdb.c
	$(RM) xrdb.c

xrdebug.o: rdebug.r $(HDRS)
	../../bin/rtt -x rdebug.r
	$(CC) $(CFLAGS) -c xrdebug.c
	$(RM) xrdebug.c

xrlocal.o: rlocal.r $(HDRS)
	../../bin/rtt -x rlocal.r
	$(CC) $(CFLAGS) -c xrlocal.c
	$(RM) xrlocal.c

xrlrgint.o: rlrgint.r $(HDRS)
	../../bin/rtt -x rlrgint.r
	$(CC) $(CFLAGS) -c xrlrgint.c
	$(RM) xrlrgint.c

xrmemmgt.o: rmemmgt.r $(HDRS)
	../../bin/rtt -x rmemmgt.r
	$(CC) $(CFLAGS) -c xrmemmgt.c
	$(RM) xrmemmgt.c

xrmisc.o: rmisc.r $(HDRS)
	../../bin/rtt -x rmisc.r
	$(CC) $(CFLAGS) -c xrmisc.c
	$(RM) xrmisc.c

xrmsg.o: rmsg.r $(HDRS) ../h/messagin.h
	../../bin/rtt -x rmsg.r
	$(CC) $(CFLAGS) -c xrmsg.c
	$(RM) xrmsg.c

xrposix.o: rposix.r $(HDRS) ../h/posix.h
	../../bin/rtt -x rposix.r
	$(CC) $(CFLAGS) -c xrposix.c
	$(RM) xrposix.c

xrstruct.o: rstruct.r $(HDRS)
	../../bin/rtt -x rstruct.r
	$(CC) $(CFLAGS) -c xrstruct.c
	$(RM) xrstruct.c

xrsys.o: rsys.r $(HDRS)
	../../bin/rtt -x rsys.r
	$(CC) $(CFLAGS) -c xrsys.c
	$(RM) xrsys.c

xrwinrsc.o: rwinrsc.r $(HDRS) $(GRAPHICSHDRS) rxrsc.ri
	../../bin/rtt -x rwinrsc.r
	$(CC) $(CFLAGS) -c xrwinrsc.c
	$(RM) xrwinrsc.c

xrgfxsys.o: rgfxsys.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt -x rgfxsys.r
	$(CC) $(CFLAGS) -c xrgfxsys.c
	$(RM) xrgfxsys.c

xrwinsys.o: rwinsys.r $(HDRS) $(GRAPHICSHDRS) rxwin.ri ropengl.ri
	../../bin/rtt -x rwinsys.r
	$(CC) $(CFLAGS) -c xrwinsys.c
	$(RM) xrwinsys.c

xrwindow.o: rwindow.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt -x rwindow.r
	$(CC) $(CFLAGS) -c xrwindow.c
	$(RM) xrwindow.c

xfxtra.o: fxtra.r $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri fxaudio.ri
	../../bin/rtt -x fxtra.r
	$(CC) $(CFLAGS) -c xfxtra.c
	$(RM) xfxtra.c

xraudio.o: raudio.r 
	../../bin/rtt -x raudio.r
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
# rt.db from scratch along with the .o files.
#
rt.db: $(HDRS)
	rm -f rt.db rt.a
	../../bin/rtt $(RTLSRC)
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rt.db.uniconc: $(HDRS)
	rm -f rt.db rt.a
	../../bin/rtt -DUniconc $(RTLSRC)
	$(CC) $(CFLAGS) -DUniconc -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rt.a: ../common/rswitch.o ../common/long.o ../common/time.o ../common/mlocal.o\
      cnv.o data.o def.o errmsg.o fconv.o fload.o fmath.o fmisc.o fmonitr.o \
      fscan.o fstr.o fstranl.o fstruct.o fsys.o fwindow.o init.o invoke.o\
      keyword.o lmisc.o oarith.o oasgn.o ocat.o ocomp.o omisc.o oref.o oset.o\
      ovalue.o ralc.o rcoexpr.o rcomp.o rdebug.o rlrgint.o rlocal.o rmemmgt.o\
      rmisc.o rstruct.o rsys.o rwinrsc.o rgfxsys.o rwinsys.o fxtra.o raudio.o\
      rmsg.o rposix.o rwindow.o\
      ../common/xwindow.o ../common/alloc.o $(COMMONDRAWSTRING)
	rm -f rt.a
	ar qc rt.a `sed 's/$$/.o/' rttfull.lst` ../common/rswitch.o\
	    ../common/long.o ../common/time.o ../common/mlocal.o\
	    ../common/xwindow.o ../common/alloc.o $(COMMONDRAWSTRING)
	cp rt.a rt.db ../common/dlrgint.o ../../bin
	-(test -f ../../NoRanlib) || (ranlib ../../bin/rt.a)

cnv.o: cnv.r $(HDRS)
	../../bin/rtt cnv.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

data.o: data.r $(HDRS)
	../../bin/rtt data.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

def.o: def.r $(HDRS)
	../../bin/rtt def.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

errmsg.o: errmsg.r $(HDRS)
	../../bin/rtt errmsg.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fconv.o: fconv.r $(HDRS)
	../../bin/rtt fconv.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fload.o: fload.r $(HDRS)
	../../bin/rtt fload.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fmath.o: fmath.r $(HDRS)
	../../bin/rtt fmath.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fmisc.o: fmisc.r $(HDRS)
	../../bin/rtt fmisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fmonitr.o: fmonitr.r $(HDRS)
	../../bin/rtt fmonitr.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fscan.o: fscan.r $(HDRS)
	../../bin/rtt fscan.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fstr.o: fstr.r $(HDRS)
	../../bin/rtt fstr.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fstranl.o: fstranl.r $(HDRS)
	../../bin/rtt fstranl.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fstruct.o: fstruct.r $(HDRS)
	../../bin/rtt fstruct.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fsys.o: fsys.r $(HDRS)
	../../bin/rtt fsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fwindow.o: fwindow.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt fwindow.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

init.o: init.r $(HDRS)
	../../bin/rtt init.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

invoke.o: invoke.r $(HDRS)
	../../bin/rtt invoke.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

keyword.o: keyword.r $(HDRS)
	../../bin/rtt keyword.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

lmisc.o: lmisc.r $(HDRS)
	../../bin/rtt lmisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

oarith.o: oarith.r $(HDRS)
	../../bin/rtt oarith.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

oasgn.o: oasgn.r $(HDRS)
	../../bin/rtt oasgn.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

ocat.o: ocat.r $(HDRS)
	../../bin/rtt ocat.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

ocomp.o: ocomp.r $(HDRS)
	../../bin/rtt ocomp.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

omisc.o: omisc.r $(HDRS)
	../../bin/rtt omisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

oref.o: oref.r $(HDRS)
	../../bin/rtt oref.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

oset.o: oset.r $(HDRS)
	../../bin/rtt oset.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

ovalue.o: ovalue.r $(HDRS)
	../../bin/rtt ovalue.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

ralc.o: ralc.r $(HDRS)
	../../bin/rtt ralc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rcoexpr.o: rcoexpr.r $(HDRS)
	../../bin/rtt rcoexpr.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rcomp.o: rcomp.r $(HDRS)
	../../bin/rtt rcomp.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rdebug.o: rdebug.r $(HDRS)
	../../bin/rtt rdebug.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rlrgint.o: rlrgint.r $(HDRS)
	../../bin/rtt rlrgint.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rlocal.o: rlocal.r $(HDRS)
	../../bin/rtt rlocal.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rmemmgt.o: rmemmgt.r $(HDRS)
	../../bin/rtt rmemmgt.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rmisc.o: rmisc.r $(HDRS)
	../../bin/rtt rmisc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rstruct.o: rstruct.r $(HDRS)
	../../bin/rtt rstruct.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rsys.o: rsys.r $(HDRS)
	../../bin/rtt rsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rwinrsc.o: rwinrsc.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt rwinrsc.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rgfxsys.o: rgfxsys.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt rgfxsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rmsg.o: rmsg.r $(HDRS) ../h/messagin.h
	../../bin/rtt rmsg.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rposix.o: rposix.r $(HDRS) ../h/posix.h
	../../bin/rtt rposix.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rwinsys.o: rwinsys.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt rwinsys.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

rwindow.o: rwindow.r $(HDRS) $(GRAPHICSHDRS)
	../../bin/rtt rwindow.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

fxtra.o: fxtra.r $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri fxaudio.ri
	../../bin/rtt fxtra.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

raudio.o: raudio.r $(HDRS) ../h/posix.h fxposix.ri fxpattrn.ri
	../../bin/rtt -x raudio.r
	$(CC) $(CFLAGS) -c `sed 's/$$/.c/' rttcur.lst`
	rm `sed 's/$$/.c/' rttcur.lst`

../common/drawstring3d.o: ../common/drawstring3d.cc
	cd ../common; $(MAKE) drawstring3d.o
