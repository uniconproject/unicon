mkdir ../../../bin
cp Icon-icont.bat ../../..
cp Unicon-Ivib.bat ../../..
cp gdbm.bat ../../../src/runtime
cp libtp.bat ../../../src/runtime
cp makefile.top ../../../makefile
cp DEFINE.H ../../../src/h
cp PATH.H ../../../src/h
cp RSWITCH.S ../../../src/common
cp NTICONT.LNK ../../../src/icont
cp ICONX.LNK ../../../src/runtime
echo CONSOLE=NTConsole >../../../src/common/makefile
cat makefile.cmn >>../../../src/common/makefile
cp MAKEFILE.RTT ../../../src/rtt/makefile
echo ICONX=nticonx >../../../src/runtime/makefile
cat MAKEFILE.RUN >>../../../src/runtime/makefile
echo ICONT=icont >../../../src/icont/makefile
echo CONSOLE=NTConsole >>../../../src/icont/makefile
cat MAKEFILE.T >>../../../src/icont/makefile
echo ICONT=../../bin/icont >../../../ipl/lib/makefile
cat makefile.ipl >> ../../../ipl/lib/makefile
echo ICONT=../../bin/icont >../../../uni/unicon/makefile
echo CP=cp >>../../../uni/unicon/makefile
echo RM=-rm >> ../../../uni/unicon/makefile
echo EXE=.exe >> ../../../uni/unicon/makefile
echo BINDIR=../../bin >> ../../../uni/unicon/makefile
echo UNICON=../unicon/unicon >> ../../../uni/unicon/makefile
cat makefile.uni >>../../../uni/unicon/makefile
echo RM=-rm > ../../../uni/ivib/makefile
echo EXE=.exe >> ../../../uni/ivib/makefile
echo BINDIR=../../bin >> ../../../uni/ivib/makefile
echo UNICON=../unicon/unicon -G >> ../../../uni/ivib/makefile
echo CP=cp >> ../../../uni/ivib/makefile
echo MAKE=make >> ../../../uni/ivib/makefile
echo IVIB2=ivib2win >> ../../../uni/ivib/makefile
cat makefile.ivb >>../../../uni/ivib/makefile
echo RM=-rm > ../../../uni/lib/makefile
echo EXE=.exe >> ../../../uni/lib/makefile
echo BINDIR=../../bin >> ../../../uni/lib/makefile
echo UNICON=../unicon/unicon >> ../../../uni/lib/makefile
cat ../../unix/Config/unilib.mak >>../../../uni/lib/makefile
rm ../../../src/icont/*.o 2> nul
rm ../../../src/common/*.o 2> nul
rm ../../../src/runtime/*.o 2> nul
cp RTT.LNK ../../../src/rtt
cat MAKEFILE.WCP >../../../src/wincap/makefile
echo # noop > ../../../uni/ide/makefile
