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

Clean:
	rm -f $(SRCDIR)/common/rswitch.[csS]

Makefiles:
	-if [ -f ../$(name)/top.hdr ]; \
	    then echo "found top.hdr" && cat ../$(name)/top.hdr ../Config/top.mak > $(TOPDIR)/Makefile; \
	    else echo "no top.hdr " && cp ../Config/top.mak $(TOPDIR)/Makefile; fi
	cat ../Config/rtt.mak > $(SRCDIR)/rtt/Makefile
	cat ../Config/common.mak > $(SRCDIR)/common/Makefile
	cat ../Config/iconc.mak > $(SRCDIR)/iconc/Makefile
	cat ../Config/preproc.mak > $(SRCDIR)/preproc/Makefile
	cat ../Config/icont.mak > $(SRCDIR)/icont/Makefile
	cat ../Config/runtime.mak > $(SRCDIR)/runtime/Makefile
	cat ../Config/xpm.mak > $(SRCDIR)/xpm/lib/Makefile
	-mkdir -p $(TOPDIR)/ipl/lib
	cp unicon.mak $(UNIDIR)/unicon/makefile
	cp ipllib.mak $(TOPDIR)/ipl/lib/makefile
	# no longer copy ide.mak; ide/makefile is multiplatform
	# cp ide.mak $(UNIDIR)/ide/makefile
	cp ivib.mak $(UNIDIR)/ivib/makefile
	cp unilib.mak $(UNIDIR)/lib/makefile
	cp xml.mak $(UNIDIR)/xml/makefile
	cp unidep.mak $(UNIDIR)/unidep/makefile
	cp unidoc.mak $(UNIDIR)/unidoc/makefile
	cp parser.mak $(UNIDIR)/parser/makefile
	cp util.mak $(UNIDIR)/util/makefile
	cp gui.mak $(UNIDIR)/gui/makefile
	cp native.mak $(UNIDIR)/native/makefile
	cp guidemos.mak $(UNIDIR)/gui/guidemos/makefile
	cp ivib-v2.mak $(UNIDIR)/gui/ivib/makefile
	cp uni-top.mak $(UNIDIR)/Makefile
	cp iyacc.mak $(UNIDIR)/iyacc/Makefile
	cp uni-makedefs $(UNIDIR)/makedefs

Localcode:
	cp define.h $(SRCDIR)/h
	cp rswitch.[csS] $(SRCDIR)/common
	-if grep -s NoRanlib define.h; \
	   then touch $(TOPDIR)/NoRanlib; \
	   else rm -rf $(TOPDIR)/NoRanlib; fi
