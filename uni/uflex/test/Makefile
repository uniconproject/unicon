#
# uflex test directory makefile
#
BASE=../../..
include $(BASE)/Makedefs.uni
UFLEX=../uflex

tests: nnws.tst j0.tst toy.tst k0.tst go.tst fec.tst ucc.tst 120.tst ubug.tst uniflex.tst punylex.tst

timetst:
	time make runtests

runtests:
	./nnws -p dorrie.in > local/nnws.out
	./j0 hello.java > local/j0.out
	./toy hello.p > local/toy.out
	./k0 hello.kt > local/k0.out
	./go hello.go > local/go.out
	./fec hello.rs > local/fec.out
	./ucc hello.c > local/c.out
	./120 hello.cpp > local/cpp.out
	./ubug foo.icn > local/ubug.out
	./uniflex -p hello.icn > local/uniflex.out
	./punylex hello.py > local/punylex.out

numbers.u: numbers.icn
	$(UNICON) -c numbers.icn

numbers.icn: numbers.l
	$(UFLEX) numbers.l

wc: wc.u
	$(UNICON) wc.u

wc.u: wc.icn
	$(UNICON) $(UFLAGS) -c wc

wc.icn: wc.l
	$(UFLEX) wc.l

calcscan.u: calcscan.icn
	$(UNICON) $(UFLAGS) -c calcscan

calcscan.icn: calcscan.l
	$(UFLEX) calcscan.l

nummain: nummain.u numbers.u
	$(UNICON) nummain.u numbers.u

nummain.u: nummain.icn
	$(UNICON) $(UFLAGS) -c nummain

timetst2.u: timetst2.icn
	$(UNICON) $(UFLAGS) -c timetst2

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

toy toy.tst: toy.l toymain.icn Makefile
	../uflex toy
	$(UNICON) -s toy toymain
	./toy hello.p > local/toy.out
	@if diff --strip-trailing-cr local/toy.out stand/toy.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

k0 k0.tst: k0lex.l k0.icn Makefile
	../uflex k0lex
	$(UNICON) -s k0 k0lex
	./k0 hello.kt > local/k0.out
	@if diff --strip-trailing-cr local/k0.out stand/k0.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

go go.tst: go.l gomain.icn Makefile
	../uflex go
	$(UNICON) -s go gomain
	./go hello.go > local/go.out
	@if diff --strip-trailing-cr local/go.out stand/go.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

fec fec.tst: rustlex.l rustmain.icn Makefile
	../uflex rustlex
	$(UNICON) -s -o fec rustlex rustmain
	./fec hello.rs > local/fec.out
	@if diff --strip-trailing-cr local/fec.out stand/fec.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

ucc ucc.tst: clex.l cmain.icn Makefile
	../uflex clex
	$(UNICON) -s -o ucc clex cmain
	./ucc hello.c > local/c.out
	@if diff --strip-trailing-cr local/c.out stand/c.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

120 120.tst: 120lex.l Makefile
	../uflex 120lex
	$(UNICON) -s -o 120 120lex
	./120 hello.cpp > local/cpp.out
	@if diff --strip-trailing-cr local/cpp.out stand/cpp.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

ubug ubug.tst: ubug.l timetst3.icn Makefile
	../uflex ubug
	$(UNICON) -s ubug timetst3
	./ubug foo.icn > local/ubug.out
	@if diff --strip-trailing-cr local/ubug.out stand/ubug.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

uniflex uniflex.tst: uniflex.l timetst2.icn Makefile
	../uflex uniflex
	$(UNICON) -s uniflex timetst2
	./uniflex -p hello.icn > local/uniflex.out
	@if diff --strip-trailing-cr local/uniflex.out stand/uniflex.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

punylex punylex.tst: punylex.l Makefile
	../uflex punylex
	$(UNICON) -s punylex
	./punylex hello.py > local/punylex.out
	@if diff --strip-trailing-cr local/punylex.out stand/punylex.std ; then echo "++++++++++++++++++++ Passed"; else echo "-------------------- Failed"; fi

clean:
	$(RM) *.u nnws$(EXE) j0$(EXE) toy$(EXE) k0$(EXE) go$(EXE) fec$(EXE) ucc$(EXE) 120$(EXE) ubug$(EXE) uniflex$(EXE) punylex$(EXE) local/j0.out local/nnws.out local/toy.out local/k0.out local/go.out local/fec.out local/c.out local/cpp.out local/ubug.out local/uniflex.out local/punylex.out
