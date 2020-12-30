#  Makefile for the Icon Program Library

include ../Makedefs.uni

#  Make a library distribution (portable ucode and include files).

Ilib:	../bin/libcfunc.so
../bin/libcfunc.so:  ../bin/$(UNICONT)
	cp incl/*.icn gincl/*.icn cfuncs/icall.h ../lib
	$(MAKE) -C procs
	$(MAKE) -C gprocs
	$(MAKE) -C mprocs
	cd cfuncs; LPATH= $(MAKE) ICONT=../../bin/$(UNICONT)
	mv cfuncs/*.u? lib
	mv cfuncs/libcfunc.so ../bin


#  Make selected program binaries (platform-dependent icode) for ../bin,
#  given that ../lib is ready

Ibin:	../bin/ipatch
../bin/ipatch:  ../bin/$(UNICONT)
	MAKE=$(MAKE) ./BuildBin


#  Make a full set of program binaries (not usually done) in ./iexe,
#  given that ../lib is ready

Iexe:
	rm -f iexe/*
	MAKE=$(MAKE) ./BuildExe


#  Check for undefined identifiers in ../lib.
#  (A few are expected: references to Mp, program, init, goal).

Undef:
	cd ../lib; for f in *.u2; do (echo $$f; $(UNICONT) -us -fs $$f); done


#  Check for stray files

Strays:
	for d in *procs *progs *incl; do (cd $$d; pwd; gcomp CVS *.icn); done


#  Verify that all procedures and programs build, including packs,
#  and perform some other sanity checks

Check:
	./CheckAll


#  Clean up.

clean Clean Pure:
	rm -rf iexe */*.u */*.zip
	cd cfuncs && $(MAKE) Clean
	$(MAKE) -C procs Clean
	$(MAKE) -C gprocs Clean
	$(MAKE) -C mprocs Clean
	cd gpacks/carpets && $(MAKE) Clean
	cd gpacks/drawtree && $(MAKE) Clean
	cd gpacks/ged && $(MAKE) Clean
	cd gpacks/htetris && $(MAKE) Clean
	cd gpacks/tiger && $(MAKE) Clean
	cd gpacks/vib && $(MAKE) Clean
	cd gpacks/weaving && $(MAKE) Clean
	cd gpacks/xtiles && $(MAKE) Clean
	for d in packs/[d-qs-z]*; do (cd $$d && $(MAKE) Clean); done
