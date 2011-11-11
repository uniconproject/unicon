mkdir -p ../../../bin
cp mkicont.bat ../../..
cp mkunivib.bat ../../..
cp gdbm.bat ../../../src/runtime
cp libtp.bat ../../../src/runtime
cp makefile.top ../../../makefile
cp msdefine.h ../../../src/h/define.h 
cp path.h ../../../src/h
cp auto.h ../../../src/h
cp RSWITCH.S ../../../src/common
cp NTICONT.LNK ../../../src/icont
cp unicon.ico ../../../src/runtime
cp icon.rc ../../../src/runtime
echo # noop > CONSOLE=NTConsole >../../../src/common/makefile
cp makefile.cmn ../../../src/common/makefile
cp MAKEFILE.RTT ../../../src/rtt/makefile
echo # noop > ICONX=nticonx >../../../src/runtime/makefile
echo # noop > CONSOLE=NTConsole >>../../../src/runtime/makefile
cp MSMAKEFILE.RUN ../../../src/runtime/makefile
echo # noop > ICONT=icont >../../../src/icont/makefile
echo # noop > CONSOLE=NTConsole >>../../../src/icont/makefile
cp MSMAKEFILE.T ../../../src/icont/makefile
rm ../../../src/libtp/config.h
cp ../../../src/libtp/config_h.win ../../../src/libtp/config.h
mkdir -p ../../../ipl/lib
cp makefile.cfn ../../../ipl/cfuncs/makefile

cp ../../unix/Config/ipllib.mak ../../../ipl/lib/makefile
echo # noop > cp ../../unix/Config/ide.mak ../../../uni/ide/makefile
cp ../../unix/Config/ivib.mak ../../../uni/ivib/makefile
cp ../../unix/Config/unilib.mak ../../../uni/lib/makefile
echo EXE=.exe > ../../../uni/unicon/makefile
cat ../../unix/Config/unicon.mak >>../../../uni/unicon/makefile
cp ../../unix/Config/xml.mak ../../../uni/xml/makefile
cp ../../unix/Config/unidep.mak ../../../uni/unidep/makefile
cp ../../unix/Config/unidoc.mak ../../../uni/unidoc/makefile
cp ../../unix/Config/parser.mak ../../../uni/parser/makefile
cp ../../unix/Config/util.mak ../../../uni/util/makefile
cp ../../unix/Config/gui.mak ../../../uni/gui/makefile
cp ../../unix/Config/guidemos.mak ../../../uni/gui/guidemos/makefile
cp ../../unix/Config/ivib-v2.mak ../../../uni/gui/ivib/makefile
cp ../../unix/Config/uni-top.mak ../../../uni/Makefile
echo EXE=.exe > ../../../uni/makedefs
cat ../../unix/Config/uni-makedefs >>../../../uni/makedefs
cp iyacc.mak ../../../uni/iyacc/Makefile

rm ../../../src/icont/*.o 2> nul
rm ../../../src/common/*.o 2> nul
rm ../../../src/runtime/*.o 2> nul
echo # noop > ../../../uni/ide/makefile

echo # noop >  merged from w-config
echo # noop > # cat MAKEFILE.RUN >>../../../src/runtime/makefile
echo # noop > ICONT=wicont >../../../src/icont/makefile
echo # noop > CONSOLE=NOTHING >>../../../src/icont/makefile
echo # noop > DCONSOLE=../common/dconsole.o >>../../../src/icont/makefile
echo # noop > # cat MAKEFILE.T >>../../../src/icont/makefile
echo # noop > # cat MAKEFILE.CMN >>../../../src/common/makefile
echo # noop > # echo ICONT=../../bin/icont >../../../uni/unicon/makefile
echo CP=cp >>../../../uni/unicon/makefile
echo RM=-rm >> ../../../uni/unicon/makefile
echo EXE=.exe >> ../../../uni/unicon/makefile
echo BINDIR=../../bin >> ../../../uni/unicon/makefile
echo UNICON=../unicon/unicon >> ../../../uni/unicon/makefile
echo top: unicon wunicon >../../../uni/unicon/makefile
# cat makefile.uni >>../../../uni/unicon/makefile
cat ../../unix/Config/unicon.mak >>../../../uni/unicon/makefile
