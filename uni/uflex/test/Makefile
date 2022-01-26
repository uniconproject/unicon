#
# Katie Ray
# Project: ulex
# May 2, 2003
# makefile 
#

numbers.u: numbers.icn
	unicon -c numbers.icn

numbers.icn: numbers.l
	ulex numbers.l

wc: wc.u
	unicon wc.u

wc.u: wc.icn
	unicon -c wc

wc.icn: wc.l
	ulex wc.l

calcscan.u: calcscan.icn
	unicon -c calcscan

calcscan.icn: calcscan.l
	ulex calcscan.l

# for testing purposes

nummain: nummain.u numbers.u
	unicon nummain.u numbers.u

nummain.u: nummain.icn
	unicon -c nummain
