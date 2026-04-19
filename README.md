# Unicon

Unicon is a very high level programming language descended from [Icon](https://www.cs.arizona.edu/icon/): expression-based, **goal-directed** evaluation, rich string and structure handling, and integrated graphics and systems programming features. It is a **general-purpose** language with object-oriented extensions, concurrency, and database and network libraries, used for teaching, research, and applications. It runs on many operating systems (Linux, Windows, macOS, BSD) and on common CPU architectures (e.g. i386, amd64, arm64).

**License:** the project is distributed under the **GNU General Public License**; see the [COPYING](COPYING) file in this repository (Debian packaging references **GPL-2+** in `debian/copyright`).

## Contents

- [Documentation](#documentation)
- [Installation](#installation)
- [Build Instructions](#build-instructions)
- [Contributing](#contributing)
- [Help](#help)

## Documentation

Shipped manuals, technical reports, and other files are indexed under **[`doc/`](doc/)** (the documentation index — use its table of contents for the full list). On [unicon.sourceforge.io](https://unicon.sourceforge.io/), **[Books](https://unicon.sourceforge.io/ubooks.html)** lists editions and free PDFs (including *Programming with Unicon* and related titles), and **[Unicon Programming](https://unicon.sourceforge.io/up/index.html)** is an example-oriented online guide. **[Rosetta Code](https://rosettacode.org/wiki/Category:Unicon)** has Unicon solutions for many programming tasks. More technical reports and resources are linked from the project site.

**GitHub Pages:** [uniconproject.github.io/unicon](https://uniconproject.github.io/unicon/) (this README) · **[`doc/`](doc/)** for the documentation index.

### Editors and IDEs

**Syntax highlighting:** [`config/editor/`](config/editor/) ships highlighting and editor integration files for several environments (GNU Emacs, Sublime Text, Notepad++, and others); see [`config/editor/README`](config/editor/README) for installation notes.

**Visual Studio Code:** the **[`.vscode/`](https://github.com/uniconproject/unicon/tree/master/.vscode)** directory in this repository holds workspace settings (tasks, launch, optional recommendations). Unicon support is available in three extensions: [**Unicon Helper**](https://marketplace.visualstudio.com/items?itemName=jafar.unicon-lsp), [**Unicon Debugger**](https://marketplace.visualstudio.com/items?itemName=jafar.unicon-debugger), and [**Unicon Syntax**](https://marketplace.visualstudio.com/items?itemName=jafar.unicon-syntax) — or search the [Marketplace](https://marketplace.visualstudio.com/search?term=unicon&target=VSCode) for “Unicon”.


## Installation

The latest sources are available from Unicon's git repositories and GitHub.
To get the sources from either repo do:

```
git clone https://github.com/uniconproject/unicon.git

```

On Windows systems it is advised to add the `--config core.autocrlf=input` option to the `git` command.
`git` is available on Linux via the standard package managers, for example on a Debian system:

```
sudo apt install git
```
On macOS git is available with Xcode. On Windows you can install and set up git using the instructions:
[here](https://unicon.org/git.html)

For source tarballs and binary distributions, see the unicon.org
[download page](https://unicon.org/downloads.html).


## Build Instructions

_Prerequisites_
- Gnu/Unix utilities such as shell, make, grep, etc.
- C language compiler that supports C99 such as gcc or clang

The initial configuration is done via a standard GNU autoconf script, run:
```
./configure --help
```
For configuration options help. On Windows:
```
sh configure --help
```

The configuration script allows you to enable or disable features in the Unicon build at compile time.
Some of the features are turned on by default as long as the dependencies are satisfied. Those features
can be turned off by doing `--disable-FEATURE`, for example:
```
./configure --disable-graphics
```
disables all graphics support. On the other hand, some features are disabled by default. Those can
be turned on by doing `--enable-FEATURE`, for example, to enable operator overloading:
```
./configure --enable-ovld
```
One other aspect to consider is that the configure script is opportunistic when it comes to turning on features.
Features that are enabled by default will be disabled automatically if they are missing dependencies. If you want
to change the behavior to make the configure script stop with an error instead of skipping a feature when its
dependencies are missing, just enable that feature explicitly. For example, if you want to enable https/ssl, do:
```
./configure --enable-ssl
```
If openssl development library is not present on the system, the configure script will stop with an error message:
```
configure: error: "ssl requires libssl-dev or equivalent"
```

### Linux
Use the package manager in your Linux distribution to get the build utilities and C compiler.
For example, on a Debian system
```
sudo apt install build-essential
```
Optionally, you can install development library dependencies to enable more Unicon features.
Most of these libraries are listed below for common Linux distributions.

Debian/Ubuntu:
```
apt install libgl1-mesa-dev libssl-dev libx11-dev libjpeg-dev libpng-dev libglu1-mesa-dev
            libxft-dev libopenal-dev libalut-dev libogg-dev libvorbis-dev unixodbc-dev
	    libfreetype6-dev
```
Fedora/Centos (Depending on your Centos version, you may need to replace dnf with yum):
```
dnf install libjpeg-turbo-devel libpng-devel libX11-devel mesa-libGL-devel mesa-libGLU-devel
            freetype-devel openal-devel freealut-devel libogg-devel libvorbis-devel
	    openssl-devel unixODBC-devel libXft-devel
```

Go into the Unicon directory and run:
```
./configure
make -j
```
After that you can add `unicon/bin` to the $PATH environment variable or install Unicon instead:
```
make install
```

### macOS
Install Xcode command line tools (or all of Xcode) from the macOS app store.
After that the build steps are the same as those on Linux. To ensure using clang,
explicitly set the compiler as follows:

```
./configure CC=clang CXX=clang++
```
If you want access to the graphics facilities of Unicon, you also need to download
and install the XQuartz package from https://www.xquartz.org/.

### *BSD
Install build dependencies. Make sure to use GNU `gmake` when building.
```
pkg install -y -f autoconf gmake lang/gcc git
```

Configure, make, and optionally install unicon:
```
./configure
gmake -j
gmake install
```

### Windows
There are two possibilities depending on the choice of the C runtime library.  You can choose
the legacy Microsoft Visual C++ Runtime (MSVCRT), which runs on all versions of Windows, or the
newer Universal C Runtime (UCRT64), which is used by Visual Studio but is only available by default
on Windows 10 and newer. Starting from version 13.3, binary distributions of Unicon for Windows
will be built with UCRT64. See msys2 [environments](https://www.msys2.org/docs/environments/)
for more details about available environments and their C Library options.

#### 1. UCRT64:

- Download and run the installer from https://www.msys2.org/. At the time of writing it is called
  `msys2-x86_64-20230127.exe` but it may be updated from that version.

-  Go through the installation process to get a UCRT64 environment.
-  Using the UCRT64 shell, Install tools required for the build:
```
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain mingw-w64-ucrt-x86_64-diffutils git
```
- Install the optional libraries for a full build (Unicon will build without them but some features
will be absent).
```
pacman -S mingw-w64-ucrt-x86_64-openssl  mingw-w64-ucrt-x86_64-libpng
pacman -S mingw-w64-ucrt-x86_64-libjpeg-turbo mingw-w64-ucrt-x86_64-freetype
```

- Clone the Unicon repository:
```
git clone --config core.autocrlf=input https://github.com/uniconproject/unicon
```
  The option `--config core.autocrlf=input` avoids problems with different conventions
  for the end of line character.

-  Configure Unicon:
```
./configure --build=x86_64-w64-mingw32 CPPFLAGS=-I/ucrt64/include/freetype2
```
The option `x86_64-w64-mingw32` ensures the build is 64-bit. After the script finishes do:
```
make
```
Note that, although the build environment is UCRT64, the resulting Unicon binaries may also be
run from the standard Windows command line `cmd` terminal.

#### 2. MSVCRT (Legacy):

- Download and run [mingw-get-setup.exe](https://sourceforge.net/projects/mingw/files/Installer/)

   Go through the install process and use it to install only msys-base. This will give you an MSYS (not MSYS2)
   environment with all the needed Linux/gnu utils.

- Get MinGW64 compiler suite, [TDM package](https://jmeubank.github.io/tdm-gcc/) is known to work with Unicon.
Most recent package is [9.2.0](https://jmeubank.github.io/tdm-gcc/articles/2020-03/9.2.0-release)

Note that you may be missing the tool "make". TDM MinGW comes with a "make" that is named mingw32-make.exe.
That file can be found under the installation directory of MinGW64 inside the bin directory.
Create a copy of that file and name it "make.exe" before continuing.

- Clone the Unicon repository (same steps as UCRT64 above).

After that you can use the standard Windows command line `cmd` terminal to build Unicon.
```
sh configure
```
or
```
make WUnicon64
```
Which is a shortcut for running:
```
sh configure --build=x86_64-w64-mingw32
```
The option `x86_64-w64-mingw32` ensures the build is 64-bit. After the script finishes do:
```
make
```


## Contributing

See **[CONTRIBUTING.md](CONTRIBUTING.md)** for reporting issues, pull requests, and **developer builds** (compiler sanitizers, GDB, `ASAN_OPTIONS`, etc.).


## Help

- **GitHub:** [Issues](https://github.com/uniconproject/unicon/issues) for bugs and feature requests.
- **Email:** [jeffery@unicon.org](mailto:jeffery@unicon.org) for other questions and comments.
