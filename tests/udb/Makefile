all: basic watchpoints internals info assert trace

basic: watchme
	udb watchme <basic.udb &>basic.out
	-diff basic.std basic.out

watchpoints: watchme
	udb watchme <watch.udb &>watch.out
	-diff watch.std watch.out

watchme: watchme.icn
	unicon watchme

internals:
	udb watchme < counter_line.udb &>counter_line.out
	-diff counter_line.std counter_line.out
	udb watchme < counter_syntax.udb &> counter_syntax.out
	-diff counter_syntax.std counter_syntax.out
	udb watchme < counter_deref.udb &> counter_deref.out
	-diff counter_deref.std counter_deref.out
	udb watchme < counter_pcall.udb &> counter_pcall.out
	-diff counter_pcall.std counter_pcall.out
	udb watchme < failedloop.udb
	udb watchme < deadvar.udb
	udb watchme < memory.udb
	udb watchme < structusage.udb
	udb watchme < varprofile.udb
	udb watchme < looptime.udb
	udb watchme < failedsubscript.udb
	-udb watchme < typechange.udb
	udb watchme < proctime.udb
	udb watchme < procprofile.udb

info: watchme
	udb watchme < info.udb

assert: watchme
	udb watchme <assert.udb

trace: watchme
	udb watchme <trace.udb
