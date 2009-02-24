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
		cat ../Config/xpm.mak \
		   > ../../../src/xpm/lib/Makefile
		echo "XPM=xpm" > ../../../src/iconc/Makefile
		cat iconc.hdr ../Config/iconc.mak \
		   >> ../../../src/iconc/Makefile

Clean:
		rm -f ../../../src/common/rswitch.[csS]

Makefiles:
		-if [ -f ../$(name)/top.hdr ]; \
		    then echo "found top.hdr" && cat ../$(name)/top.hdr ../Config/top.mak > ../../../Makefile; \
		    else echo "no top.hdr " && cp ../Config/top.mak ../../../Makefile; fi
		cat ../Config/rtt.mak \
		   > ../../../src/rtt/Makefile
		cat ../Config/common.mak \
		   > ../../../src/common/Makefile
		cat ../Config/iconc.mak \
		   > ../../../src/iconc/Makefile
		cat ../Config/preproc.mak \
		   > ../../../src/preproc/Makefile
		cat ../Config/icont.mak \
		   > ../../../src/icont/Makefile
		cat ../Config/runtime.mak \
		   > ../../../src/runtime/Makefile
		cat ../Config/xpm.mak \
		   > ../../../src/xpm/lib/Makefile
		-mkdir -p ../../../ipl/lib
		cp unicon.mak ../../../uni/unicon/makefile
		cp ipllib.mak ../../../ipl/lib/makefile
		# no longer copy ide.mak; ide/makefile is multiplatform
		# cp ide.mak ../../../uni/ide/makefile
		cp ivib.mak ../../../uni/ivib/makefile
		cp unilib.mak ../../../uni/lib/makefile
		cp xml.mak ../../../uni/xml/makefile
		cp unidep.mak ../../../uni/unidep/makefile
		cp unidoc.mak ../../../uni/unidoc/makefile
		cp parser.mak ../../../uni/parser/makefile
		cp util.mak ../../../uni/util/makefile
		cp gui.mak ../../../uni/gui/makefile
		cp native.mak ../../../uni/native/makefile
		cp guidemos.mak ../../../uni/gui/guidemos/makefile
		cp docs.mak ../../../uni/unidoc/docs/makefile
		cp ivib-v2.mak ../../../uni/gui/ivib/makefile
		cp uni-top.mak ../../../uni/Makefile
		cp iyacc.mak ../../../uni/iyacc/Makefile
		cp uni-makedefs ../../../uni/makedefs

Localcode:
		cp define.h ../../../src/h
		cp rswitch.[csS] ../../../src/common
		-if grep -s NoRanlib define.h; \
		   then touch ../../../NoRanlib; \
		   else rm -rf ../../../NoRanlib; fi
