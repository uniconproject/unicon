# SDL graphics

The SDL backend draws Unicon's 2D graphics through SDL3 and FreeType, and 3D
through OpenGL. It is the default on macOS when SDL3 and FreeType are found.
On Linux and Windows the usual graphics backend stays the default, and SDL is
selected explicitly:

```
./configure --enable-sdl-graphics
```

fontconfig is optional. When it is installed, it is used to find fonts.
Libraries outside the compiler's default search path are passed as
`--with-SDL3=DIR` and `--with-freetype=DIR` (the directory that contains
`include` and `lib`).

On Windows the SDL backend does not provide the functions that only the
native backend has, such as `WinButton()` and `WinOpenDialog()`.

## Linux

Install the SDL3 and FreeType development packages, and fontconfig if you
want it. For example:

Debian/Ubuntu:

```
apt install pkg-config libsdl3-dev libfreetype6-dev libfontconfig1-dev
```

Fedora/CentOS (on some CentOS versions, use `yum` instead of `dnf`):

```
dnf install pkgconf-pkg-config SDL3-devel freetype-devel fontconfig-devel
```

Then:

```
./configure --enable-sdl-graphics
```

## macOS

With Homebrew:

```
brew install pkg-config sdl3 freetype
./configure
```

configure then builds the SDL backend. No X server is needed. Without SDL3,
configure falls back to X11, which needs the XQuartz package from
https://www.xquartz.org/. `./configure --disable-sdl-graphics` asks for X11
even when SDL3 is installed.

SDL3 can also come from the official macOS disk image (`SDL3-<version>.dmg`
on the [SDL releases page](https://github.com/libsdl-org/SDL/releases)).
Open the image so it mounts at `/Volumes/SDL3`. The image is an Xcode
xcframework; configure looks for `SDL3/SDL.h` and `-lSDL3`, so install the
macOS framework as a normal library prefix. Copy the files off the image
before linking: the library on the mounted volume is not valid to load, and
its install name is `@rpath/SDL3.framework/Versions/A/SDL3`, which a Unicon
executable will not find.

```
FW="/Volumes/SDL3/SDL3.xcframework/macos-arm64_x86_64/SDL3.framework"
PREFIX="$HOME/opt/sdl3"
mkdir -p "$PREFIX/include/SDL3" "$PREFIX/lib"
cp -R "$FW/Headers/." "$PREFIX/include/SDL3/"
cp "$FW/SDL3" "$PREFIX/lib/libSDL3.dylib"
install_name_tool -id "$PREFIX/lib/libSDL3.dylib" "$PREFIX/lib/libSDL3.dylib"
codesign --force --sign - "$PREFIX/lib/libSDL3.dylib"
hdiutil detach "/Volumes/SDL3"
```

FreeType is not on that image. Build it from the source tarball on the
[FreeType download page](https://freetype.org/download) (the files are also at
`https://download.savannah.gnu.org/releases/freetype/`). `2.15.0` is the
current stable release:

```
FTVER=2.15.0
curl -fsSL -o "freetype-$FTVER.tar.xz" \
  "https://download.savannah.gnu.org/releases/freetype/freetype-$FTVER.tar.xz"
tar -xJf "freetype-$FTVER.tar.xz"
cd "freetype-$FTVER"
./configure --prefix="$HOME/opt/freetype"
make -j
make install
cd ..
```

Point configure at both prefixes:

```
./configure --enable-sdl-graphics \
  --with-SDL3="$HOME/opt/sdl3" --with-freetype="$HOME/opt/freetype"
```

## Windows

Under MSYS2 UCRT64, install SDL3 and FreeType and select the SDL backend.
The programs then need `SDL3.dll`, from the UCRT64 `bin` directory, next to
them or on the `PATH`.

```
pacman -S mingw-w64-ucrt-x86_64-pkgconf mingw-w64-ucrt-x86_64-sdl3 mingw-w64-ucrt-x86_64-freetype
./configure --build=x86_64-w64-mingw32 --enable-sdl-graphics
```
