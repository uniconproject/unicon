SHELL=/bin/sh
MAKE=make

#what:
#		@echo "what do you want to make?"

# default is to run all tests, using icont

default: Test

Test Icont Test-icont:
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


