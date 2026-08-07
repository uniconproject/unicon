include ../Makedefs

TESTNAME=udb

CON=$(shell $(UC) -features | grep -o "multiple programs")
UDBTESTS= adapter
TARGETS=$(UDBTESTS)

Test: DoTest

include ../Makefile.test

define check_output
	@tr -d '\r' < local/$@.out > local/$@.nr; \
	if [ x$(EXE) = x.exe ] && [ -f stand/$@.wstd ] ; then \
	diff -wq stand/$@.wstd local/$@.nr >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "w pass"; \
	else echo "w FAIL"; \
	diff --suppress-common-lines -wy stand/$@.wstd local/$@.nr > $@.diff; fi \
	else \
	diff -wq stand/$@.std local/$@.nr >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "pass"; \
	else \
	if grep -qi "This Program Requires" local/$@.out; then cat local/$@.out; \
	else echo "FAIL"; \
	diff --suppress-common-lines -wy stand/$@.std local/$@.nr > $@.diff; fi \
	fi; \
	fi || true
endef

ifeq ($(CON),multiple programs)
TARGETS=$(UDBTESTS)
else
skip:
	@echo "\nMultiple programs are not available in this build"
	@echo "SKIP: multiple programs test\n"

TARGETS=skip
endif

basic watchpoints counter_line counter_syntax counter_deref counter_pcall: %: local stand/%.std input/%.udb watchme
	-@$E -n "[Testing $@]... "
	@../../bin/udb --line watchme < input/$@.udb > local/$@.out 2>&1 || true
	$(check_output)

print: %: local stand/%.std input/%.udb printme
	-@$E -n "[Testing $@]... "
	@../../bin/udb --line printme < input/$@.udb > local/$@.out 2>&1 || true
	$(check_output)

breakpoints coexp: %: local stand/%.std input/%.udb prime
	-@$E -n "[Testing $@]... "
	@../../bin/udb --line prime < input/$@.udb > local/$@.out 2>&1 || true
	$(check_output)

scoping: %: local stand/%.std input/%.udb scopes
	-@$E -n "[Testing $@]... "
	@../../bin/udb --line scopes < input/$@.udb > local/$@.out 2>&1 || true
	$(check_output)

watchme: watchme.icn
	@$(UC) $(UFLAGS) $< > /dev/null 2>&1

printme: printme.icn
	@$(UC) $(UFLAGS) $< > /dev/null 2>&1

prime: foo.icn prime.icn
	@$(UC) $(UFLAGS) -o $@ $^ > /dev/null 2>&1

scopes: scopepkg.icn scopes.icn
	@$(UC) $(UFLAGS) -o $@ $^ > /dev/null 2>&1

test_adapter: adapter.icn
	@$(UC) $(UFLAGS) $< -o $@ > /dev/null 2>&1

data/test_target: data/test_target.icn
	@$(UC) $(UFLAGS) -o $@ $< > /dev/null 2>&1

adapter: local stand/adapter.std data/test_target test_adapter
	-@$E -n "[Testing $@]... "
	@PATH=../../bin:$$PATH ./test_adapter > local/$@.out 2>&1 || true
	$(check_output)
