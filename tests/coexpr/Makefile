#  Makefile for testing Unicon coexpressions

BIN=../../bin
include ../Makedefs

ifdef Verbose
TEE=tee
else
TEE=cat - > 
endif

# 
# for verbose progress, run as:
# make verbose
# or 
# Verbose=1 make -e [target ...]
#

DIFFTST = moveco co
GREPTST = cobench 
GREPODTST = stressCo 
GREPDIFFTST = stressCollectCo
#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
#IGNORE=$(COTST)
# ^ skipped. 
TARGETS= $(DIFFTST) $(GREPTST) $(GREPODTST) $(GREPDIFFTST)

# Do the tests
Test: DoTest

Uniconc : 
	SKIP=moveco Verbose=1 UC="$(UCC)" make -e Test
#  moveco does coexpr(), not supported by iconc yet, skip. 


${GREPTST} : % : %.icn local stand/%.std
	-@$E -n "[Testing $@]... "
	@$(UC) $(UFLAGS) $<
	-./$@ | $(TEE) local/$@.out
	-@grep -f stand/$@.std local/$@.out >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "OK"; \
	else echo "$@ Failed"; diff -wy stand/$@.std local/$@.out > $@.diff; fi || true
	-@rm -f $@$(EXE)
# ALERT: this will pass if ANY lines in .std match ANY part of any line in .out
# use GREPDIFFTST for a stricter match

${GREPDIFFTST} : % : %.icn local stand/%.std stand/%.grep
	-@$E -n "[Testing $@]... "
	@$(UC) $(UFLAGS) $<
	-./$@ | $(TEE) local/$@.out
	-@grep -f stand/$@.grep local/$@.out | diff stand/$@.std - > /dev/null ; \
	if [ $$? -eq 0 ] ; then echo "OK"; \
	else echo "$@ Failed"; \
	grep -f stand/$@.grep local/$@.out | diff -wy stand/$@.std - > $@.diff; \
	fi || true
	-@rm -f $@$(EXE)
# This will pass if all lines of .out with ANY part matching any line in .grep match .std 

${GREPODTST} : % : %.icn local stand/%.std stand/%.grep
	-@$E -n "[Testing $@]... "
	@$(UC) $(UFLAGS) $<
	-./$@ | $(TEE) local/$@.out
	-@grep -o -f stand/$@.grep local/$@.out | diff stand/$@.std - > /dev/null ; \
	if [ $$? -eq 0 ] ; then echo "OK"; \
	else echo "$@ Failed"; \
	grep -o -f stand/$@.grep local/$@.out | diff -wy stand/$@.std - > $@.diff; \
	fi || true
	-@rm -f $@$(EXE)
# This will pass if all parts of lines of .out  matching any line in .grep match .std 


include ../Makefile.test

#icont Icont Test-icont :
#	SKIP=stressCollectCo IC=$(BIN)/icont sh Test-icon $(COTST)

icont Icont : 
	SKIP=stressCollectCo UC="$(BIN)/icont" make -e Test

iconc Iconc : 
	SKIP="moveco stressCollectCo" Verbose=1 UC="$(BIN)/iconc" make -e Test
#  moveco does coexpr(), not supported by iconc yet, skip. 

Verbose verbose: 
	Verbose=1 $(MAKE) -e

