#  Makefile for Unicon, based on that of Version 9.4 of Icon
#
#  Things have changed since Version 9.3.
#  See doc/install.htm for instructions.


#  configuration parameters
VERSION=v940
name=unspecified
dest=/must/specify/dest/

help:
	@echo UNIX: Run "make Configure name=system" or "make X-Configure name=system"
	@echo "   where system is one of those in config/unix."
	@echo Windows (MSVC): Run "nmake NT-Configure" or "nmake W-Configure".
	@echo Windows (GCC): Run "nmake NT-Configure-GCC" or "nmake W-Configure-GCC".
	@echo "   then add the Unicon bin directory to your path."
	@echo All: after configuration, run "make (or nmake) Unicon".

##################################################################
#
# Default targets.

All:	Icont Ilib Ibin

config/unix/$(name)/status src/h/define.h:
	:
	: To configure Icon, run either
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
# $Id: Makefile,v 1.4 2001-11-28 07:53:26 phliar Exp $


# Configure the code for a specific system.

Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-NoGraphics name=$(name)

X-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)


# Get the status information for a specific system.

Status:
		@cat config/unix/$(name)/status

##################################################################
#
# Compilation and installation.

# The OO translator. Add a line for uni/iyacc if you modify the Unicon grammar

Unicon:		Icont
		cd ipl/lib; $(MAKE)
		cd uni/unicon; $(MAKE) unicon
		cd uni/ivib; PATH=${PATH}:${PWD}/bin $(MAKE) ivib

# The interpreter: icont and iconx.

Icont bin/icont: Common
		cd src/icont;		$(MAKE)
		cd src/runtime;		$(MAKE) interp_all

# The compiler: rtt, the run-time system, and iconc.

Iconc bin/iconc: Common
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


##################################################################
#
# Installation and packaging.


# Installation:  "make Install dest=new-parent-directory"

D=$(dest)
Install:
		test -d $D || mkdir $D
		test -d $D/bin || mkdir $D/bin
		test -d $D/lib || mkdir $D/lib
		test -d $D/doc || mkdir $D/doc
		test -d $D/man || mkdir $D/man
		test -d $D/man/man1 || mkdir $D/man/man1
		-cp README $D
		-cp bin/[a-qs-z]* $D/bin
		-rm -f $D/bin/libXpm*
		-cp ipl/lib/*.* $D/lib
		-cp doc/*.* $D/doc
		-cp man/man1/icont.1 $D/man/man1


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

Test    Test-icont:	; cd tests; $(MAKE) Test; cd ../posix; $(MAKE) Test
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
		cd uni;			$(MAKE) Clean
		cd tests;		$(MAKE) Clean

Pure:
		touch Makedefs
		rm -rf icon.* bin/[a-z]* lib/[a-z]*
		cd ipl;			$(MAKE) Pure
		cd src;			$(MAKE) Pure
		cd tests;		$(MAKE) Pure
		cd config/unix; 	$(MAKE) Pure



#  (This is used at Arizona to prepare source distributions.)

Dist-Clean:
		rm -rf `find * -type d -name CVS`
		rm -f `find * -type f | xargs grep -l '<<ARIZONA-[O]NLY>>'`

##################################################################

NT-Configure:
	cd config\win32\msvc
	config

W-Configure:
	cd config\win32\msvc
	w-config

W-Configure-GCC:
	cd config/win32/gcc && sh w-config.sh
	echo Run "make Unicon" to build

NT-Configure-GCC:
	cd config/win32/gcc && sh config.sh
	echo Run "make Unicon" to build
