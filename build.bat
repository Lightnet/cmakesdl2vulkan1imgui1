@echo off
:: Create a build directory
mkdir build 
:: Build from that directory so the build files are in one place
::cmake --build build
cd build
cmake ..
::cmake -DCMAKE_BUILD_TYPE=Release -B build
::cmake --build build --config Debug
::cmake --build . --config Release 
cmake --build . --config Debug 
::-DCMAKE_BUILD_TYPE= Release RelWithDebInfo Debug
:: test config
::cmake -D ISTEST=ON | OFF
::cmake --build build -D ISTEST=ON 
pause