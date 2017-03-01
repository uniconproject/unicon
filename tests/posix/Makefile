SHELL=/bin/sh
MAKE=make

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

# default is to run all tests, using icont
Test:  $(TARGETS)


include ../Makefile.test


Icont Test-icont:
		IC=icont sh Test-icont icont

Iconc Test-iconc:
		IC=iconc sh Test-icont icont


##########################################################
#
#  Clean up.
#
Clean:
		rm -rf local/*
		-mkdir -p local
		touch local/.placeholder


