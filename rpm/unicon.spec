Name:    unicon
Version: 13.1.2
Release: 1%{?dist}
Summary: The Unicon Programming Language

License: GPLv2+
Source0: unicon-13.1.2.tar.gz

BuildRequires: libjpeg-devel, libpng-devel, libX11-devel
BuildRequires: mesa-libGL-devel, mesa-libGLU-devel
BuildRequires: openal-devel, freealut-devel, libogg-devel, libvorbis-devel
BuildRequires: openssl-devel, unixODBC-devel
BuildRequires: libXft-devel, freetype-devel


Requires: libjpeg.so, libpng.so, libX11.so, libz.so
Requires: libGL.so, libGLU.so
Requires: libopenal.so, libalut.so, libogg.so, libvorbis.so
Requires: openssl.so, libcrypto.so, libodbc.so
Requires: libXft.so, libfreetype.so


Requires(post): info
Requires(preun): info

%description
Interpreter and tools for Unicon, a high-level programming language
 Unicon is a "modern dialect" descending from the Icon programming language.
 Unicon incorporates numerous new features and extensions to make the Icon
 language more suitable for a broad range of real-world applications.


%global debug_package %{nil}

%prep
%autosetup -n unicon



%build
./configure --prefix=/usr --bindir=%{_bindir} --mandir=%{_mandir} --docdir=%{_docdir}
make -j8

%install
rm -rf $RPM_BUILD_ROOT
%make_install

%{buildroot}/%{_bindir}/patchstr  -DPatchUnirotHere %{buildroot}/%{_bindir}/iconx %{_libdir}/unicon
%{buildroot}/%{_bindir}/patchstr  -DPatchUnirotHere %{buildroot}/%{_bindir}/icont %{_libdir}/unicon
%{buildroot}/%{_bindir}/patchstr  -DPatchUnirotHere %{buildroot}/%{_bindir}/iconc /usr/lib/unicon

#rm -f %{buildroot}/%{_infodir}/dir
