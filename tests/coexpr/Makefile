#  Makefile for testing Unicon coexpressions

include ../Makedefs

TEE=cat - > 
# 
# for verbose progress, run as:
# make verbose
# or 
# TEE=tee make -e [target ...]
#

DIFFTST = moveco
GREPTST = cobench stressCo stressCollectCo
#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
#IGNORE=$(COTST)
# ^ skipped. 
TARGETS= $(DIFFTST) $(GREPTST) 

# Do the tests
Test: DoTest

Uniconc : 
	SKIP=moveco TEE=tee UC="../../bin/unicon -C " make -e Test
#  moveco does coexpr(), not supported by iconc yet, skip. 


${GREPTST} : % : %.icn local stand/%.std
	-@$E -n "[Testing $@]... "
	@$(UC) $(UFLAGS) $<
	./$@ | $(TEE) local/$@.out
	-@grep -f stand/$@.std local/$@.out >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "OK"; \
	else echo "Failed"; diff -wy stand/$@.std local/$@.out > $@.diff; fi || true
	-@rm -f $@$(EXE)


include ../Makefile.test

Icont Test-icont :
		IC=unicon sh Test-icon $(COTST)

Iconc Test-iconc :
		IC="unicon -C " sh Test-icon $(COTST)

verbose: 
	TEE=tee $(MAKE) -e

