CC=cc
CFLAGS= -DVarTran
LDFLAGS=
SHELL=/bin/sh
MAKE=make

all:
		@echo "what do you want to make"

Setup:
		make -f ../Config/Makefile Clean
		make -f ../Config/Makefile Localcode
		make -f ../Config/Makefile Makefiles

Setup-X-Icon: Setup
		echo "#define Graphics 1" >>../../../src/h/define.h
		-if [ -f xiconc.def ]; \
		    then cat xiconc.def >> ../../../src/h/define.h; fi
		echo "XPMLIB=-L../../bin -lXpm" > ../../../src/runtime/Makefile
		-if [ -f xiconx.mak ]; \
		    then cat xiconx.mak >> ../../../src/runtime/Makefile; \
		    else echo "XLIB= -lX11" \
			>> ../../../src/runtime/Makefile; fi
		echo "XPM=xpm" >> ../../../src/runtime/Makefile
		cat runtime.hdr ../Config/runtime.mak \
		   >> ../../../src/runtime/Makefile
		cat xpm.hdr ../Config/xpm.mak \
		   > ../../../src/xpm/lib/Makefile
		echo "XPM=xpm" > ../../../src/iconc/Makefile
		cat iconc.hdr ../Config/iconc.mak \
		   >> ../../../src/iconc/Makefile

Clean:
		rm -f ../../../src/common/rswitch.[csS]

Makefiles:
		cat rtt.hdr ../Config/rtt.mak \
		   > ../../../src/rtt/Makefile
		cat common.hdr ../Config/common.mak \
		   > ../../../src/common/Makefile
		cat iconc.hdr ../Config/iconc.mak \
		   > ../../../src/iconc/Makefile
		cat preproc.hdr ../Config/preproc.mak \
		   > ../../../src/preproc/Makefile
		cat icont.hdr ../Config/icont.mak \
		   > ../../../src/icont/Makefile
		cat runtime.hdr ../Config/runtime.mak \
		   > ../../../src/runtime/Makefile
		echo "ICONT=../../bin/icont" > ../../../uni/unicon/makefile
		echo "COPY=cp" >> ../../../uni/unicon/makefile
		echo "RM=rm -f" >> ../../../uni/unicon/makefile
		echo "BINDIR=../../bin" >> ../../../uni/unicon/makefile
		echo "UNICON=../unicon/unicon" >> ../../../uni/unicon/makefile
		cat ../Config/unicon.mak >> ../../../uni/unicon/makefile
		echo "RM=rm -f" > ../../../uni/lib/makefile
		echo "UNICON=../unicon/unicon" >> ../../../uni/lib/makefile
		cat ../Config/unilib.mak >> ../../../uni/lib/makefile
		echo "RM=rm -f" > ../../../uni/ivib/makefile
		echo "UNICON=../unicon/unicon" >> ../../../uni/ivib/makefile
		echo "COPY=cp" >> ../../../uni/ivib/makefile
		echo "BINDIR=../../bin" >> ../../../uni/ivib/makefile
		cat ../Config/ivib.mak >> ../../../uni/ivib/makefile

Localcode:
		cp define.h ../../../src/h
		cp rswitch.[csS] ../../../src/common
		-if grep -s NoRanlib define.h; \
		   then touch ../../../NoRanlib; \
		   else rm -rf ../../../NoRanlib; fi
