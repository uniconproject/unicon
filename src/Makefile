SHELL=/bin/sh
MAKE=make
what:
	@echo "What do you want to make?"

Clean:
		cd iconc; rm -f *.o iconc
		cd common; rm -f *.o doincl patchstr
		cd preproc; rm -f *.o pp
		cd rtt; rm -f *.o rtt
		cd runtime; rm -f *.c *.o rt.db rt.a rttcur.lst\
		  rttfull.lst iconx
		cd icont; rm -f *.o icont iconx.hdr hdr.h newhdr
		-cd xpm/lib && make Clean && rm -f *.o *.a
		-cd gdbm && make distclean
		-cd libtp && make distclean
# force full rebuild of runtime system
		touch h/define.h
