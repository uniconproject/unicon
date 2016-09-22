#  Makefile for testing Icon

PATTERNTST = ABCss assignss balss bigpss breaks expss failss fence fish lenss nspantst pairss pany parb parbno pimmed plen ppos prem ptab sawss setcur

# default is to run all tests, using icont

Test Icont Test-icont Pattern Pattern-icont:
		IC=unicon sh Test-icon $(PATTERNTST)

Iconc Test-iconc Siconc Samples-iconc:
		IC=iconc sh Test-icon $(PATTERNTST)

Clean:
		-rm -f *.u? foo.baz local/*.out
		-rm -f `find [a-z]* -type f -perm -100 -print`
