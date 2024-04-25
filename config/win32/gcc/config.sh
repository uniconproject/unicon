# shared configuration between 32 and 64 bit builds
# IMPORTANT : this file assumes that config32.sh or config64.sh will 
#             run afterward to completete the configuration for 32 vs 64.
#             PLEASE do "sh config32.sh" OR "sh config64.sh" after running this script!
mkdir -p ../../../bin
cp mkicont.bat ../../..
cp mkunivib.bat ../../..
cp gdbm.bat ../../../src/runtime
cp libtp.bat ../../../src/runtime
cp makefile.top ../../../makefile
cp path.h ../../../src/h
cp auto.h ../../../src/h
cp NTICONT.LNK ../../../src/icont
# unicon.icon has a control-Z char at pos 29, cp on our sh.exe
# fails to copy beyoned that point leaving the file truncated.
# Do a manual copy if that is the case!
cp unicon.ico ../../../src/runtime
cp icon.rc ../../../src/runtime

cp makefile.cmn ../../../src/common/makefile
cp MAKEFILE.RTT ../../../src/rtt/makefile
cp MAKEFILE.RUN ../../../src/runtime/makefile
cp MAKEFILE.T ../../../src/icont/makefile
cp iconc.mak ../../../src/iconc/makefile

rm ../../../src/libtp/config.h
cp ../../../src/libtp/config_h.win ../../../src/libtp/config.h
mkdir -p ../../../ipl/lib
cp makefile.cfn ../../../ipl/cfuncs/makefile

cp ../../unix/Config/ipllib.mak ../../../ipl/lib/makefile
# cp ../../unix/Config/ide.mak ../../../uni/ide/makefile
cp ../../unix/Config/ivib.mak ../../../uni/ivib/makefile
cp ../../unix/Config/unilib.mak ../../../uni/lib/makefile
echo include ../../makedefs >../../../uni/unicon/makefile
cat ../../unix/Config/unicon.mak >>../../../uni/unicon/makefile
cp ../../unix/Config/xml.mak ../../../uni/xml/makefile
cp ../../unix/Config/unidep.mak ../../../uni/unidep/makefile
cp ../../unix/Config/unidoc.mak ../../../uni/unidoc/makefile
cp ../../unix/Config/parser.mak ../../../uni/parser/makefile
cp ../../unix/Config/util.mak ../../../uni/util/makefile
cp ../../unix/Config/gui.mak ../../../uni/gui/makefile
cp ../../unix/Config/guidemos.mak ../../../uni/gui/guidemos/makefile
cp ../../unix/Config/ivib-v2.mak ../../../uni/gui/ivib/makefile
cp uni-top.mak ../../../uni/Makefile
echo EXE=.exe > ../../../uni/makedefs
cat ../../unix/Config/uni-makedefs >>../../../uni/makedefs
cp iyacc.mak ../../../uni/iyacc/Makefile

#
# Prepare the "seed" of the top level Makedefs file
#rm -f ../../../makedefs
#
cp libconfig.in ../../../makedefs
echo "#" >>../../../makedefs
echo "# makedefs, created by config/win32/gcc/config.sh" >> ../../../makedefs
echo "#" >>../../../makedefs
# This controls which optional libraries should be linked in

#
# Prepare libdefine.h, the "seed" for src/h/define.h
#

echo "/*"  > libdefine.h
echo " * Source file: libdefine.h" >> libdefine.h
echo " * Created by config.sh" >> libdefine.h
echo " * A placeholder for defines of optional Libraries." >> libdefine.h
echo " */" >> libdefine.h
echo " " >> libdefine.h

#
# Put the required defines based on configuration in libconfig.in
#
if [ $(grep -c "WANT_JPG=1" libconfig.in) -ne 0 ]
then
    echo "#define WANT_JPG 1" >> libdefine.h
fi

if [ $(grep -c "WANT_PNG=1" libconfig.in) -ne 0 ]
then
    echo "#define WANT_PNG 1" >> libdefine.h
fi

if [ $(grep -c "WANT_THREADS=1" libconfig.in) -ne 0 ]
then
    echo "#define WANT_THREADS 1" >> libdefine.h
fi

if [ $(grep -c "WANT_SSL=1" libconfig.in) -ne 0 ]
then
    echo "#define WANT_SSL 1" >> libdefine.h
fi

echo " " >> libdefine.h
echo "/*" >> libdefine.h
echo " * End of libdefine.h" >> libdefine.h
echo " */" >> libdefine.h
echo " " >> libdefine.h

cp libdefine.h ../../../src/h/define.h

rm -f ../../../uni/unicon/unicon.exe
rm -f ../../../uni/unicon/wunicon.exe
rm -f ../../../uni/ide/ui.exe
rm -f ../../../uni/gui/ivib/ivib.exe
rm -f ../../../uni/udb/udb.exe
rm -f ../../../src/icont/*.o
rm -f ../../../src/common/*.o
rm -f ../../../src/runtime/*.o
rm -f ../../../src/rtt/*.o
rm -f ../../../src/gdbm/*.o
rm -f ../../../src/gdbm/*.a
rm -f ../../../src/libtp/*.o
rm -f ../../../src/libtp/*.a
rm -f ../../../src/libtp/uri/*.o
echo # noop > ../../../uni/ide/makefile
