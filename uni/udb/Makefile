#
# Makefile
#

UFILES= udb.u icode.u srcfile.u debug.u udbcmd.u console.u
SRC   = udb.icn srcfile.icn debug.icn udbcmd.icn console.icn defaults.icn icode.icn
UC    = unicon
EXEs  = udb     #test
DEL   = -rm
CLEAN = clean
cflags= -c -u 


all: $(EXEs)

udb: $(UFILES)
	$(UC) -G $(UFILES)
	cp udb ../../bin

udb.u: udb.icn 
	$(UC) $(cflags) udb

console.u: console.icn defaults.icn
	$(UC) $(cflags) console

udbcmd.u: udbcmd.icn defaults.icn
	$(UC) $(cflags) udbcmd

debug.u: debug.icn defaults.icn
	$(UC) $(cflags) debug

srcfile.u: srcfile.icn icode.u
	$(UC) $(cflags) srcfile

icode.u: icode.icn
	$(UC) $(cflags) icode

zip:
	zip -r udb.zip ../udb

clean:
	$(DEL) *.u 
	$(DEL) $(EXEs) 
	$(DEL) *.dir *.pag
	$(DEL) *~



