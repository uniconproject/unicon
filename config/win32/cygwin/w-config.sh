sh config.sh
cp wdefine.h ../../../src/h/define.h
echo ICONX=wiconx >../../../src/runtime/makefile
echo CONSOLE=NOTHING >>../../../src/runtime/makefile
cat makefile.run >>../../../src/runtime/makefile
echo ICONT=wicont >../../../src/icont/makefile
echo CONSOLE=NOTHING >>../../../src/icont/makefile
echo DCONSOLE=../common/dconsole.o >>../../../src/icont/makefile
cat makefile.t >>../../../src/icont/makefile
cat makefile.cmn >>../../../src/common/makefile
cat makefile.wcp >../../../src/wincap/makefile
echo ICONT=../../bin/icont >../../../uni/unicon/makefile
echo CP=cp >>../../../uni/unicon/makefile
echo RM=-rm >> ../../../uni/unicon/makefile
echo EXE=.exe >> ../../../uni/unicon/makefile
echo BINDIR=../../bin >> ../../../uni/unicon/makefile
echo UNICON=../unicon/unicon >> ../../../uni/unicon/makefile
echo top: unicon wunicon >> ../../../uni/unicon/makefile
cat ../../unix/Config/unicon.mak >>../../../uni/unicon/makefile
cat makefile.ide > ../../../uni/ide/makefile
