include ../Makedefs

TESTNAME=udb
UDB=../../bin/udb --line

UDBTARGETS=basic print breakpoints watchpoints counter_line counter_syntax \
	counter_deref counter_pcall coexp scoping
TARGETS=$(UDBTARGETS) adapter
CLEAN_EXTRA=watchme printme prime scopes test_adapter data/test_target

Test: DoTest

include ../Makefile.test

basic watchpoints counter_line counter_syntax counter_deref counter_pcall: PROG=watchme
print: PROG=printme
breakpoints coexp: PROG=prime
scoping: PROG=scopes

watchme: watchme.icn
	@$(UC) $(UFLAGS) $< > /dev/null 2>&1

printme: printme.icn
	@$(UC) $(UFLAGS) $< > /dev/null 2>&1

prime: foo.icn prime.icn
	@$(UC) $(UFLAGS) -o $@ $^ > /dev/null 2>&1

scopes: scopepkg.icn scopes.icn
	@$(UC) $(UFLAGS) -o $@ $^ > /dev/null 2>&1

data/test_target: data/test_target.icn
	@$(UC) $(UFLAGS) -o $@ $< > /dev/null 2>&1

adapter: local stand/adapter.std data/test_target
	-@$E -n "[Testing $@]... "
	@$(UC) $(UFLAGS) adapter.icn -o test_adapter > /dev/null 2>&1
	@./test_adapter > local/$@.out 2>&1 || true
	@if [ x$(EXE) = x.exe ] && [ -f stand/$@.wstd ] ; then \
	diff -wq stand/$@.wstd local/$@.out >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "w pass"; \
	else echo "w FAIL"; \
	diff --suppress-common-lines -wy stand/$@.wstd local/$@.out > $@.diff; fi \
	else diff -wq stand/$@.std local/$@.out >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "pass"; \
	else \
	if grep -qi "This Program Requires" local/$@.out; then cat local/$@.out; \
	else echo "FAIL"; \
	diff --suppress-common-lines -wy stand/$@.std local/$@.out > $@.diff; fi \
	fi; \
	fi || true
