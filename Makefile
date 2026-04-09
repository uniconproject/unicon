#  Top Level Makefile for Unicon
#
# Keep Makefile.in in sync with this file except for the first two assignments (srcdir/TOPDIR).
#
# Out-of-tree builds: run configure from a build directory (e.g. ../configure).
# TOPDIR is the source tree; UNICON_TOP_BUILDDIR is the configure/build directory (Makedefs,
# auto.h, config.status). Object files and binaries still go under TOPDIR in this phase; switch
# to UNICON_TOP_BUILDDIR paths when the build fully migrates out of the source tree.
srcdir = .
TOPDIR = .
export UNICON_TOP_BUILDDIR := $(CURDIR)

default: default_target

include Makedefs

name=unspecified

# Make sure no custom PATHs are set so the build doesn't get affected
# by other installations of unicon on the same system if they do exist
IPATH=
LPATH=

# get the current unicon dir name
unicwd=`basename \`pwd\``


default_target: allsrc
	$(MAKE) -C $(TOPDIR)/ipl/lib
	$(MAKE) -C $(TOPDIR)/uni
	$(MAKE) -C $(TOPDIR)/plugins
	$(MAKE) docrule
	$(MAKE) htmldocrule
	@echo ============ Build Features ============ > unicon-features.log
	# Binaries still under TOPDIR/bin until the tree emits them in UNICON_TOP_BUILDDIR.
	$(TOPDIR)/bin/unicon -features >> unicon-features.log
	@echo ======================================== >> unicon-features.log
	@cat unicon-features.log
	@echo "add $(shell cd $(TOPDIR) && pwd)/bin to your path or do \"make install\" to install Unicon on your system"

.PHONY: plugins update_rev doc config help

# Optional $(wildcard config.status): do not require config.status before it exists
# (e.g. debian/rules clean / dh_auto_clean runs make distclean without configuring).
Makedefs: $(srcdir)/Makedefs.in $(wildcard config.status)
	@if test -f ./config.status; then \
	  $(SHELL) ./config.status Makedefs; \
	fi

update_rev:
	@$(TOPDIR)/config/scripts/version.sh

#
# if you make any changes to configure.ac or aclocal.m4 run  autoreconf -i
#
#configure: configure.ac aclocal.m4
#	autoreconf -i

config: config.status
	$(SHELL) ./config.status --recheck

help:
	@echo
	@echo "Unicon Build Instructions:"
	@echo
	@echo "   Run the following configure and make commands"
	@echo
	@echo "  UNIX/macOS:"
	@echo "        ./configure"
	@echo "        make"
	@echo "  Out-of-tree (build dir next to the source tree):"
	@echo "        mkdir build && cd build && ../configure && make"
	@echo
	@echo "  Windows:"
	@echo "        sh configure --build=x86_64-w64-mingw32"
	@echo "        make"
	@echo

##################################################################
#
# Default targets.

All:	Icont Ilib Ibin

allsrc: Makedefs update_rev
	$(MAKE) -C $(TOPDIR)/src


##################################################################

# needed especially for MacOS
.PHONY: Configure

WUnicon32:
	sh configure --host=i686-w64-mingw32

WUnicon64:
	sh configure --build=x86_64-w64-mingw32

INNOSETUP="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

winbin WinInstaller:

	@echo "#define PkgName \"$(PKG_TARNAME)\"" > $(TOPDIR)/config/win32/gcc/unicon_version.iss
	@echo "#define AppVersion \"$(PKG_VERSION)\"" >> $(TOPDIR)/config/win32/gcc/unicon_version.iss
	@echo "#define AppRevision \""`$(TOPDIR)/config/scripts/version.sh "revision"`"\"" \
		>> $(TOPDIR)/config/win32/gcc/unicon_version.iss
	@echo "#define PATCHSTR \"$(PATCHSTR)\"" >> $(TOPDIR)/config/win32/gcc/unicon_version.iss
	$(INNOSETUP) $(TOPDIR)/config/win32/gcc/unicon.iss


##################################################################
#
# This is used utilize the ncurses-based tool to build Unicon
# make build name=xxxx

build:
	if test "$(TERM)" = "dumb" ; then \
		echo "No building on dumb terminals, use make Configure"; \
	elif [ -f /usr/lib/libcurses.so ] ; then \
		gcc $(TOPDIR)/src/common/build.c -lcurses -o build; \
		./build $(name) ; \
		rm build; \
	elif [ -f /usr/include/curses.h ] ; then \
		gcc $(TOPDIR)/src/common/build.c -lncurses -o build; \
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
		@cat unicon-config.log

##################################################################
#
# Compilation and installation.


# The OO translator. Add a line for uni/iyacc if you modify the Unicon grammar

Unicon:		Icont
		cd $(TOPDIR)/ipl/lib; $(MAKE)
		cd $(TOPDIR)/uni ; $(MAKE)

# The interpreter: icont and iconx.

Icont bin/icont:
		$(MAKE) -C $(TOPDIR)/src Icont

# The compiler: rtt, the run-time system, and iconc.

Iconc Uniconc bin/iconc:
		$(MAKE) -C $(TOPDIR)/src Iconc

# Common components.

Common:
		$(MAKE) -C $(TOPDIR)/src Common

# The Icon program library.

Ilib:		$(TOPDIR)/bin/icont
		$(MAKE) -C $(TOPDIR)/ipl

Ibin:		$(TOPDIR)/bin/icont
		$(MAKE) -C $(TOPDIR)/ipl Ibin

# Common components.

plugins:
		$(MAKE) -C $(TOPDIR)/plugins

# Documentation

docrule: $(UDOC)
doc:
		$(MAKE) -C $(TOPDIR)/doc

# build full html documentation using unidoc
UBASE=$(shell cd $(TOPDIR) && pwd)
SBASE=$(UBASE)/uni
TBASE=$(UBASE)/doc/uni-api
# SRCDIRS is a space-separated list, SDIRS and LDIRS are comma-separated lists
SRCDIRS="$(SBASE)/progs $(SBASE)/gprogs $(SBASE)/lib $(UBASE)/ipl/procs $(UBASE)/progs $(UBASE)/gprogs $(SBASE)/unidoc"
SDIRS="$(SBASE)/progs,$(SBASE)/gprogs,$(SBASE)/lib,$(UBASE)/ipl/procs,$(UBASE)/progs,$(UBASE)/gprogs,$(SBASE)/unidoc"
LDIRS="$(TBASE)/lib"
basetitle="Unicon API "
cdir=$(shell cd $(TOPDIR) && pwd)
TD=$(TBASE)
title=$(basetitle)

htmldocrule: $(HTMLDOC)
htmldoc:
		@echo ""
		@echo " Building class library html documentation"
		@echo ""
#		$(MAKE) -C uni/unidoc htmldoc
		mkdir -p ${TD}
		$(TOPDIR)/bin/unidoc --title=$(title) --linkSrc --sourcePath="$(SDIRS)" --linkPath="$(LDIRS)" --resolve --targetDir=$(TD) "$(SRCDIRS)"

##################################################################
#
# Installation and packaging.


# Installation:  "make Install dest=new-parent-directory"
ULROT=$(libdir)/unicon
RTDIR=$(ULROT)/rt
ULB=$(ULROT)/uni
UIPL=$(ULROT)/ipl
UPLUGINS=$(ULROT)/plugins/lib
INST=$(SHTOOL) install -c
F=*.{u,icn}

# runtime binaries, variants of iconx, icont, and iconc
RTbins=$(UNICONX)$(EXE) $(UNICONWX)$(EXE) $(UNICONT)$(EXE) $(UNICONWT)$(EXE) $(UNICONC)$(EXE)
ADDONbins=udb$(EXE) uprof$(EXE) unidep$(EXE) unidoc$(EXE) ui$(EXE) ivib$(EXE) ulsp$(EXE)
UTILbins=patchstr$(EXE) iyacc$(EXE)
ALLbins=$(RTbins) unicon$(EXE) $(ADDONbins) $(UTILbins) rt.a rt.h
# binaries that should be signed after install, only needed on arm macOS for now
SIGNbins=$(RTbins) $(UTILbins)

Tdirs=$(DESTDIR)$(ULB) $(DESTDIR)$(UIPL) $(DESTDIR)$(UPLUGINS)
Udirs=lib 3d gui unidoc unidep xml parser ulsp
IPLdirs=lib incl gincl mincl procs
RTdirs=lib include include/uri

uninstall Uninstall:
#	be conservative when deleting directories
	@for d in $(DESTDIR)$(ULROT) $(DESTDIR)$(docdir) ; do \
	   echo "Uninstalling dir $$d ..."; \
	   rm -rf $$d; \
	done
#	delete the binaries we installed from  unicon/bin
	@for f in $(ALLbins); do \
	   echo "Uninstalling $(DESTDIR)$(bindir)/$$f ..."; \
	   rm -f $(DESTDIR)$(bindir)/$$f; \
	done
#	docs and man
	@echo "Uninstalling $(DESTDIR)$(mandir)/man1/unicon.1 ..."
	@rm -f $(DESTDIR)$(mandir)/man1/unicon.1

install Install:
#	create all directories first
	@for d in $(DESTDIR)$(bindir) $(DESTDIR)$(libdir) $(DESTDIR)$(docdir) $(DESTDIR)$(mandir)/man1 $(Tdirs) ; do \
	    (echo "Creating dir $$d") && (mkdir -p $$d); \
	done
	@for d in $(RTdirs); do \
	    (echo "Creating dir $(DESTDIR)$(RTDIR)/$$d") && (mkdir -p $(DESTDIR)$(RTDIR)/$$d); \
	done
	@for d in $(IPLdirs); do \
	    (echo "Creating dir $(DESTDIR)$(UIPL)/$$d") && (mkdir -p $(DESTDIR)$(UIPL)/$$d); \
	done
	@for d in $(Udirs); do \
	    (echo "Creating dir $(DESTDIR)$(ULB)/$$d") && (mkdir -p $(DESTDIR)$(ULB)/$$d); \
	done
#	install unicon/bin
	@for f in $(ALLbins); do \
	  if test -f "$(TOPDIR)/bin/$$f"; then \
	    (echo "Installing bin/$$f") && ($(INST) $(TOPDIR)/bin/$$f $(DESTDIR)$(bindir)); \
	    if test "$$f" = $(UNICONT)$(EXE) ; then \
              $(PATCHSTR) -DPatchStringHere $(DESTDIR)$(bindir)/$$f $(bindir)/$(UNICONX) || true; \
              $(PATCHSTR) -DPatchUnirotHere $(DESTDIR)$(bindir)/$$f $(ULROT) || true;  \
	    elif test "$$f" = $(UNICONWT)$(EXE) ; then \
              $(PATCHSTR) -DPatchStringHere $(DESTDIR)$(bindir)/$$f $(bindir)/$(UNICONWX) || true; \
              $(PATCHSTR) -DPatchUnirotHere $(DESTDIR)$(bindir)/$$f $(ULROT) || true;  \
	    elif test "$$f" != $(PATCHSTRX) ; then \
              $(PATCHSTR) -DPatchStringHere $(DESTDIR)$(bindir)/$$f $(bindir) || true; \
              $(PATCHSTR) -DPatchUnirotHere $(DESTDIR)$(bindir)/$$f $(ULROT) || true;  \
            fi; \
	  fi; \
	done
#	install unicon/rt
	@echo "Installing unicon/rt to $(DESTDIR)$(RTDIR) ..."
	@$(INST) -m 644 $(TOPDIR)/rt/lib/* $(DESTDIR)$(RTDIR)/lib
	@$(INST) -m 644 $(TOPDIR)/rt/include/*.h $(DESTDIR)$(RTDIR)/include
	@$(INST) -m 644 $(TOPDIR)/rt/include/uri/*.h $(DESTDIR)$(RTDIR)/include/uri
#	install unicon/ipl
	@echo "Installing unicon/ipl to $(DESTDIR)$(UIPL) ..."
	@$(INST) -m 644 $(TOPDIR)/ipl/lib/*.u $(DESTDIR)$(UIPL)/lib
	@$(INST) -m 644 $(TOPDIR)/ipl/incl/*.icn $(DESTDIR)$(UIPL)/incl
	@$(INST) -m 644 $(TOPDIR)/ipl/gincl/*.icn $(DESTDIR)$(UIPL)/gincl
	@$(INST) -m 644 $(TOPDIR)/ipl/mincl/*.icn $(DESTDIR)$(UIPL)/mincl
	@$(INST) -m 644 $(TOPDIR)/ipl/procs/*.icn $(DESTDIR)$(UIPL)/procs
#	install unicon/uni
	@for d in $(Udirs); do \
	  echo "Installing uni/$$d to $(DESTDIR)$(ULB)/$$d ..."; \
	  $(INST) -m 644 $(TOPDIR)/uni/$$d/*.* $(DESTDIR)$(ULB)/$$d; \
	done
#       plugins
	@$(INST) -m 644 $(TOPDIR)/plugins/lib/*.* $(DESTDIR)$(UPLUGINS)/ || true
#	docs and man
	@echo "Installing $(DESTDIR)$(mandir)/man1/unicon.1 ..."
	@$(INST) -m 644 $(TOPDIR)/doc/unicon/unicon.1 $(DESTDIR)$(mandir)/man1/
	@$(INST) -m 644 $(TOPDIR)/README.md $(DESTDIR)$(docdir)
	@echo "Installing $(DESTDIR)$(docdir) ..."
	@$(INST) -m 644 $(TOPDIR)/doc/unicon/*.* $(DESTDIR)$(docdir)
#   Sign code if we are running MacOS on Apple's processors
	if test "$(UNICONHOST)" = "arm_64_macos"; then \
		for f in $(SIGNbins); do \
			echo signing  $(DESTDIR)$(bindir)/$$f ; \
			codesign -s - $(DESTDIR)$(bindir)/$$f ;\
		done; \
	fi

# Bundle up for binary distribution.
PKGDIR=$(PKG_TARNAME).$(PKG_VERSION)
Package:
		rm -rf $(PKGDIR)
		umask 002; $(MAKE) Install dest=$(PKGDIR)
		tar cf - $(PKG_TARNAME).$(PKG_VERSION) | gzip -9 >$(PKG_TARNAME).$(PKG_VERSION).tgz
		rm -rf $(PKGDIR)

distclean2: clean
	@for d in $(SUBDIRS); do \
	  if test "$$d" != "."; then \
	    (cd $$d && $(MAKE) $@); \
	  fi; \
	done
	$(RM) Makefile config.status config.cache config.log

#Makefile: Makefile.in config.status
#	cd $(top_srcdir) && $(SHELL) ./config.status

#config.status: $(srcdir)/configure
#	$(SHELL) ./config.status --recheck


#MV=.0
VSUFFIX?=~prerelease
VV=$(PKG_VERSION)$(MV)
PKG_STRNAME=$(PKG_TARNAME)_$(VV)$(VSUFFIX)
UTAR=$(PKG_STRNAME).tar.gz
UTARORIG=$(PKG_STRNAME).orig.tar.gz

dist: distclean update_rev
	echo "Building $(UTAR)"
	tar -czf ../$(UTAR) --exclude-vcs --exclude-backups ../$(unicwd)

publishdist: dist
	scp ../$(UTAR) web.sf.net:/home/project-web/unicon/htdocs/download/

# Deb Section
udist=unicondist
SIGNKEYID=AB194DBF
SIGNOPT=-k$(SIGNKEYID)

deb: dist
	mkdir -p ../$(udist)
	mv ../$(UTAR) ../$(udist)/
	cp ../$(udist)/$(UTAR) ../$(udist)/$(UTARORIG)
	@echo unpacking ../$(udist)/$(UTAR)
	cd ../$(udist) && tar -xf $(UTAR)
	mv ../$(udist)/unicon ../$(udist)/$(PKG_STRNAME)
	@echo "To finish building the deb package, do"
	@echo "   cd ../$(udist)/$(PKG_STRNAME)"
	@echo "Then run:"
	@echo "	 debuild -us -uc"

debin: deb
	cd ../$(udist)/$(PKG_STRNAME) && debuild -us -uc $(SIGNOPT) --lintian-opts --profile debian
	ls -lh ../$(udist)/unicon_*.deb

debsrc: deb
	cd ../$(udist)/$(PKG_STRNAME) && debuild -S $(SIGNOPT) --lintian-opts --profile debian
	ls -lh ../$(udist)/$(PKG_TARNAME)_*.dsc

debsign:
	cd ../$(udist) && debsign $(PKG_STRNAME)*.changes  $(SIGNOPT)

launchpad:
	cd ../$(udist) && dput unicon-ppa $(PKG_STRNAME)*_source.changes


# RPM section
rpmdir=rpmbuild

rpm: dist
	mkdir -p ../$(rpmdir)/SOURCES
	mkdir -p ../$(rpmdir)/SPECS
	cp rpm/unicon.spec ../$(rpmdir)/SPECS
	mv ../$(UTAR) ../$(rpmdir)/SOURCES
	@echo "To finish building the rpm package, do"
	@echo "   cd ../$(rpmdir)/SPECS"
	@echo "Then run:"
	@echo "	 rpmbuild -ba unicon.spec"

rpmbin: rpm
	cd ../$(rpmdir)/SPECS &&  rpmbuild -ba unicon.spec
	@ls ../$(rpmdir)/RPMS/
	ls -lh ../$(rpmdir)/RPMS/$(PKG_STRNAME)-*.*.rpm

rpmresume: rpm
	cd ../$(rpmdir) &&  rpmbuild -bi --short-circuit unicon.spec
	@ls ../$(rpmdir)/RPMS/
	ls -lh ../$(rpmdir)/RPMS/$(PKG_STRNAME)-$(VV)-*.*.rpm

rpmsrc:
	cd ../$(rpmdir) &&  rpmbuild -bs unicon.spec
	@ls ../$(rpmdir)/SRPMS/
	ls -lh ../$(rpmdir)/RPMS/$(PKG_STRNAME)-*.*.rpm


##################################################################
#
# Tests.

Test    Test-icont:	; cd $(TOPDIR)/tests; $(MAKE) Test
Samples Samples-icont:	; cd $(TOPDIR)/tests; $(MAKE) Samples

Test-iconc:		; cd $(TOPDIR)/tests; $(MAKE) Test-iconc
Samples-iconc:		; cd $(TOPDIR)/tests; $(MAKE) Samples-iconc


#################################################################
#
# Run benchmarks.

Benchmark:
		$(MAKE) Benchmark-icont

Benchmark-iconc:
		cd $(TOPDIR)/tests/bench;		$(MAKE) benchmark-iconc

Benchmark-icont:
		cd $(TOPDIR)/tests/bench;		$(MAKE) benchmark-icont


##################################################################
#
# Clean-up.
#
# Out-of-tree: clean/distclean/Pure still recurse into $(TOPDIR) because artifacts currently
# live in the source tree, so "make clean" from a build directory cleans under the source tree.
# Revisit when objects and binaries are only written under UNICON_TOP_BUILDDIR.
#
# "make Clean" removes intermediate files, leaving executables and library.
# "make Pure"  also removes binaries, library, and configured files.

clean Clean:
		touch Makedefs Makedefs.uni
		rm -rf icon.*
		cd $(TOPDIR)/src;			$(MAKE) Clean
		cd $(TOPDIR)/tests;		$(MAKE) Clean
		cd $(TOPDIR)/plugins;		$(MAKE) Clean
		cd $(TOPDIR)/doc;			$(MAKE) Clean

distclean:
		touch Makedefs Makedefs.uni
		rm -rf icon.* $(TOPDIR)/bin/[A-Za-z]* $(TOPDIR)/lib/[a-z]*
		cd $(TOPDIR)/uni;			$(MAKE) Pure
		cd $(TOPDIR)/ipl;			$(MAKE) Pure
		cd $(TOPDIR)/src;			$(MAKE) Pure
		cd $(TOPDIR)/tests;		$(MAKE) distclean
		cd $(TOPDIR)/plugins;		$(MAKE) Pure
		cd $(TOPDIR)/doc;			$(MAKE) Clean
		rm -f $(TOPDIR)/src/common/rswitch.[csS]
		$(RM) config.status config.cache
		$(RM) config.log unicon-config.log


Pure:
		touch Makedefs Makedefs.uni
		rm -rf icon.* $(TOPDIR)/bin/[A-Za-z]* $(TOPDIR)/lib/[a-z]*
		cd $(TOPDIR)/uni;			$(MAKE) Pure
		cd $(TOPDIR)/ipl;			$(MAKE) Pure
		cd $(TOPDIR)/src;			$(MAKE) Pure
		cd $(TOPDIR)/tests;		$(MAKE) Pure
		cd $(TOPDIR)/plugins;		$(MAKE) Pure
		cd $(TOPDIR)/doc;			$(MAKE) Clean
		rm -f $(TOPDIR)/src/common/rswitch.[csS]
#		rm -f Makedefs Makedefs.uni
		$(RM) config.status config.cache config.log
		$(RM) config.log unicon-config.log

#		rm -f \#*# *~ .#*
#		rm -f */#*# */*~ */.#*
#		rm -f */*/#*# */*/*~ */*/.#*
#		rm -f */*/*/#*# */*/*/*~ */*/*/.#*

