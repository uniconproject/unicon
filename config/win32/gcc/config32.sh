# 32-bit config for windows

echo
echo Running 32-bit build configuration...
echo
cat define32.h >>../../../src/h/define.h
cat define.h >> ../../../src/h/define.h
cat makedefs32.top >>../../../makedefs
cat makedefs.top >>../../../makedefs
cp RSWITCH.S ../../../src/common
echo
echo Done!
echo
