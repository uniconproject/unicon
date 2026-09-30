Name:    unicon
# make rpmbin passes --define "ver <version>" and --define "tarball <filename>".
# ver defaults to the same 13.3~prerelease string the Debian changelog and
# Makefile VSUFFIX use. CI appends +git<run>.<sha> so each master build sorts
# newer than the last. The dist tarball name does not include that suffix;
# tarball names the file make dist copied into SOURCES.
%{!?ver: %define ver 13.3~prerelease}
%{!?tarball: %define tarball unicon_%{ver}.tar.gz}
# make rpmbin sets with_graphics to 0 for a --disable-graphics build.
%{!?with_graphics: %define with_graphics 1}
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
Requires: libjpeg-turbo, libpng, libX11
Requires: mesa-libGL, mesa-libGLU
Requires: libXft, freetype
%endif
Requires: openssl, unixODBC


Requires(post): info
Requires(preun): info

%description
Interpreter and tools for Unicon, a high-level programming language
 Unicon is a "modern dialect" descending from the Icon programming language.
 Unicon incorporates numerous new features and extensions to make the Icon
 language more suitable for a broad range of real-world applications.


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
./configure --prefix=/usr --bindir=%{_bindir} --libdir=%{_libdir} --mandir=%{_mandir} --docdir=%{_docdir}/%{name} %{?configure_extra}
make -j8

%install
rm -rf $RPM_BUILD_ROOT
%make_install

#%{buildroot}/%{_bindir}/patchstr  -DPatchUnirotHere %{buildroot}/%{_bindir}/iconx %{_libdir}/unicon
#%{buildroot}/%{_bindir}/patchstr  -DPatchUnirotHere %{buildroot}/%{_bindir}/icont %{_libdir}/unicon
#%{buildroot}/%{_bindir}/patchstr  -DPatchUnirotHere %{buildroot}/%{_bindir}/iconc %{_libdir}/unicon

%post

%preun

%files
%{_bindir}/iconx
%{_bindir}/icont
%{_bindir}/iconc
%{_bindir}/unicon
%{_bindir}/ivib
%{_bindir}/ui
%{_bindir}/unidoc
%{_bindir}/udb
%{_bindir}/unidep
%{_bindir}/uprof
%{_bindir}/uscribe
%{_bindir}/ulsp
%{_bindir}/iyacc
%{_bindir}/patchstr
%{_libdir}/unicon/rt
%{_libdir}/unicon/ipl/lib/*.u
%{_libdir}/unicon/ipl/incl/*.icn
%{_libdir}/unicon/ipl/gincl/*.icn
%{_libdir}/unicon/ipl/mincl/*.icn
%{_libdir}/unicon/ipl/procs
%{_libdir}/unicon/uni/lib/*.*
%{_libdir}/unicon/uni/3d/*.*
%{_libdir}/unicon/uni/gui/*.*
%{_libdir}/unicon/uni/unidoc/*.*
%{_libdir}/unicon/uni/unidep/*.*
%{_libdir}/unicon/uni/parser/*.*
%{_libdir}/unicon/uni/xml/*.*
%{_libdir}/unicon/uni/ulsp
%{_libdir}/unicon/uni/uscribe/*.*
%{_libdir}/unicon/uni/uscribe/themes/*.*
%{_libdir}/unicon/uni/uscribe/themes/_shared/*.*
%{_libdir}/unicon/uni/uscribe/themes/basic/*.*
%{_libdir}/unicon/uni/uscribe/themes/basic/static/*.*
%{_libdir}/unicon/uni/uscribe/themes/classic/*.*
%{_libdir}/unicon/uni/uscribe/themes/classic/static/*.*
%{_libdir}/unicon/uni/uscribe/themes/dark/*.*
%{_libdir}/unicon/uni/uscribe/themes/dark/static/*.*
%{_libdir}/unicon/plugins/lib/*.*
%{_docdir}/unicon/*.*
%{_mandir}/man1/unicon.1.gz

%license COPYING

%changelog
* Fri Mar 29 2019 Jafar Al-Gharaibeh <to.Jafar@gmail.com> 13.1.2-1
- Initial version of the package

