#  Makefile for testing Icon


SAMPLES = btrees diffwrds kross meander prefix recogn roman sieve wordcnt
TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

# Do not include these tests in standard testing
SKIP=mem01 mem02

# Do the tests
Test: DoTest

include ../Makefile.test


Icont Test-icont:
		IC=icont sh Test-icon

Samples Sicont Samples-icont:
		IC=icont sh Test-icon $(SAMPLES)

Iconc Test-iconc:
		IC=iconc sh Test-icon

Siconc Samples-iconc:
		IC=iconc sh Test-icon $(SAMPLES)

