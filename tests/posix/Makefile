
include ../Makedefs

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))
IGNORE=rusage

WINSKIP=pty_uni tcp rusage kill wait

# default is to run all tests, using icont
Test:  DoTest


include ../Makefile.test


Icont Test-icont:
		IC=icont sh Test-icont icont

Iconc Test-iconc:
		IC=iconc sh Test-icont icont



