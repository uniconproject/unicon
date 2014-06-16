# 64-bit config for Windows

echo
echo Running 64-bit build configuration...
echo
cp define64.h ../../../src/h/define.h
cat define.h >> ../../../src/h/define.h
cat makedefs64.top >>../../../makedefs
cat makedefs.top >>../../../makedefs
cp RSWITCH64.S ../../../src/common/rswitch.s
echo
echo Done!
echo