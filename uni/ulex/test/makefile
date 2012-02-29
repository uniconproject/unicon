#
# Katie Ray
# Project: ulex
# May 2, 2003
# makefile 
#

numbers: numbers.u ulexskel.u helpers.u
	unicon numbers.u 

numbers.u: numbers.icn ulexskel.icn helpers.u
	unicon -c numbers.icn

numbers.icn: numbers.l
	ulex numbers.l

ulexskel.u: ulexskel.icn 
	unicon -c ulexskel.icn

helpers.u: helpers.icn
	unicon -c helpers.icn

# for testing purposes

nummain: nummain.u numbers.u
	unicon nummain.u numbers.u

nummain.u: nummain.icn
	unicon -c nummain
