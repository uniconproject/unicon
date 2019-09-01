Unicon 13.x
===========

This is the Unicon distribution.  Please tell us
where it compiles, and when and how it doesn't.

| Recently Supported Platforms  |  Mostly (or Formerly) Supported Platforms  |
|-------------------------------+--------------------------------------------|
| x86_32_linux, x86_64_linux    |  other UNIX                                |
| x86_64_macos                  |  (ppc_macos, x86_32_macos)                 |
| x86_64_freebsd                |                                            |
| arm_32_linux, arm_64_linux    |                                            |
| MS Windows Vista, 7, 8, 10    |  MS Windows XP, (MS Windows95/98/Me/NT/2K) |
|                               |  (VMS)                                     |

Download
--------

The latest sources are available from Unicon's git repository. To get them, do:

```
git clone git://git.code.sf.net/p/unicon/unicon
```
Source disribution is also available for download on unicon.org.

Build Instructions
-----------------

To build Unicon from sources follow the standard autoconf procedure:

```
./configure
make

```
Run configure --help for configuration steps. You can also invoke
make with -jN to run a faster/parallel build using up to N threads.

Total success will place programs named icont, iconx, unicon, ivib and ui
in a subdirectory named unicon/bin/, which you can add to your path or alternatively
you can install Unicon on your system by doing:

```
make install
```

Help
----

Questions and comments to: jeffery@cs.uidaho.edu

The Icon Project at the University of Arizona provides the following
documentation of their public domain code, which we gratefully incorporate
into the Unicon language. By this point, however, our code bases have
diverged substantially.

    doc/docguide.htm  documentation guide
    doc/relnotes.htm  version 9.4 release notes
    doc/files.htm     version 9.4 file organization
    doc/build.htm     build instructions         (for source releases)
    doc/install.htm   installation instructions  (for binary releases)
    doc/faq.htm       frequently asked questions about Icon
