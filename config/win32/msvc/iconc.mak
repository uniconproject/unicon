#  MSVC Makefile for the Icon compiler, iconc.
#
OS=NT
ENV=WIN32
CPU=i386

LDFLAGS=
CC=cl
# /Zi for debugging, /O1 to minimize space... Ray recommends /O6 + others
CFLAGS=/D_X86_ /DWIN32 /Zi /I..\gdbm /I..\libtp
MAKE=nmake
RTT=..\..\bin\rtt
O=obj
RM=-del

OBJS=		cmain.$(O) clocal.$(O) ctrans.$(O) dbase.$(O) clex.$(O)\
		cparse.$(O) csym.$(O) cmem.$(O) ctree.$(O) ccode.$(O) ccomp.$(O)\
		ivalues.$(O) codegen.$(O) fixcode.$(O) inline.$(O) chkinv.$(O)\
		typinfer.$(O) lifetime.$(O) incheck.$(O) vtbl.$(O) tv.$(O) wop.$(O) ca.$(O)\
		util.$(O) yyerror.$(O)

COBJS=		../common/long.$(O) ../common/getopt.$(O) ../common/time.$(O)\
		  ../common/filepart.$(O) ../common/identify.$(O) ../common/mlocal.$(O)\
		  ../common/strtbl.$(O) ../common/rtdb.$(O) ../common/literals.$(O) \
		  ../common/alloc.$(O) ../common/redirerr.$(O) ../common/ipp.$(O)

ICOBJS=		long.$(O) getopt.$(O) time.$(O) filepart.$(O) identify.$(O)\
		  strtbl.$(O) rtdb.$(O) literals.$(O) alloc.$(O) redirerr.$(O) ipp.$(O)

all:		common iconc


# common code
common:
		cd ..\common
		$(MAKE) $(ICOBJS) $(XPM)
		cd ..\iconc

iconc:		$(OBJS) $(COBJS)
		$(CC) $(LDFLAGS) $(OBJS) $(COBJS) -out:iconc.exe
		cp iconc.exe ..\..\bin

$(OBJS):	../h/config.h ../h/cpuconf.h ../h/cstructs.h ../h/define.h\
		../h/proto.h ../h/mproto.h ../h/typedefs.h ../h/gsupport.h \
		ccode.h cglobals.h cproto.h csym.h ctrans.h ctree.h

$(COBJS):	../h/mproto.h

ccomp.$(O):	ccomp.c
		$(CC) $(CFLAGS) -DICONC_XLIB="\"$(LIBS)\"" -c ccomp.c

ccode.$(O):	../h/lexdef.h ctoken.h
chkinv.$(O):	ctoken.h
clex.$(O):		../h/lexdef.h ../h/parserr.h ctoken.h \
		   ../common/lextab.h ../common/yylex.h ../common/error.h
clocal.$(O):	../h/config.h
cparse.$(O):	../h/lexdef.h
ctrans.$(O):	ctoken.h
ctree.$(O):	../h/lexdef.h ctoken.h
csym.$(O):		ctoken.h
dbase.$(O):	../h/lexdef.h
lifetime.$(O):	../h/lexdef.h ctoken.h
typinfer.$(O):	../h/lexdef.h ctoken.h
types.$(O):	../h/lexdef.h ctoken.h



#  The following sections are commented out because they do not need to
#  be performed unless changes are made to cgrammar.c, ../h/grammar.h,
#  ../common/tokens.txt, or ../common/op.txt.  Such changes involve
#  modifications to the syntax of Icon and are not part of the installation
#  process. However, if the distribution files are unloaded in a fashion
#  such that their dates are not set properly, the following sections would
#  be attempted.
#
#  Note that if any changes are made to the files mentioned above, the comment
#  characters at the beginning of the following lines should be removed.
#  icont must be on your search path for these actions to work.
#
#../common/lextab.h ../common/yacctok.h ../common/fixgram ../common/pscript: \
#			../common/tokens.txt ../common/op.txt
#		cd ../common; make gfiles
#
#cparse.c ctoken.h:	cgram.g ../common/pscript
## expect 218 shift/reduce conflicts
#		yacc -d cgram.g
#		../common/pscript <y.tab.c >cparse.c
#		mv y.tab.h ctoken.h
#		rm -f y.tab.c
#
#cgram.g:	cgrammar.c ../h/define.h ../h/grammar.h \
#			../common/yacctok.h ../common/fixgram
#		$(CC) -E -C cgrammar.c | ../common/fixgram >cgram.g
