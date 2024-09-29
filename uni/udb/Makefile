BASE=../..
include $(BASE)/Makedefs.uni

EXEs    = udb
DEL     = -rm
CLEAN   = clean
cflags  = $(UFLAGS) -c 
ldflags = -u

.PHONY: all
#
# Add dependency on system include "evdefs.icn" because it is really sad
# if udb gets broken.
#
EVD     = ../../ipl/mincl/evdefs.icn

SRC       = udb.icn icode.icn srcfile.icn state.icn \
            agent.icn internals.icn externals.icn \
            breakpoint.icn watchpoint.icn stepping.icn stack.icn data.icn \
            trace.icn \
            evaluator.icn session.icn adapter.icn console.icn defaults.icn help.icn \
	    coexp.icn symtab.icn system.icn exparser.icn

UFILES    = udb.u icode.u srcfile.u state.u \
            agent.u internals.u externals.u \
            breakpoint.u watchpoint.u stepping.u stack.u data.u \
            trace.u  \
            evaluator.u session.u adapter.u console.u help.u coexp.u symtab.u system.u exparser.u

LIB       = lib
LIBRARY   = $(LIB)/listener.u      $(LIB)/memory.u     $(LIB)/structaliases.u \
            $(LIB)/structusage.u   $(LIB)/looptime.u   $(LIB)/proctime.u \
            $(LIB)/procprofile.u   $(LIB)/varprofile.u $(LIB)/deadvar.u \
            $(LIB)/failedloop.u    $(LIB)/failedsubscript.u\
            $(LIB)/typechange.u \
            $(LIB)/counter_deref.u       $(LIB)/counter_pcall.u \
            $(LIB)/counter_line.u  $(LIB)/counter_syntax.u

DTA        = dta
DTA_UFILES = $(DTA)/atomic_agent.u $(DTA)/temporals.u


all: Libfiles Assertions $(EXEs)


Libfiles:
	cd $(LIB); $(MAKE)

Assertions:
	cd $(DTA); $(MAKE)

tools:
	cd $(LIB); $(MAKE) tools

udb: $(UFILES) $(LIBRARY) $(DTA_UFILES)
	$(UC) $(ldflags) $(LIBRARY) $(DTA_UFILES) $(UFILES) -o udb
	$(CP) udb$(EXE) ../../bin

udb.u: udb.icn console.u
	$(UC) $(cflags) udb

adapter.u: adapter.icn
	$(UC) $(cflags) adapter

console.u: console.icn defaults.icn state.u session.u evaluator.u adapter.u
	$(UC) $(cflags) console

session.u: session.icn defaults.icn state.u evaluator.u externals.u
	$(UC) $(cflags) session

help.u: help.icn defaults.icn state.u
	$(UC) $(cflags) help

evaluator.u: evaluator.icn defaults.icn state.u data.u trace.u internals.u externals.u $(EVD)
	$(UC) $(cflags) evaluator

state.u: state.icn defaults.icn srcfile.u icode.u $(EVD)
	$(UC) $(cflags) state

srcfile.u: srcfile.icn
	$(UC) $(cflags) srcfile

icode.u: icode.icn
	$(UC) $(cflags) icode

breakpoint.u: breakpoint.icn defaults.icn state.u $(EVD)
	$(UC) $(cflags) breakpoint

watchpoint.u: watchpoint.icn defaults.icn state.u $(EVD)
	$(UC) $(cflags) watchpoint

stepping.u: stepping.icn defaults.icn state.u
	$(UC) $(cflags) stepping

stack.u: stack.icn defaults.icn state.u
	$(UC) $(cflags) stack

data.u: data.icn defaults.icn state.u
	$(UC) $(cflags) data

exparser.u: exparser.icn
	$(UC) $(cflags) exparser

trace.u: trace.icn defaults.icn state.u $(EVD)
	$(UC) $(cflags) trace

agent.u: agent.icn state.u
	$(UC) $(cflags) agent

internals.u: internals.icn defaults.icn agent.u state.u $(EVD)
	$(UC) $(cflags) internals

externals.u: externals.icn defaults.icn agent.u state.u
	$(UC) $(cflags) externals

coexp.u: coexp.icn
	$(UC) $(cflags) coexp

symtab.u: symtab.icn 
	$(UC) $(cflags) symtab

system.u: system.icn
	$(UC) $(cflags) system

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
	cd $(LIB); $(MAKE) clean
	cd $(DTA); $(MAKE) clean
	$(DEL) ../../bin/$(EXEs) 
	cd lib; $(MAKE) clean

cleantools:
	cd $(LIB); $(MAKE) cleantools
