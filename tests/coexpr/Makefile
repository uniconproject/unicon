#  Makefile for testing Unicon coexpressions

include ../Makedefs

DIFFTST = moveco
GREPTST = cobench stressCo stressCollectCo
#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
#IGNORE=$(COTST)
# ^ skipped. 
TARGETS= $(DIFFTST) $(GREPTST) 

# Do the tests
Test: DoTest
Uniconc : 
	UC="../../bin/unicon -C -DCOMPILER " make -e Test

${GREPTST} : % : %.icn local stand/%.std
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

