#  Makefile for testing Unicon coexpressions

BIN=../../bin
include ../Makedefs

#
# for verbose progress, run as:
# $(MAKE) verbose
# or
# Verbose=1 $(MAKE) -e [target ...]
#

#TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
#IGNORE=$(COTST)
# ^ skipped.
TARGETS= moveco co cobench stressCo stressCollectCo

# Do the tests
Test: DoTest

Uniconc :
	SKIP=moveco Verbose=1 UC="$(UCC)" $(MAKE) -e Test
#  moveco does coexpr(), not supported by iconc yet, skip.


include ../Makefile.test

#icont Icont Test-icont :
#	SKIP=stressCollectCo IC=$(BIN)/icont sh Test-icon $(COTST)

icont Icont :
	SKIP=stressCollectCo UC="$(BIN)/icont" $(MAKE) -e Test

iconc Iconc :
	SKIP="moveco stressCollectCo" Verbose=1 UC="$(BIN)/iconc" $(MAKE) -e Test
#  moveco does coexpr(), not supported by iconc yet, skip.

Verbose verbose:
	Verbose=1 $(MAKE) -e
