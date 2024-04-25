CC=cc
CFLAGS= -DVarTran
LDFLAGS=
SHELL=/bin/sh
MAKE=make
TOPDIR=../../..
SRCDIR=../../../src
UNIDIR=../../../uni

all:
	@echo "what do you want to make"


Clean Pure:
	rm -f $(TOPDIR)/Makedefs
	rm -f $(SRCDIR)/common/rswitch.[csS]

Setup:
	make -f ../Config/Makefile Clean
	make -f ../Config/Makefile Localcode
	make -f ../Config/Makefile Makefiles

Setup-X-Icon: Setup
	echo "#define Graphics 1" >> $(SRCDIR)/h/define.h
	-if [ -f xiconc.def ]; \
	    then cat xiconc.def >> $(SRCDIR)/h/define.h; fi
	echo "XPMLIB=-L../../bin -lXpm" > $(SRCDIR)/runtime/Makefile
	-if [ -f xiconx.mak ]; \
	    then cat xiconx.mak >> $(SRCDIR)/runtime/Makefile; \
	    else echo "XLIB= -lX11" >> $(SRCDIR)/runtime/Makefile; fi
	echo "XPM=xpm" >> $(SRCDIR)/runtime/Makefile
	cat runtime.hdr ../Config/runtime.mak >> $(SRCDIR)/runtime/Makefile
	cat ../Config/xpm.mak $(SRCDIR)/xpm/lib/Makefile
	echo "XPM=xpm" > $(SRCDIR)/iconc/Makefile
	cat iconc.hdr ../Config/iconc.mak >> $(SRCDIR)/iconc/Makefile


Makefiles:
	cp ../$(name)/rswitch.[cs] $(SRCDIR)/common
#	if [ -f ../$(name)/custom.sh ]; then cd ../$(name); sh custom.sh; fi


Localcode:
	cp define.h $(SRCDIR)/h
	cp rswitch.[csS] $(SRCDIR)/common
	-if grep -s NoRanlib define.h; \
	   then touch $(TOPDIR)/NoRanlib; \
	   else rm -rf $(TOPDIR)/NoRanlib; fi
