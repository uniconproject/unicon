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
#

UDB=udb -line
TESTNAME=udb
INTERNALS=counter_line counter_syntax counter_deref counter_pcall
PROGS=watchme printme prime scopes

# need more .stds for testing
#TESTS=basic print watchpoints $(INTERNALS) info assert trace
TESTS=basic print breakpoints watchpoints $(INTERNALS) coexp scoping adapter

# directories
OUTPUT=local
DIFFS=diffs

all: $(PROGS) TestHdr TestSuite 

debug: TestSuite

watchme: watchme.icn
	unicon watchme

printme: printme.icn
	unicon printme

prime: foo.icn prime.icn
	unicon -o $@ $^

scopes: scopepkg.icn scopes.icn
	unicon -o $@ $^

data/test_target: data/test_target.icn
	@unicon -o $@ $< > /dev/null 2>&1

adapter: adapter.icn data/test_target stand/adapter.std
	@mkdir -p $(OUTPUT) $(DIFFS)
	@unicon adapter.icn -o test_adapter > /dev/null 2>&1
	@./test_adapter > $(OUTPUT)/$@.out 2>&1
	@printf "[Testing %s]..." "$@"
	@if diff -du stand/$@.std $(OUTPUT)/$@.out > $(DIFFS)/$@.diff ; then \
	  echo pass; \
	else \
	  echo FAIL; \
	fi

coexp: prime
	@./test.sh $< $@

basic: watchme
	@./test.sh $< $@

watchpoints: watchme
	@./test.sh $< $@

breakpoints: prime
	@./test.sh $< $@

print: printme
	@./test.sh $< $@

scoping: scopes
	@./test.sh $< $@

#internals: watchme
internals: $(INTERNALS)

counter_line: watchme
	@./test.sh $< $@

counter_syntax: watchme
	@./test.sh $< $@

counter_deref: watchme
	@./test.sh $< $@

counter_pcall: watchme
	@./test.sh $< $@

#	$(UDB) watchme < counter_line.udb &>counter_line.out
#	-diff counter_line.std counter_line.out
#	$(UDB) watchme < counter_syntax.udb &> counter_syntax.out
#	-diff counter_syntax.std counter_syntax.out
#	$(UDB) watchme < counter_deref.udb &> counter_deref.out
#	-diff counter_deref.std counter_deref.out
#	$(UDB) watchme < counter_pcall.udb &> counter_pcall.out
#	-diff counter_pcall.std counter_pcall.out
#	$(UDB) watchme < failedloop.udb
#	$(UDB) watchme < deadvar.udb
#	$(UDB) watchme < memory.udb
#	$(UDB) watchme < structusage.udb
#	$(UDB) watchme < varprofile.udb
#	$(UDB) watchme < looptime.udb
#	$(UDB) watchme < failedsubscript.udb
#	-$(UDB) watchme < typechange.udb
#	$(UDB) watchme < proctime.udb
#	$(UDB) watchme < procprofile.udb

info: watchme
	@./test.sh $< $@

assert: watchme
	@./test.sh $< $@

trace: watchme
	@./test.sh $< $@

TestHdr:
	@echo ""
	@echo "-------------------------- UDB Test Suite --------------------------"

TestSuite: $(TESTS) 
	@:

Summary:
	@p=0; f=0; time="-"; \
	for x in $(TESTS); do \
	  if [ -s $(DIFFS)/$$x.diff ]; then \
	    f=`expr $$f + 1`; \
	  else \
	    p=`expr $$p + 1`; \
	  fi; \
	done; \
	if [ -f .suite_duration ]; then time="$$(cat .suite_duration)s"; fi; \
	if [ $$f -eq 0 ]; then res=pass; else res=FAIL; fi; \
	if [ $$f -eq 0 ]; then \
	  printf "%-10s  %3d %3d %3d  %6s  %s\n" "$(TESTNAME)" $$p $$f 0 "$$time" "$$res"; \
	else \
	  printf "%-10s  %3d %3d %3d  %6s  FAIL: %d tests\n" "$(TESTNAME)" $$p $$f 0 "$$time" $$f; \
	fi

print-pfs:
	@p=0; f=0; \
	for x in $(TESTS); do \
	  if [ -s $(DIFFS)/$$x.diff ]; then \
	    f=`expr $$f + 1`; \
	  else \
	    p=`expr $$p + 1`; \
	  fi; \
	done; \
	echo "$$p $$f 0"

# remove diff and output files
clean:
	rm $(DIFFS)/*.diff
	rm $(OUTPUT)/*.out
	rm -f test_adapter adapter.u test_target.u data/test_target

.PHONY: all debug TestSuite Summary print-pfs clean \
	basic print breakpoints watchpoints $(INTERNALS) coexp scoping adapter internals
