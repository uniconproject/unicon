#  Top Level Makefile for Unicon
#

TOPDIR=.

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
	$(MAKE) -C ipl/lib
	$(MAKE) -C uni
	$(MAKE) -C plugins
	@echo ========== Build Summary ==========
	bin/unicon -features
	@echo ===================================
	@echo "add $(unicwd)/bin to your path or do \"make install\" to install Unicon on your system"


.PHONY: plugins

Makedefs: Makedefs.in configure
	sh configure

#
# if you make any changes to configure.ac or aclocal.m4 run  autoreconf -i
#
#configure: configure.ac aclocal.m4
#	autoreconf -i

config: configure
	sh configure

help:
	@echo
	@echo Unicon Build Instructions:
	@echo
	@echo Platform
	@echo "  UNIX:"
	@echo "      Run \"./configure\""
	@echo
	@echo "  Windows:"
	@echo "      MSVC: Run \"nmake NT-Configure\" or \"nmake W-Configure\"."
	@echo "      GCC : Run \"make NT-Configure-GCC\" or \"make W-Configure-GCC\"."
	@echo "            For a fully-automated build Run \"make WUnicon\" ."
	@echo "            Autoconf:"
	@echo "            sh configure --build=i686-w64-mingw32 when building 32-bit"
	@echo "            sh configure --build=x86_64-w64-mingw32 when building 64-bit"
	@echo ""
	@echo "All: after configuration, run \"make (or nmake) Unicon\"."
	@echo

##################################################################
#
# Default targets.

All:	Icont Ilib Ibin

allsrc: Makedefs update_rev
	$(MAKE) -C src


##################################################################

# needed especially for MacOS
.PHONY: Configure

# Configure the code for a specific system.


V-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		-cd src/lib/voice; $(MAKE)
		cd config/unix; $(MAKE) Setup-NoGraphics name=$(name)
		sh ./configure --disable-graphics CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS)

VX-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		-cd src/lib/voice; $(MAKE)
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)
		sh ./configure CFLAGS=$(CFLAGS) LDFLAGS=$(LDFLAGS)
		@echo Remember to add unicon/bin to your path

WUnicon32:
	sh configure --host=i686-w64-mingw32 --disable-iconc

WUnicon64:
	sh configure --build=x86_64-w64-mingw32 --disable-iconc

INNOSETUP="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
WinInstaller:
	@echo "#define PkgName \"$(PKG_TARNAME)\"" > config/win32/gcc/unicon_version.iss
	@echo "#define AppVersion \"$(PKG_VERSION)\"" >> config/win32/gcc/unicon_version.iss
	@echo "#define AppRevision \"$(REPO_REV)\"" >> config/win32/gcc/unicon_version.iss
	@echo "#define PATCHSTR \"$(PATCHSTR)\"" >> config/win32/gcc/unicon_version.iss
	$(INNOSETUP) config/win32/gcc/unicon.iss

NT-Configure:
		cmd /C "cd config\win32\msvc && config"
		@echo Now remember to add unicon/bin to your path

W-Configure:
		cmd /C "cd config\win32\msvc && w-config"
		@echo Now remember to add unicon/bin to your path

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

# The interpreter: icont and iconx.

Icont bin/icont:
		$(MAKE) -C src Icont

# The compiler: rtt, the run-time system, and iconc.

Iconc Uniconc bin/iconc:
		$(MAKE) -C src Iconc

# Common components.

Common:
		$(MAKE) -C src Common

# The Icon program library.

Ilib:		bin/icont
		$(MAKE) -C ipl

Ibin:		bin/icont
		$(MAKE) -C ipl Ibin

# Common components.

plugins:
		$(MAKE) -C plugins

##################################################################
#
# Installation and packaging.


# Installation:  "make Install dest=new-parent-directory"
ULROT=$(libdir)/unicon
ULB=$(ULROT)/uni
UIPL=$(ULROT)/ipl
UPLUGINS=$(ULROT)/plugins/lib
INST=$(SHTOOL) install -c
F=*.{u,icn}
Tbins=unicon icont iconx iconc udb uprof unidep UniDoc ui ivib patchstr iyacc

Tdirs=$(DESTDIR)$(ULB) $(DESTDIR)$(UIPL) $(DESTDIR)$(UPLUGINS)
Udirs=lib 3d gui unidoc unidep xml parser
IPLdirs=lib incl gincl mincl

uninstall Uninstall:
#	be conservative when deleting directories
	@for d in $(DESTDIR)$(ULROT) $(DESTDIR)$(docdir)/unicon ; do \
	   echo "Uninstalling dir $$d ..."; \
	   rm -rf $$d; \
	done
#	delete the binaries we installed from  unicon/bin
	@for f in $(Tbins); do \
	   echo "Uninstalling $(DESTDIR)$(bindir)/$$f ..."; \
	   rm -f $(DESTDIR)$(bindir)/$$f; \
	done
#	docs and man
	@echo "Uninstalling $(DESTDIR)$(mandir)/man1/unicon.1 ..."
	@rm -f $(DESTDIR)$(mandir)/man1/unicon.1

install Install:
#	create all directories first
	@for d in $(DESTDIR)$(bindir) $(DESTDIR)$(libdir) $(DESTDIR)$(docdir)/unicon $(DESTDIR)$(mandir)/man1 $(Tdirs) ; do \
	    (echo "Creating dir $$d") && (mkdir -p $$d); \
	done
	@for d in $(IPLdirs); do \
	    (echo "Creating dir $(DESTDIR)$(UIPL)/$$d") && (mkdir -p $(DESTDIR)$(UIPL)/$$d); \
	done
	@for d in $(Udirs); do \
	    (echo "Creating dir $(DESTDIR)$(ULB)/$$d") && (mkdir -p $(DESTDIR)$(ULB)/$$d); \
	done
#	install unicon/bin
	@for f in $(Tbins); do \
	  if test -f "bin/$$f"; then \
	    (echo "Installing bin/$$f") && ($(INST) bin/$$f $(DESTDIR)$(bindir)); \
	    if test "$$f" = "icont" ; then \
              $(PATCHSTR) -DPatchStringHere $(DESTDIR)$(bindir)/$$f $(bindir)/iconx || true; \
              $(PATCHSTR) -DPatchUnirotHere $(DESTDIR)$(bindir)/$$f $(ULROT) || true;  \
	    elif test "$$f" = "wicont" ; then \
              $(PATCHSTR) -DPatchStringHere $(DESTDIR)$(bindir)/$$f $(bindir)/wiconx || true; \
              $(PATCHSTR) -DPatchUnirotHere $(DESTDIR)$(bindir)/$$f $(ULROT) || true;  \
	    elif test "$$f" != "patchstr" ; then \
              $(PATCHSTR) -DPatchStringHere $(DESTDIR)$(bindir)/$$f $(bindir) || true; \
              $(PATCHSTR) -DPatchUnirotHere $(DESTDIR)$(bindir)/$$f $(ULROT) || true;  \
            fi; \
	  fi; \
	done
#	install unicon/ipl
	@echo "Installing unicon/ipl to $(DESTDIR)$(UIPL) ..."
	@$(INST) -m 644 ipl/lib/*.u $(DESTDIR)$(UIPL)/lib
	@$(INST) -m 644 ipl/incl/*.icn $(DESTDIR)$(UIPL)/incl
	@$(INST) -m 644 ipl/gincl/*.icn $(DESTDIR)$(UIPL)/gincl
	@$(INST) -m 644 ipl/mincl/*.icn $(DESTDIR)$(UIPL)/mincl
#	install unicon/uni
	@for d in $(Udirs); do \
	  echo "Installing uni/$$d to $(DESTDIR)$(ULB)/$$d ..."; \
	  $(INST) -m 644 uni/$$d/*.* $(DESTDIR)$(ULB)/$$d; \
	done
#       plugins
	@$(INST) -m 644 plugins/lib/*.* $(DESTDIR)$(UPLUGINS)/ || true
#	docs and man
	@echo "Installing $(DESTDIR)$(mandir)/man1/unicon.1 ..."
	@$(INST) -m 644 doc/unicon/unicon.1 $(DESTDIR)$(mandir)/man1/
	@$(INST) -m 644 README.md $(DESTDIR)$(docdir)/unicon
	@echo "Installing $(DESTDIR)$(docdir)/unicon ..."
	@$(INST) -m 644 doc/unicon/*.* $(DESTDIR)$(docdir)/unicon

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
	ls -lh ../$(udist)/unicon_*.*

debsrc: deb
	cd ../$(udist)/$(PKG_STRNAME) && debuild -S $(SIGNOPT) --lintian-opts --profile debian
	ls -lh ../$(udist)/$(PKG_TARNAME)_*.*

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

clean Clean:
		touch Makedefs Makedefs.uni
		rm -rf icon.*
		cd src;			$(MAKE) Clean
		cd tests;		$(MAKE) Clean
		cd plugins;		$(MAKE) Clean

distclean:
		touch Makedefs Makedefs.uni
		rm -rf icon.* bin/[A-Za-z]* lib/[a-z]*
		cd uni;			$(MAKE) Pure
		cd ipl;			$(MAKE) Pure
		cd src;			$(MAKE) Pure
		cd tests;		$(MAKE) distclean
		cd plugins;		$(MAKE) Pure
		rm -f src/common/rswitch.[csS]
		$(RM) config.status config.cache config.log


Pure:
		touch Makedefs Makedefs.uni
		rm -rf icon.* bin/[A-Za-z]* lib/[a-z]*
		cd uni;			$(MAKE) Pure
		cd ipl;			$(MAKE) Pure
		cd src;			$(MAKE) Pure
		cd tests;		$(MAKE) Pure
		cd plugins;		$(MAKE) Pure
		rm -f src/common/rswitch.[csS]
#		rm -f Makedefs Makedefs.uni
		$(RM) config.status config.cache config.log

#		rm -f \#*# *~ .#*
#		rm -f */#*# */*~ */.#*
#		rm -f */*/#*# */*/*~ */*/.#*
#		rm -f */*/*/#*# */*/*/*~ */*/*/.#*

#  (This is used at Arizona to prepare source distributions.)

Dist-Clean:
		rm -rf `find * -type d -name CVS`
		rm -f `find * -type f | xargs grep -l '<<ARIZONA-[O]NLY>>'`
