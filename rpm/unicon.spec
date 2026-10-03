# make rpmbin passes --define "ver <version>" and --define "tarball <filename>".
# ver defaults to the same 13.3~prerelease string the Debian changelog and
# Makefile VSUFFIX use. CI appends +git<run>.<sha> so each master build sorts
# newer than the last. The dist tarball name does not include that suffix;
# tarball names the file make dist copied into SOURCES.
%{!?ver: %define ver 13.3~prerelease}
%{!?tarball: %define tarball unicon_%{ver}.tar.gz}
# make rpmbin sets with_graphics to 0 for a --disable-graphics build.
%{!?with_graphics: %define with_graphics 1}
# libcfunc.so is built unless plugins are turned off. Any of these does that:
#   rpmbuild --without plugins
#   make rpmbin with --disable-plugins or --enable-plugins=no
#     (the Makefile passes --without plugins)
%bcond_without plugins
%if %{with_graphics}
Name: unicon
%else
Name: unicon-runtime-nographics
%endif
Version: %{ver}
Release: 1%{?dist}
Summary: The Unicon Programming Language

License: GPLv2+
Source0: %{tarball}

%if %{with_graphics}
BuildRequires: libjpeg-turbo-devel, libpng-devel, libX11-devel
BuildRequires: mesa-libGL-devel, mesa-libGLU-devel
BuildRequires: libXft-devel, freetype-devel
%endif
BuildRequires: openssl-devel, libssh-devel, unixODBC-devel
# OpenAL, freealut, ogg, and vorbis are not in RHEL/Rocky. Runtime dependencies
# for libraries that were actually linked come from the automatic soname
# generator, so a Rocky build does not require OpenAL.
%if 0%{?fedora}
BuildRequires: openal-soft-devel, freealut-devel, libogg-devel, libvorbis-devel
%endif


%if %{with_graphics}
Requires: unicon-runtime
Requires: unicon-lib
Requires: unicon-plugins
Requires: unicon-translator
Requires: unicon-compiler
Requires: unicon-patchstr
Requires: unicon-ipl
Requires: unicon-gui
Requires: unicon-xml
Requires: unicon-uscribe
Requires: unicon-udb
Requires: unicon-ulsp
Requires: unicon-unidoc
Requires: unicon-unidep
Requires: unicon-iyacc
Requires: unicon-uflex
Requires: unicon-ui
Conflicts: unicon-nographics
%else
Provides: unicon-vm
Conflicts: unicon-runtime
Obsoletes: unicon < 13.3~prerelease-1
%endif

%description
%if %{with_graphics}
Metapackage for the full Unicon install: virtual machine, compiler,
libraries, and prebuilt tools.
%else
Unicon virtual machine built without graphics or audio. Installs the same
files as unicon-runtime and conflicts with it.
%endif
 Unicon is a modern dialect of the Icon programming language.

%if %{with_graphics}

%package nographics
Summary: Unicon without graphics
Requires: unicon-runtime-nographics
Requires: unicon-lib
Requires: unicon-plugins
Requires: unicon-translator
Requires: unicon-compiler
Requires: unicon-patchstr
Requires: unicon-ipl
Requires: unicon-xml
Requires: unicon-uscribe
Requires: unicon-udb
Requires: unicon-ulsp
Requires: unicon-unidoc
Requires: unicon-unidep
Requires: unicon-iyacc
Requires: unicon-uflex
Conflicts: unicon

%description nographics
Metapackage for the full no-graphics install: virtual machine, compiler,
libraries, and the tools that do not draw. Does not include the GUI
library or ui/ivib. Conflicts with the unicon metapackage.

%package runtime
Summary: Unicon virtual machine
Requires: openssl, unixODBC
Requires: libjpeg-turbo, libpng, libX11
Requires: mesa-libGL, mesa-libGLU
Requires: libXft, freetype
Provides: unicon-vm
Conflicts: unicon-runtime-nographics
Obsoletes: unicon < 13.3~prerelease-1

%description runtime
The virtual machine, linked with graphics. The executable name comes
from configure. ui, ivib, and the graphics class library need this package.

%package plugins
Summary: Unicon loadable C functions and plugins
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description plugins
libcfunc.so, which loadfunc() searches for, and the loadable plugins.
Not required just to run the virtual machine.

%package lib
Summary: Unicon class library
Obsoletes: unicon < 13.3~prerelease-1

%description lib
The class library under uni/lib. Programs that import it need this
package. Prebuilt tools already have those modules linked in.

%package translator
Summary: Unicon translator
Requires: unicon-lib
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description translator
The unicon front end and the translator. The translator executable
name comes from configure.

%package patchstr
Summary: Unicon binary path patcher
Obsoletes: unicon < 13.3~prerelease-1

%description patchstr
patchstr writes an install prefix into Unicon executables. RPM packages
run it while the package is built, so each package already contains
patched binaries.

%package compiler
Summary: Unicon compiler
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description compiler
The compiler and the rt/ library and headers it uses. The executable
name comes from configure.

%package ipl
Summary: Unicon program library
Obsoletes: unicon < 13.3~prerelease-1

%description ipl
The Icon Program Library shipped with Unicon.

%package gui
Summary: Unicon graphics class library
Requires: unicon-runtime
Obsoletes: unicon < 13.3~prerelease-1

%description gui
uni/gui and uni/3d. Depends on the graphics virtual machine.

%package xml
Summary: Unicon XML library
Obsoletes: unicon < 13.3~prerelease-1

%description xml
The classes under uni/xml.

%package uscribe
Summary: Uscribe literate-programming tool
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description uscribe
uscribe and its theme files. Depends only on a Unicon virtual machine.

%package udb
Summary: Unicon debugger
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description udb
udb and uprof.

%package ulsp
Summary: Unicon language server
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description ulsp
ulsp and the files under uni/ulsp.

%package unidoc
Summary: Unicon documentation generator
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description unidoc
unidoc and the files under uni/unidoc.

%package unidep
Summary: Unicon dependency lister
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description unidep
unidep and the files under uni/unidep.

%package iyacc
Summary: iyacc parser generator
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description iyacc
iyacc, the Unicon parser generator.

%package uflex
Summary: uflex lexical analyzer generator
Requires: (unicon-runtime or unicon-runtime-nographics)
Obsoletes: unicon < 13.3~prerelease-1

%description uflex
uflex, the Unicon lexical analyzer generator.

%package ui
Summary: Unicon ui and ivib
Requires: unicon-runtime
Obsoletes: unicon < 13.3~prerelease-1

%description ui
The ui IDE and the ivib interface builder.

%endif


%global debug_package %{nil}
# Fedora calls %%set_build_flags before %%build (LTO, arch baseline, package-note
# linker specs). autoconf's "can I run a binary?" test then fails. This spec
# runs ./configure itself and wants the compiler's normal defaults.
%undefine _auto_set_build_flags

%prep
%autosetup -n unicon



%build
unset CFLAGS
unset CXXFLAGS
unset LDFLAGS
unset RPM_OPT_FLAGS
# Docdir stays unicon even when this build's Name is the nographics runtime.
# with_plugins is 0 or 1, so a bare %{!?with_plugins} test does not work.
%if %{with plugins}
./configure --prefix=/usr --bindir=%{_bindir} --libdir=%{_libdir} --mandir=%{_mandir} --docdir=%{_docdir}/unicon --enable-uniconx %{?configure_extra}
%else
./configure --prefix=/usr --bindir=%{_bindir} --libdir=%{_libdir} --mandir=%{_mandir} --docdir=%{_docdir}/unicon --enable-uniconx %{?configure_extra} --disable-plugins
%endif
make -j8

%install
rm -rf $RPM_BUILD_ROOT
%make_install
# Executable names are whatever configure wrote into Makedefs.
xname=$(sed -n 's/^UNICONX=//p' Makedefs)
wxname=$(sed -n 's/^UNICONWX=//p' Makedefs)
tname=$(sed -n 's/^UNICONT=//p' Makedefs)
wtname=$(sed -n 's/^UNICONWT=//p' Makedefs)
cname=$(sed -n 's/^UNICONC=//p' Makedefs)
%if ! %{with_graphics}
# This build publishes only the no-graphics virtual machine.
find %{buildroot}%{_bindir} -type f ! -name "$xname" ! -name "$wxname" -delete
rm -rf %{buildroot}%{_docdir} %{buildroot}%{_mandir}
rm -rf %{buildroot}%{_libdir}/unicon
%endif
: > %{_builddir}/unicon/runtime.files
for b in "$xname" "$wxname"; do
  if [ -n "$b" ] && [ -f "%{buildroot}%{_bindir}/$b" ]; then
    echo "%{_bindir}/$b" >> %{_builddir}/unicon/runtime.files
  fi
done
%if %{with_graphics}
: > %{_builddir}/unicon/translator.files
for b in "$tname" "$wtname"; do
  if [ -n "$b" ] && [ -f "%{buildroot}%{_bindir}/$b" ]; then
    echo "%{_bindir}/$b" >> %{_builddir}/unicon/translator.files
  fi
done
: > %{_builddir}/unicon/compiler.files
if [ -n "$cname" ] && [ -f "%{buildroot}%{_bindir}/$cname" ]; then
  echo "%{_bindir}/$cname" >> %{_builddir}/unicon/compiler.files
fi
%endif

%if %{with_graphics}

%files
%{_docdir}/unicon
%license COPYING

%files nographics

%files runtime -f %{_builddir}/unicon/runtime.files

%files plugins
%if %{with plugins}
%{_libdir}/unicon/libcfunc.so
%endif
%{_libdir}/unicon/plugins

%files lib
%{_libdir}/unicon/uni/lib

%files translator -f %{_builddir}/unicon/translator.files
%{_bindir}/unicon
%{_libdir}/unicon/uni/parser
%{_mandir}/man1/unicon.1*

%files patchstr
%{_bindir}/patchstr

%files compiler -f %{_builddir}/unicon/compiler.files
%{_libdir}/unicon/rt

%files ipl
%{_libdir}/unicon/ipl

%files gui
%{_libdir}/unicon/uni/gui
%{_libdir}/unicon/uni/3d

%files xml
%{_libdir}/unicon/uni/xml

%files uscribe
%{_bindir}/uscribe
%{_libdir}/unicon/uni/uscribe

%files udb
%{_bindir}/udb
%{_bindir}/uprof

%files ulsp
%{_bindir}/ulsp
%{_libdir}/unicon/uni/ulsp

%files unidoc
%{_bindir}/unidoc
%{_libdir}/unicon/uni/unidoc

%files unidep
%{_bindir}/unidep
%{_libdir}/unicon/uni/unidep

%files iyacc
%{_bindir}/iyacc

%files uflex
%{_bindir}/uflex

%files ui
%{_bindir}/ui
%{_bindir}/ivib

%else

%files -f %{_builddir}/unicon/runtime.files
%license COPYING

%endif

%changelog
* Fri Mar 29 2019 Jafar Al-Gharaibeh <to.Jafar@gmail.com> 13.1.2-1
- Initial version of the package

