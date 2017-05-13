#  Top Level Makefile for Unicon
#

#  configuration parameters
VERSION=v940
name=unspecified
dest=/must/specify/dest/

help:
	@echo
	@echo Unicon Build Instructions:
	@echo
	@echo Start by adding the Unicon bin directory to your path.
	@echo
	@echo Platform
	@echo "  UNIX:" 
	@echo "      Run \"make Configure name=system\""
	@echo "       or \"make X-Configure name=system\""
	@echo "       or \"make build name=system\""
	@echo "      where system is one of those in config/unix."
	@echo
	@echo "  Windows:"
	@echo "      MSVC: Run \"nmake NT-Configure\" or \"nmake W-Configure\"."
	@echo "      GCC : Run \"make NT-Configure-GCC\" or \"make W-Configure-GCC\"."
	@echo "            For a fully-automated build Run \"make WUnicon\" ."
	@echo
	@echo "All: after configuration, run \"make (or nmake) Unicon\"."
	@echo

##################################################################
#
# Default targets.

All:	Icont Ilib Ibin

config/unix/$(name)/status src/h/define.h:
	:
	: To configure Unicon, run either
	:
	:	make Configure name=xxxx     [for no graphics]
	: or	make X-Configure name=xxxx   [with X-Windows graphics]
	:
	: where xxxx is one of
	:
	@cd config/unix; ls -d [a-z]*
	:
	@exit 1

##################################################################
#
# Code configuration.
#
# $Id: top.mak,v 1.30 2010-05-06 23:13:56 jeffery Exp $

# needed especially for MacOS
.PHONY: Configure

# Configure the code for a specific system.

Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-NoGraphics name=$(name)
		$(MAKE) cfg
		@echo Remember to add unicon/bin to your path

cfg:
		sh ./configure --without-xlib --without-jpeg --without-png \
		--without-opengl --without-xft --without-FTGL CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS)

x-cfg:
		sh ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS)

Thin-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix;$(MAKE) Setup-NoGraphics Setup-Thin name=$(name)
		@echo 'using ./thin for Thin configuration'
		sh ./thin

X-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)
		$(MAKE) x-cfg
		@if grep -q "HAVE_LIBX11 1" src/h/auto.h; then \
			echo "Think we found X11, you are good to go."; \
		else \
			$(MAKE) Configure name=$(name); \
			echo "X11 libraries or headers missing; graphics" ; \
			echo "not enabled. " ; \
		fi
		@echo Remember to add unicon/bin to your path

Thin-X-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-Graphics Setup-Thin name=$(name)
		@echo 'using ./thin for Thin configuration'
		sh ./thin

V-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		-cd src/lib/voice; $(MAKE)
		cd config/unix; $(MAKE) Setup-NoGraphics name=$(name)
		$(MAKE) cfg

VX-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		-cd src/lib/voice; $(MAKE)
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)
		sh ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS)
		@echo Remember to add unicon/bin to your path

XUnicon:
	Make X-Configure name=x86_64_linux
	Make Unicon

WUnicon:
	@echo Reloading the Makefile from config/win32/gcc/makefile.top
	cp config/win32/gcc/makefile.top Makefile
	@echo Done.
	@echo
	@echo Ready to build Windows Unicon
	@echo Make sure the Unicon bin directory is in your path before continuing, then run:
	@echo
	@echo "   - " \"make WUnicon32\" for a 32-bit build, or
	@echo "   - " \"make WUnicon64\" for a 64-bit build - requires MinGW64.
	@echo

NT-Configure:
		cmd /C "cd config\win32\msvc && config"
		@echo Now remember to add unicon/bin to your path

W-Configure:
		cmd /C "cd config\win32\msvc && w-config"
		@echo Now remember to add unicon/bin to your path

W-Configure-GCC:
		cd config/win32/gcc && sh w-config.sh
		@echo Now remember to add unicon/bin to your path
		@echo Then run "make Unicon" to build

NT-Configure-GCC:
		cd config/win32/gcc && sh config.sh
		@echo Now remember to add unicon/bin to your path
		@echo Then run "make Unicon" to build

Fresh-Makefile:
	@echo
	@echo Reloading the Makefile from makefile.top
	cp makefile.top Makefile
	@echo Done.
	@echo

##################################################################
# 
# This is used utilize the ncurses-based tool to build Unicon
# make build name=xxxx

build:
	if test "$(TERM)" = "dumb" ; then \
		echo "No building on dumb terminals, use make Configure"; \
	elif [ -f /usr/lib/libcurses.so ] ; then \
		gcc src/common/build.c -lcurses -o build; \
		./build $(name) ; \
		rm build; \
	elif [ -f /usr/include/curses.h ] ; then \
		gcc src/common/build.c -lncurses -o build; \
		./build $(name) ; \
		rm build; \
	else \
		make Configure name=$(name); \
		echo "No curses library was found for 'build', used 'make Configure name=$(name)'"; \
		echo "If you want X11 graphics, run 'make X-Configure name=$(name)'"; \
	fi

##################################################################
# Get the status information for a specific system.

Status:
		@cat config/unix/$(name)/status

##################################################################
#
# Compilation and installation.

# The OO translator. Add a line for uni/iyacc if you modify the Unicon grammar

Unicon:		Icont
		cd ipl/lib; $(MAKE)
		cd uni ; $(MAKE)

#		cd uni/unicon; $(MAKE) unicon
#		cd uni/ivib; PATH=${PWD}/bin:${PATH} $(MAKE) ivib
#		cd uni/ide; PATH=${PWD}/bin:${PATH} $(MAKE) ui

# The interpreter: icont and iconx.

Icont bin/icont: Common
		cd src/icont;		$(MAKE)
		cd src/runtime;		$(MAKE) interp_all

# The compiler: rtt, the run-time system, and iconc.

Iconc: Common
		cd src/runtime;		$(MAKE) comp_all
		cd src/iconc;		$(MAKE)

# Common components.

Common:		src/h/define.h
		cd src/common;		$(MAKE)
		cd src/rtt;		$(MAKE)

# The Icon program library.

Ilib:		bin/icont
		cd ipl;			$(MAKE)

Ibin:		bin/icont
		cd ipl;			$(MAKE) Ibin

#
# Uniconc
#
Uniconc bin/iconc: Common
	cd src/runtime; $(RM) *.o; $(MAKE) comp_all_uniconc
	cd src/iconc; $(MAKE)

##################################################################
#
# Installation and packaging.


# Installation:  "make Install dest=new-parent-directory"

D=$(dest)
Install:
		test -d $D || mkdir $D
		test -d $D/bin || mkdir $D/bin
		test -d $D/ipl || mkdir $D/ipl
		test -d $D/ipl/lib || mkdir $D/ipl/lib
		test -d $D/ipl/incl || mkdir $D/ipl/incl
		test -d $D/ipl/gincl || mkdir $D/ipl/gincl
		test -d $D/ipl/mincl || mkdir $D/ipl/mincl
		test -d $D/uni || mkdir $D/uni
		test -d $D/uni/lib || mkdir $D/uni/lib
		test -d $D/doc || mkdir $D/doc
		test -d $D/doc/icon || mkdir $D/doc/icon
		test -d $D/doc/unicon || mkdir $D/doc/unicon
		test -d $D/man || mkdir $D/man
		test -d $D/man/man1 || mkdir $D/man/man1
		cp README $D
		cp bin/[a-qs-z]* $D/bin
		rm -f $D/bin/libXpm*
		cp ipl/lib/*.* $D/ipl/lib
		cp ipl/incl/*.* $D/ipl/incl
		cp ipl/gincl/*.* $D/ipl/gincl
		cp ipl/mincl/*.* $D/ipl/mincl
		cp uni/lib/*.* $D/uni/lib
		cp doc/icon/*.* $D/doc/icon
		cp doc/unicon/*.* $D/doc/unicon
		cp doc/icon/icon.1 $D/man/man1


# Bundle up for binary distribution.

DIR=icon.$(VERSION)
Package:
		rm -rf $(DIR)
		umask 002; $(MAKE) Install dest=$(DIR)
		tar cf - icon.$(VERSION) | gzip -9 >icon.$(VERSION).tgz
		rm -rf $(DIR)


##################################################################
#
# Tests.

Test    Test-icont:	; cd tests; $(MAKE) Test
Samples Samples-icont:	; cd tests; $(MAKE) Samples

Test-iconc:		; cd tests; $(MAKE) Test-iconc
Samples-iconc:		; cd tests; $(MAKE) Samples-iconc


#################################################################
#
# Run benchmarks.

Benchmark:
		$(MAKE) Benchmark-icont

Benchmark-iconc:
		cd tests/bench;		$(MAKE) benchmark-iconc

Benchmark-icont:
		cd tests/bench;		$(MAKE) benchmark-icont


##################################################################
#
# Clean-up.
#
# "make Clean" removes intermediate files, leaving executables and library.
# "make Pure"  also removes binaries, library, and configured files.

Clean:
		touch Makedefs
		rm -rf icon.*
		cd src;			$(MAKE) Clean
		if [ -f uni/Makefile ] ; then \
			cd uni;			$(MAKE) Clean ;\
		fi
		cd tests;		$(MAKE) Clean

Pure:
		touch Makedefs
		rm -rf icon.* bin/[a-z]* lib/[a-z]*
		cd ipl;			$(MAKE) Pure
		cd src;			$(MAKE) Pure
		cd tests;		$(MAKE) Pure
		if [ -f uni/Makefile ] ; then \
			cd uni;			$(MAKE) Clean ;\
		fi
		cd config/unix; 	$(MAKE) Pure

#  (This is used at Arizona to prepare source distributions.)

Dist-Clean:
		rm -rf `find * -type d -name CVS`
		rm -f `find * -type f | xargs grep -l '<<ARIZONA-[O]NLY>>'`
