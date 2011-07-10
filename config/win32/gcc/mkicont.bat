cd src\rtt
make -j4
cd ..\runtime
make -j4 interp_all
cd ..\icont
make -j4
