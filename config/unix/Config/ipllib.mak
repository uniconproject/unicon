all:
	if grep LoadFunc ../../src/h/define.h >/dev/null; then $(MAKE) Cfun; fi
	cd ..; sh Translate-icont

Cfun:
	cd ../cfuncs; LPATH= $(MAKE) ICONT=../../bin/icont
	-cd ../cfuncs; cp cfunc.u ../lib
	-cd ../cfuncs; cp libcfunc.so ../../bin
