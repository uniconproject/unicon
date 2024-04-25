mkdir ../../../bin
cp Icon-icont.sh ../../..
cp Unicon-Ivib.sh ../../..
cp gdbm.sh ../../../src/runtime
cp libtp.sh ../../../src/runtime
cp makefile.top ../../../makefile
cp define.h ../../../src/h
cp path.h ../../../src/h
cp rswitch.s ../../../src/common
cp nticont.lnk ../../../src/icont
cp iconx.lnk ../../../src/runtime
echo CONSOLE=NTConsole >../../../src/common/makefile
cat makefile.cmn >>../../../src/common/makefile
cp makefile.rtt ../../../src/rtt/makefile
echo ICONX=nticonx >../../../src/runtime/makefile
echo CONSOLE=NTConsole >>../../../src/runtime/makefile
cat makefile.run >>../../../src/runtime/makefile
echo ICONT=icont >../../../src/icont/makefile
echo CONSOLE=NTConsole >>../../../src/icont/makefile
cat makefile.t >>../../../src/icont/makefile
echo ICONT=../../bin/icont >../../../ipl/lib/makefile
cat makefile.ipl >> ../../../ipl/lib/makefile
echo ICONT=../../bin/icont >../../../uni/unicon/makefile
echo CP=cp >>../../../uni/unicon/makefile
echo RM=-rm >> ../../../uni/unicon/makefile
echo EXE=.exe >> ../../../uni/unicon/makefile
echo BINDIR=../../bin >> ../../../uni/unicon/makefile
echo UNICON=../unicon/unicon >> ../../../uni/unicon/makefile
cat makefile.uni >> ../../../uni/unicon/makefile
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
cat makefile.wcp >../../../src/wincap/makefile
cp makefile.wgc ../../../src/gdbm
echo # noop > ../../../uni/ide/makefile

