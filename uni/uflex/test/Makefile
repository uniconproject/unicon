#
# uflex test directory makefile
#
BASE=../../..
include $(BASE)/Makedefs.uni
UFLEX=../uflex

tests: nnws.tst j0.tst

numbers.u: numbers.icn
	$(UNICON) -c numbers.icn

numbers.icn: numbers.l
	$(UFLEX) numbers.l

wc: wc.u
	$(UNICON) wc.u

wc.u: wc.icn
	$(UNICON) -c wc

wc.icn: wc.l
	$(UFLEX) wc.l

calcscan.u: calcscan.icn
	$(UNICON) -c calcscan

calcscan.icn: calcscan.l
	$(UFLEX) calcscan.l

nummain: nummain.u numbers.u
	$(UNICON) nummain.u numbers.u

nummain.u: nummain.icn
	$(UNICON) -c nummain

timetst2.u: timetst2.icn
	$(UNICON) -c timetst2

nnws nnws.tst: timetst2.u nnws.l Makefile
	../uflex nnws
	$(UNICON) -s nnws timetst2.u
	./nnws -p dorrie.in > local/nnws.out
	@if diff --strip-trailing-cr local/nnws.out stand/nnws.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

j0 j0.tst: javalex.l j0.icn Makefile
	../uflex javalex
	$(UNICON) -s j0 javalex
	./j0 hello.java > local/j0.out
	@if diff --strip-trailing-cr local/j0.out stand/j0.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi
