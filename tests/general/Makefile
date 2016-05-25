#  Makefile for testing Icon


SAMPLES = btrees diffwrds kross meander prefix recogn roman sieve wordcnt



# default is to run all tests, using icont

Test Icont Test-icont:
		IC=icont sh Test-icon

Samples Sicont Samples-icont:
		IC=icont sh Test-icon $(SAMPLES)

Iconc Test-iconc:
		IC=iconc sh Test-icon

Siconc Samples-iconc:
		IC=iconc sh Test-icon $(SAMPLES)

Clean:
		-rm -f *.u? foo.baz local/*.out
		-rm -f `find [a-z]* -type f -perm -100 -print`
