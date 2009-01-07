sh config.sh
cp makefile.wop ../../../makefile
cp wdefine.h ../../../src/h/define.h
echo top: unicon wunicon >../../../uni/unicon/makefile
cat makefile.uni >>../../../uni/unicon/makefile
echo ICONX=wiconx >../../../src/runtime/makefile
echo CONSOLE=NOTHING >>../../../src/runtime/makefile
cat MAKEFILE.RUN >>../../../src/runtime/makefile
echo ICONT=wicont >../../../src/icont/makefile
echo CONSOLE=NOTHING >>../../../src/icont/makefile
echo DCONSOLE=../common/dconsole.o >>../../../src/icont/makefile
cat MAKEFILE.T >>../../../src/icont/makefile
cat MAKEFILE.CMN >>../../../src/common/makefile
echo ICONT=../../bin/icont >../../../uni/unicon/makefile
echo CP=cp >>../../../uni/unicon/makefile
echo RM=-rm >> ../../../uni/unicon/makefile
echo EXE=.exe >> ../../../uni/unicon/makefile
echo BINDIR=../../bin >> ../../../uni/unicon/makefile
echo UNICON=../unicon/unicon >> ../../../uni/unicon/makefile
echo top: unicon wunicon >> ../../../uni/unicon/makefile
cat ../../unix/Config/unicon.mak >>../../../uni/unicon/makefile
# no longer copy makefile.ide up, it has been made multiplatform
# cat makefile.ide > ../../../uni/ide/makefile
