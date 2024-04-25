mkdir ..\..\..\bin
copy makefile.top ..\..\..\makefile
copy DEFINE.H ..\..\..\src\h
copy PATH.H ..\..\..\src\h
copy auto.h ..\..\..\src\h
copy autogdbm.h ..\..\..\src\gdbm\autoconf.h
copy RSWITCH.C ..\..\..\src\common
rem copy RSWITCH.ASM ..\..\..\src\common
copy ICONT.LNK ..\..\..\src\icont
copy ICONX.LNK ..\..\..\src\runtime
echo CONSOLE=NTConsole >..\..\..\src\common\makefile
type MAKEFILE.CMN >>..\..\..\src\common\makefile
copy MAKEFILE.RTT ..\..\..\src\rtt\makefile
echo ICONX=iconx >..\..\..\src\runtime\makefile
type MAKEFILE.RUN >>..\..\..\src\runtime\makefile
echo ICONT=icont >..\..\..\src\icont\makefile
echo CONSOLE=NTConsole >>..\..\..\src\icont\makefile
type MAKEFILE.T >>..\..\..\src\icont\makefile
copy makefile.dbm ..\..\..\src\gdbm\makefile
copy makefile.udb ..\..\..\uni\udb
copy udblib.mak ..\..\..\uni\udb\lib
mkdir ..\..\..\ipl\lib
echo ICONT=..\..\bin\icont >..\..\..\ipl\lib\makefile
type makefile.ipl >> ..\..\..\ipl\lib\makefile
del ..\..\..\src\icont\*.obj
del ..\..\..\src\common\*.obj
del ..\..\..\src\runtime\*.obj
call copymk
