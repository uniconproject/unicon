#  Makefile for the Icon translator, icont.

TOPDIR=../..

default: all

include $(TOPDIR)/Makedefs

TRANS= trans.$(O) tcode.$(O) tlex.$(O) lnklist.$(O) tparse.$(O) tsym.$(O) tmem.$(O) tree.$(O) yyerror.$(O) tglobals.$(O)

LINKR= link.$(O) lglob.$(O) lcode.$(O) llex.$(O) lmem.$(O) lsym.$(O) opcode.$(O) lcompres.$(O)

OBJS=  tmain.$(O) util.$(O) tlocal.$(O) $(TRANS) $(LINKR)

WOBJS=  ../runtime/xrwindow.$(O) ../runtime/xrwinsys.$(O) \
	../runtime/xrwinrsc.$(O) ../common/dconsole.$(O)

# These files are affected by NTConsole on Windows
CONSOLEOBJS=  lcode.$(O) lglob.$(O) link.$(O) tcode.$(O) tmain.$(O)

PGMS=		icont$(EXE)

all:		icont

icont $(ICONTEXE):		 $(NTCONDEP) $(OBJS) ../../rt/lib/libucommon.a
		$(CC) $(CFLAGS) $(LDFLAGS) -o icont $(OBJS) -lucommon $(LIBS)
		cp $(PGMS) ../../bin
		strip ../../bin/$(PGMS)

wicont $(WICONTEXE): WNTCON $(OBJS) ../../rt/lib/libucommon.a common
	$(CC) -Wl,--subsystem,windows $(LDFLAGS) -o wicont.exe -mwindows $(OBJS) $(WOBJS)  -lucommon -lwuconsole -lwinmm $(LIBS) $(WGLIBS)
	$(CP) wicont.exe ../../bin


# set NTConsole for wiconx
NTCON: CONSOLE
	@echo set NTCONSOLE=-DNTConsole -DMSWindows
	$(eval NTCONSOLE=-DNTConsole -DMSWindows)

WNTCON: CONSOLE
	@echo set NTCONSOLE=-DMSWindows
	$(eval NTCONSOLE=-DMSWindows )

# make sure to clean the files affected by NTConsole to force rebuild them
CONSOLE:
	$(RM) $(CONSOLEOBJS)

common: $(COBJS) ../common/dconsole.$(O)
#	cd ../common && $(MAKE) $(ICOBJS) CONSOLE=$(CONSOLE) DCONSOLE=../common/dconsole.o

../common/dconsole.$(O):
	$(MAKE) -C ../common dconsole.$(O)

$(OBJS):   ../h/define.h ../h/config.h ../h/cpuconf.h ../h/gsupport.h \
		   ../h/proto.h ../h/mproto.h ../h/auto.h \
		   ../h/typedefs.h ../h/cstructs.h tproto.h

%.o: %.c
	$(CMNT)@echo "   [ICONT] $<"
	$(SLNT)$(CC)  $(NTCONSOLE) $(CPPFLAGS) $(CFLAGS) -c $<

tmain.o:	tglobals.h ../h/version.h
tglobals.o:	tglobals.h
util.o:		tglobals.h tree.h ../h/fdefs.h

# translator files
trans.o:	tglobals.h tsym.h ttoken.h tree.h ../h/version.h ../h/kdefs.h
lnklist.o:	lfile.h
tparse.o:	../h/lexdef.h tglobals.h tsym.h tree.h keyword.h
tcode.o:	tglobals.h tsym.h ttoken.h tree.h
tlex.o:		../h/lexdef.h ../h/parserr.h ttoken.h tree.h ../h/esctab.h \
		   ../common/lextab.h ../common/yylex.h ../common/error.h
tmem.o:		tglobals.h tsym.h tree.h
tree.o:		tree.h
tsym.o:		tglobals.h tsym.h ttoken.h lfile.h keyword.h ../h/kdefs.h

# linker files
$(LINKR):	link.h lfile.h ../h/rt.h ../h/sys.h ../h/monitor.h \
		   ../h/rstructs.h ../h/rmacros.h ../h/rexterns.h

link.o:		tglobals.h ../h/header.h
lcode.o:	tglobals.h opcode.h keyword.h ../h/header.h \
			../h/opdefs.h ../h/version.h
lglob.o:	tglobals.h opcode.h ../h/opdefs.h ../h/version.h
llex.o:		tglobals.h opcode.h ../h/opdefs.h
lmem.o:		tglobals.h
lsym.o:		tglobals.h
opcode.o:	opcode.h ../h/opdefs.h
lcompres.o:	tglobals.h ../h/header.h

Clean clean:
	$(RM) *.$(O) $(PMGS)

#  The following sections are commented out because they do not need to be
#  performed unless changes are made to cgrammar.c, ../h/grammar.h,
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
#tparse.c ttoken.h:	tgram.g trash ../common/pscript
## expect 218 shift/reduce conflicts
#		yacc -d tgram.g
#		./trash <y.tab.c | ../common/pscript >tparse.c
#		mv y.tab.h ttoken.h
#		rm -f y.tab.c
#
#tgram.g:	tgrammar.c ../h/define.h ../h/grammar.h \
#			../common/yacctok.h ../common/fixgram 
#		$(CC) -E -C tgrammar.c | ../common/fixgram >tgram.g
#
#../h/kdefs.h keyword.h:	../runtime/keyword.r mkkwd
#		./mkkwd <../runtime/keyword.r
#
#trash:		trash.icn
#		icont -s trash.icn
#
#mkkwd:		mkkwd.icn
#		icont -s mkkwd.icn
