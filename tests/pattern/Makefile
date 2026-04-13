#  Makefile for testing Icon

include ../Makedefs

PATTERNTST = ABCss assignss balss bigpss breaks expss failss fence fish lenss nspantst pairss pany parb parbno pimmed peval plen ppos prem ptab ralternate rasterisk rbasic rcurly rplus rquestion rtab sawss setcur unevalcharss unevalintss 

PAT=$(shell $(UC) -features 2>/dev/null | grep -o "pattern type")

# --enable-thin forces pattern off; skip the whole suite when unsupported.
ifeq ($(PAT),pattern type)
TARGETS=$(PATTERNTST)
else
skip:
	@echo ""
	@echo "Pattern type is not available in this build."
	@echo "SKIP: pattern tests"

TARGETS=skip
endif

# Do the tests
Test: DoTest


include ../Makefile.test

Icont Test-icont Pattern Pattern-icont:
		IC=unicon sh Test-icon $(PATTERNTST)

Iconc Test-iconc Siconc Samples-iconc:
		IC="unicon -C -fd" sh Test-icon $(PATTERNTST)

