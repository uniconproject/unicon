#
# Makefile
#


UC      = unicon
EXEs    = udb
DEL     = -rm
CLEAN   = clean
cflags  = -u -c 
ldflags = -u

SRC       = udb.icn icode.icn srcfile.icn srccode.icn state.icn \
            agent.icn internals.icn externals.icn \
            breakpoint.icn watchpoint.icn stepping.icn stack.icn data.icn \
            trace.icn \
            evaluator.icn session.icn console.icn defaults.icn
UFILES    = udb.u icode.u srcfile.u srccode.u state.u \
            agent.u internals.u externals.u \
            breakpoint.u watchpoint.u stepping.u stack.u data.u \
            trace.u  \
            evaluator.u session.u console.u
LIB       = lib
LIBRARY   = $(LIB)/listener.u    $(LIB)/memory.u     $(LIB)/structaliases.u \
            $(LIB)/structusage.u $(LIB)/looptime.u   $(LIB)/proctime.u \
            $(LIB)/procprofile.u $(LIB)/varprofile.u $(LIB)/deadvar.u \
            $(LIB)/failedloop.u  $(LIB)/failedsubscript.u\
            $(LIB)/typechange.u


all: Libfiles $(EXEs) 

Libfiles:
	cd lib; make
tools:
	cd lib; make tools

udb: $(UFILES)
	$(UC) $(ldflags) $(LIBRARY) $(UFILES) -o udb
	mv udb ../../bin

udb.u: udb.icn console.u
	$(UC) $(cflags) udb

console.u: console.icn defaults.icn state.u session.u evaluator.u
	$(UC) $(cflags) console

session.u: session.icn defaults.icn state.u evaluator.u externals.u
	$(UC) $(cflags) session

evaluator.u: evaluator.icn defaults.icn state.u data.u trace.u internals.u externals.u
	$(UC) $(cflags) evaluator

state.u: state.icn defaults.icn srcfile.u srccode.u icode.u
	$(UC) $(cflags) state

srcfile.u: srcfile.icn
	$(UC) $(cflags) srcfile

srccode.u: srccode.icn
	$(UC) $(cflags) srccode

icode.u: icode.icn
	$(UC) $(cflags) icode

breakpoint.u: breakpoint.icn defaults.icn state.u
	$(UC) $(cflags) breakpoint

watchpoint.u: watchpoint.icn defaults.icn state.u
	$(UC) $(cflags) watchpoint

stepping.u: stepping.icn defaults.icn state.u
	$(UC) $(cflags) stepping

stack.u: stack.icn defaults.icn state.u
	$(UC) $(cflags) stack

data.u: data.icn defaults.icn state.u
	$(UC) $(cflags) data

trace.u: trace.icn defaults.icn state.u
	$(UC) $(cflags) trace

agent.u: agent.icn state.u
	$(UC) $(cflags) agent

internals.u: internals.icn defaults.icn agent.u state.u
	$(UC) $(cflags) internals

externals.u: externals.icn defaults.icn agent.u state.u
	$(UC) $(cflags) externals

print:
	enscript -1 -b " " $(SRC) -o udb.ps

zip:
	zip -r udb.zip ../udb

Clean: clean

clean:
	$(DEL) *.u
	$(DEL) $(EXEs) 
	$(DEL) *.exe
	$(DEL) *.dir
	$(DEL) *.pag
	$(DEL) *.db
	$(DEL) *~
	$(DEL) ../bin/$(EXEs) 
	cd lib; make clean

cleantools:
	cd lib; make cleantools



