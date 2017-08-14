#  Makefile for testing Icon

include ../Makedefs

SAMPLES = btrees diffwrds kross meander prefix recogn roman sieve wordcnt
TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

# Do not include these tests in standard testing
SKIP=mem01 mem02

WINSKIP=cfuncs

# Do the tests
Test: DoTest

include ../Makefile.test


Icont Test-icont:
		IC=icont sh Test-icon

Samples Sicont Samples-icont:
		IC=icont sh Test-icon $(SAMPLES)

Iconc :
		IC=iconc sh Test-icon

Test-iconc : 
	./Test-iconc iconc
	./Test-iconc large -fld
	./Test-iconc coexpr -fds 
	./Test-iconc  invoke -fs
	./Test-iconc  errcnv -fa
	./Test-iconc  debug -fd


Siconc Samples-iconc:
		IC=iconc sh Test-icon $(SAMPLES)

