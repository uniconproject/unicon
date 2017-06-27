#  Makefile for testing Icon

PATTERNTST = ABCss assignss balss bigpss breaks expss failss fence fish lenss nspantst pairss pany parb parbno pimmed plen ppos prem ptab ralternate rasterisk rbasic rcurly rplus rquestion rtab sawss setcur

#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
TARGETS=$(PATTERNTST)

# Do the tests
Test: DoTest


include ../Makefile.test

Icont Test-icont Pattern Pattern-icont:
		IC=unicon sh Test-icon $(PATTERNTST)

Iconc Test-iconc Siconc Samples-iconc:
		IC="unicon -C -fd" sh Test-icon $(PATTERNTST)

