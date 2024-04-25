echo
echo "Configuring for windows (non-console) build..."
echo

cp makefile.wop ../../../makefile
echo include ../../makedefs >../../../uni/unicon/makefile
echo top: unicon wunicon >>../../../uni/unicon/makefile
cat ../../unix/Config/unicon.mak >>../../../uni/unicon/makefile

echo ICONX=w_iconx >>../../../makedefs
echo CONSOLE=NOTHING >>../../../makedefs
echo BUILDICONT=wicont >>../../../makedefs
echo DCONSOLE=../common/dconsole.o >>../../../makedefs

rm -f ../../../src/runtime/wiconx.exe
rm -f ../../../src/icont/wicont.exe
rm -f ../../../bin/wiconx.exe
rm -f ../../../bin/wicont.exe