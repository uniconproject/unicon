#
# UDB test makefile
#
# UDB is tested non-interactively by redirecting its input from a "script"
# consisting of the lines a user might type.  The -line option to udb
# avoid bogus per-input-character console handling.
#
# The sample program watchme.icn is compiled and run as the subject being
# "debugged".
#

UDB=udb -line

all: basic watchpoints internals info assert trace

basic: watchme
	$(UDB) watchme <basic.udb &>basic.out
	-diff basic.std basic.out

watchpoints: watchme
	$(UDB) watchme <watch.udb &>watch.out
	-diff watch.std watch.out

watchme: watchme.icn
	unicon watchme

internals:
	$(UDB) watchme < counter_line.udb &>counter_line.out
	-diff counter_line.std counter_line.out
	$(UDB) watchme < counter_syntax.udb &> counter_syntax.out
	-diff counter_syntax.std counter_syntax.out
	$(UDB) watchme < counter_deref.udb &> counter_deref.out
	-diff counter_deref.std counter_deref.out
	$(UDB) watchme < counter_pcall.udb &> counter_pcall.out
	-diff counter_pcall.std counter_pcall.out
	$(UDB) watchme < failedloop.udb
	$(UDB) watchme < deadvar.udb
	$(UDB) watchme < memory.udb
	$(UDB) watchme < structusage.udb
	$(UDB) watchme < varprofile.udb
	$(UDB) watchme < looptime.udb
	$(UDB) watchme < failedsubscript.udb
	-$(UDB) watchme < typechange.udb
	$(UDB) watchme < proctime.udb
	$(UDB) watchme < procprofile.udb

info: watchme
	$(UDB) watchme < info.udb

assert: watchme
	$(UDB) watchme <assert.udb

trace: watchme
	$(UDB) watchme <trace.udb
