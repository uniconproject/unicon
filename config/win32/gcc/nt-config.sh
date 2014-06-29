echo
echo Configuring for console build...
echo

echo ICONX=nt_iconx >>../../../makedefs
echo CONSOLE=NTConsole >>../../../makedefs
echo BUILDICONT=icont >>../../../makedefs

rm -f ../../../src/runtime/nticonx.exe
rm -f ../../../src/runtime/iconx.exe
rm -f ../../../src/icont/icont.exe
rm -f ../../../bin/nticonx.exe
rm -f ../../../bin/iconx.exe
rm -f ../../../bin/icont.exe
rm -f ../../../src/rtt/rtt.exe
rm -f ../../../bin/rtt.exe
