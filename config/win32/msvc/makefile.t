DCONSOLE=dconsole.obj
OS=NT
ENV=WIN32
CPU=i386

CC=cl
LD=link
# /Ox for maximum optimzation, /Zi for debugging...
CFLAGS= /D_X86_ /DWIN32 /Ox /D$(CONSOLE) /I..\gdbm /I..\libtp
HFLAGS=
LDFLAGS=
LIBS=
SHELL=/bin/sh
MAKE=nmake
O=obj
RM=-del

TRANS=          trans.$(O) tcode.$(O) tlex.$(O) lnklist.$(O) tparse.$(O) tsym.$(O) tmem.$(O) tree.$(O) yyerror.$(O)

LINKR=          link.$(O) lglob.$(O) lcode.$(O) llex.$(O) lmem.$(O) lsym.$(O) opcode.$(O)

OBJS=           tmain.$(O) util.$(O) tlocal.$(O) tglobals.$(O) lcompres.$(O) $(TRANS) $(LINKR)

COBJS=          ../common/long.$(O) ../common/getopt.$(O) ../common/alloc.$(O)\
		   ../common/filepart.$(O) ../common/strtbl.$(O)\
		../common/mlocal.$(O) ../common/ipp.$(O)

ICOBJS=         long.$(O) getopt.$(O) alloc.$(O) filepart.$(O) strtbl.$(O) ipp.$(O)

WOBJS=	..\runtime\xrwindow.obj ..\runtime\xrwinsys.obj \
	../runtime/xrwinrsc.obj ../common/dconsole.obj

all:            $(ICONT)

icont:
		$(RM) tmain.obj 2> nul
		$(RM) link.obj 2> nul
		$(MAKE) icont2 CONSOLE=NTConsole DCONSOLE=

icont2:        $(OBJS) common
		link -subsystem:console $(OBJS) $(COBJS) kernel32.lib user32.lib gdi32.lib winspool.lib VERSION.LIB -out:icont.exe
		copy icont.exe ..\..\bin

wicont:
		$(RM) tmain.obj
		$(RM) link.obj
		nmake wicont2

MYGUILIBS=kernel32.lib user32.lib gdi32.lib comdlg32.lib

# add $(linkdebug) after $(link) for debugging

wicont2: $(OBJS) common
		$(LD) $(guiflags) $(OBJS) $(COBJS) $(WOBJS) winmm.lib $(MYGUILIBS) -out:wicont.exe
		copy wicont.exe ..\..\bin

linkit:
		$(link) $(linkdebug) $(guiflags) $(OBJS) $(COBJS) $(WOBJS) $(guilibs) -out:wicont.exe
		copy wicont.exe ..\..\bin

common:
		cd ..\common
		$(MAKE) winobjs CONSOLE=$(CONSOLE) DCONSOLE=$(DCONSOLE)
		cd ..\icont

$(OBJS) ixhdr.$(O):   ../h/define.h ../h/config.h ../h/cpuconf.h ../h/gsupport.h \
		   ../h/proto.h ../h/mproto.h \
		   ../h/typedefs.h ../h/cstructs.h tproto.h

$(COBJS):       ../h/mproto.h

tmain.$(O):     tglobals.h ../h/path.h
util.$(O):              tglobals.h tree.h ../h/fdefs.h

# translator files
trans.$(O):     tglobals.h tsym.h ttoken.h tree.h ../h/version.h ../h/kdefs.h
lnklist.$(O):   lfile.h
tparse.$(O):    ../h/lexdef.h tglobals.h tsym.h tree.h keyword.h
tcode.$(O):     tglobals.h tsym.h ttoken.h tree.h
tlex.$(O):              ../h/lexdef.h ../h/parserr.h ttoken.h tree.h ../h/esctab.h \
		   ../common/lextab.h ../common/yylex.h ../common/error.h
tmem.$(O):              tglobals.h tsym.h tree.h
tree.$(O):              tree.h
tsym.$(O):              tglobals.h tsym.h ttoken.h lfile.h keyword.h ../h/kdefs.h
tglobals.$(O):		tglobals.h

# linker files
$(LINKR):       link.h lfile.h ../h/rt.h ../h/sys.h ../h/monitor.h \
		   ../h/rstructs.h ../h/rmacros.h ../h/rexterns.h

# link.$(O):            tglobals.h ../h/header.h hdr.h
link.$(O):              tglobals.h ../h/header.h
lcode.$(O):     tglobals.h opcode.h keyword.h ../h/header.h \
			../h/opdefs.h ../h/version.h
lglob.$(O):     opcode.h ../h/opdefs.h ../h/version.h
llex.$(O):              tglobals.h opcode.h ../h/opdefs.h
lmem.$(O):              tglobals.h
lsym.$(O):              tglobals.h
opcode.$(O):    opcode.h ../h/opdefs.h


ixhdr.exe:      ixhdr.$(O)
		link32 @ixhdr.lnk
		copy ixhdr.exe ..\..\bin

# header file for executables
iconx.hdr:      ixhdr.$(O)
		$(CC) $(LDFLAGS) $(CFLAGS) $(HFLAGS) ixhdr.$(O) \
			-o iconx.hdr $(LIBS)
		strip iconx.hdr
ixhdr.$(O):     ../h/path.h ../h/header.h
		$(CC) -O -c ixhdr.c



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
#                       ../common/tokens.txt ../common/op.txt
#               cd ../common; make gfiles
#
#tparse.c ttoken.h:     tgram.g trash ../common/pscript
## expect 218 shift/reduce conflicts
#               yacc -d tgram.g
#               ./trash <y.tab.c | ../common/pscript >tparse.c
#               mv y.tab.h ttoken.h
#               rm -f y.tab.c
#
#tgram.g:       tgrammar.c ../h/define.h ../h/grammar.h \
#                       ../common/yacctok.h ../common/fixgram 
#               $(CC) -E -C tgrammar.c | ../common/fixgram >tgram.g
#
#../h/kdefs.h keyword.h:        ../runtime/keyword.r mkkwd
#               ./mkkwd <../runtime/keyword.r
#
#trash:         trash.icn
#               icont -s trash.icn
#
#mkkwd:         mkkwd.icn
#               icont -s mkkwd.icn
