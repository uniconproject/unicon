#  Makefile for testing Unicon coexpressions

COTST = cobench stressCo stressCollectCo
#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
#IGNORE=$(COTST)
# ^ skipped. 
TARGETS=$(COTST)
GREP=${COTST}

# Do the tests
Test: DoTest
Uniconc : 
	UC="../../unicon -C " make Test

${GREP} : % : %.icn local stand/%.std
	-@$E -n "[Testing $@]... "
	@$(UC) $<
	./$@ | tee local/$@.out
	-@grep -f stand/$@.std local/$@.out >/dev/null; \
	if [ $$? -eq 0 ] ; then echo "OK"; \
	else echo "Failed"; diff -wy stand/$@.std local/$@.out > $@.diff; fi || true
	-@rm $@$(EXE)
	

include ../Makefile.test

Icont Test-icont :
		IC=unicon sh Test-icon $(COTST)

Iconc Test-iconc :
		IC="unicon -C " sh Test-icon $(COTST)

