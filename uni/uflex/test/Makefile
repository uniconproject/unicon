#
# Katie Ray
# Project: ulex
# May 2, 2003
# makefile 
#
tests: nnws.tst j0.tst

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

nummain: nummain.u numbers.u
	unicon nummain.u numbers.u

nummain.u: nummain.icn
	unicon -c nummain

timetst2.u: timetst2.icn
	unicon -c timetst2

nnws nnws.tst: timetst2.u nnws.l Makefile
	../uflex nnws
	unicon nnws timetst2.u
	./nnws -p dorrie.in > local/nnws.out
	@if diff --strip-trailing-cr local/nnws.out stand/nnws.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

j0 j0.tst: javalex.l j0.icn Makefile
	../uflex javalex
	unicon j0 javalex
	./j0 hello.java > local/j0.out
	@if diff --strip-trailing-cr local/j0.out stand/j0.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi
