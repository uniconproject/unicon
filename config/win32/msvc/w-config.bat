call config
echo #define MSWindows 1 >> ..\..\..\src\h\define.h
echo #define FAttrib 1 >> ..\..\..\src\h\define.h
echo ICONX=wiconx >..\..\..\src\runtime\makefile
type MAKEFILE.RUN >>..\..\..\src\runtime\makefile
echo ICONT=wicont >..\..\..\src\icont\makefile
echo CONSOLE=NOTHING >>..\..\..\src\icont\makefile
type MAKEFILE.T >>..\..\..\src\icont\makefile
echo CONSOLE=NOTHING >..\..\..\src\common\makefile
echo DCONSOLE=dconsole.obj >>..\..\..\src\common\makefile
type MAKEFILE.CMN >>..\..\..\src\common\makefile
type MAKEFILE.WCP >..\..\..\src\wincap\makefile
echo ICONT=..\..\bin\wicont >..\..\..\uni\unicon\makefile
echo COPY=copy >>..\..\..\uni\unicon\makefile
echo RM=-del >> ..\..\..\uni\unicon\makefile
echo EXE=.exe >> ..\..\..\uni\unicon\makefile
echo BINDIR=..\..\bin >> ..\..\..\uni\unicon\makefile
echo UNICON=..\unicon\unicon >> ..\..\..\uni\unicon\makefile
type ..\..\unix\Config\unicon.mak >>..\..\..\uni\unicon\makefile
type makefile.ide > ..\..\..\uni\ide\makefile
echo ICONT=..\..\bin\wicont -s >..\..\..\ipl\lib\makefile
type makefile.ipl >> ..\..\..\ipl\lib\makefile
