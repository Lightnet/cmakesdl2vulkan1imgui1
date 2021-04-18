# cmakeasdl2vukan1imgui

# license: MIT

# Created by: Lightnet

# Packages:
 * SDL 2.0.14 https://github.com/libsdl-org/SDL
 * IMGUI 1.82 https://github.com/ocornut/imgui
 * Vulkan 1.2.170.0 https://vulkan.lunarg.com/sdk/home

# Information:
  Using the cmake to build the binary application for sdl2 and vulkan to create imgui.

  Simple get sdl 2.0 github src build to run simple window render.

# Notes:
 * simple build.
 * window 10 64 bit vs2019 tested.
 * CMakeLists.txt is not clean up. Work on window 10 64bit.

# set up and build:
  Need to install cmake and compiler on window or other os tools.

  Open current project dir and open terimal to current to CMakelists.txt.
```
mkdir build 
cd build
cmake .. 
cmake --build .
```

```
  cmake .. <- this get the CMakeList.txt from project dir root
  cmake --build . <- project build binary
```

  Enter the commnand line. It should auto build execute application. But if you have firewalll or security it most likely block compile and program.

  By default the execute program is in build/Debug folder.

  If wanted to release

```
cd build
cmake ..
cmake --build . --config Release
```
# Note: 
 * conflict build debug and release error if same build folder.
 * There are differenu build config.