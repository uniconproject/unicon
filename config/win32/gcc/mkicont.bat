cd src\rtt
rem add -j4 to line below if your version of Windows (7 and newer?) supports it
make
cd ..\runtime
rem don't add -j4 to the make in runtime
make interp_all
cd ..\icont
rem add -j4 to line below if your version of Windows (7 and newer?) supports it
make
