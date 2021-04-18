#================================================
# CMAKE BUILD
# WINDOW BUILD CURRENTLY
#================================================
cmake_minimum_required(VERSION 3.20) # FetchContent is available in 3.11+

project(sdl2app VERSION 0.0.1)
message("START OF CMAKELIST...")

# https://bewagner.net/programming/2020/05/02/cmake-fetchcontent/
#set(FETCHCONTENT_FULLY_DISCONNECTED ON) # When this option is enabled, no attempt is made to download or update any content.
#set(FETCHCONTENT_UPDATES_DISCONNECTED ON)# 

set(SDL_VERSION release-2.0.14) # SDL GIT RELEASE TAG
#================================================
# ENTERY POINTS
#================================================
# entry point file.cpp
set(ENTRYPOINT src/vulkan_imgui.cpp)

message("ENTRYPOINT: ${ENTRYPOINT}") # console log
# config IDE ext 
#include(CTest)
#enable_testing()

#================================================
# CONFIGS
#================================================
#set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

# must set output build dir by default is none
# user must config manual
message("CMAKE_ARCHIVE_OUTPUT_DIRECTORY: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}") # workspace/build/Debug
message("CMAKE_LIBRARY_OUTPUT_DIRECTORY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
message("CMAKE_RUNTIME_OUTPUT_DIRECTORY: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

message("CMAKE_SYSTEM_NAME == " ${CMAKE_SYSTEM_NAME})

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
  #target_compile_options(myApp PRIVATE /W4)
  #message("WINDOW")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  #target_compile_options(myApp PRIVATE -Wall -Wextra -Wpedantic)
  #message("Linux")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  # other macOS-specific flags for Clang
  #message("Darwin")
endif()

#build compiler tool
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# to deal with error log that rechecks paths
set(ENABLE_SDL ON)
set(ENABLE_IMGUI ON)
set(ENABLE_VALKUN ON)

#include folder, source file, headers and paths
set(CPP_INCLUDE_DIRS "")
set(CPP_HEADER_FILES "")
set(CPP_SOURCE_FILES "")
set(CPP_LIBS "")
#================================================
# SDL2
#================================================
message("[[[=== CHECKING SDL DIR === ]]]")
if (ENABLE_SDL)
  # base on environment system path variable set.
  find_package(sdl QUIET) # Requires at least version 2.5.0
  message("sdl_FOUND:" ${SDL_FOUND})
  if (NOT sdl_FOUND) # If there's none, fetch and build sdl
    include(FetchContent)
    FetchContent_Declare(
      sdl
      GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
      GIT_TAG ${SDL_VERSION}
    )
    FetchContent_GetProperties(sdl)
    if (NOT SDL2_POPULATED) # Have we downloaded raylib yet?
      set(FETCHCONTENT_QUIET NO)
      FetchContent_Populate(sdl)
      #message("SDL_LIBRARY: " ${sdl_LIBRARY}) # fail but define in cmake
      #message("SDL_INCLUDE_DIR: " ${sdl_INCLUDE_DIR}) #pass
      #message("sdl_SOURCE_DIR: " ${sdl_SOURCE_DIR}) # pass
      #message("sdl_BINARY_DIR: " ${sdl_BINARY_DIR}) # pass
      # build SDL2
      list(APPEND CPP_INCLUDE_DIRS ${sdl_SOURCE_DIR}/include)
      add_subdirectory(${sdl_SOURCE_DIR} ${sdl_BINARY_DIR})

      list(APPEND CPP_LIBS "SDL2main") # lib
      list(APPEND CPP_LIBS "SDL2-static") # lib
      
    endif()
  endif()
endif()
#================================================
# IMGUI
#================================================
message("[[[=== CHECKING IMGUI DIR === ]]]")
if (ENABLE_IMGUI)
  #find_package(imgui QUIET) # Requires at least version 2.5.0
  if (NOT imgui_FOUND) # If there's none, fetch and build imgui
    include(FetchContent)
    FetchContent_Declare(
      imgui
      GIT_REPOSITORY https://github.com/ocornut/imgui.git
      GIT_TAG v1.82
    )
    FetchContent_GetProperties(imgui)
    if (NOT imgui_POPULATED) # Have we downloaded imgui yet?
      set(FETCHCONTENT_QUIET NO)
      FetchContent_Populate(imgui)
      message("imgui_SOURCE_DIR: " ${imgui_SOURCE_DIR})
      list(APPEND CPP_INCLUDE_DIRS ${imgui_SOURCE_DIR})
      list(APPEND CPP_INCLUDE_DIRS ${imgui_SOURCE_DIR}/backends)

      #list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imconfig.h) # default nothing config
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui.cpp)
      list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imgui.h)
      #list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imgui_internal.h)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_demo.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_draw.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_tables.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_widgets.cpp)
      #list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imstb_rectpack.h)
      #list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imstb_textedit.h)
      #list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imstb_truetype.h)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_sdl.cpp)
      list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_sdl.h)

      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_vulkan.cpp)
      list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_vulkan.h)

    endif()
  endif()
endif()
#================================================
# VALKUN
#================================================
if(ENABLE_VALKUN)
  find_package(Vulkan)

  if(NOT Vulkan_FOUND)
    message("NOT FOUND! INSTALL VULKAN SDK!")
    return()
  endif()

  if(Vulkan_FOUND)
    set(VULKAN_PATH ${Vulkan_INCLUDE_DIRS})
    STRING(REGEX REPLACE "/Include" "" VULKAN_PATH ${VULKAN_PATH})
  endif()

  # vulkan-1 library for build Vulkan application.
  list(APPEND CPP_LIBS "vulkan-1")

  if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    message("VULKAN_PATH " ${VULKAN_PATH})
    # Include Vulkan header files from Vulkan SDK
    #include_directories(${VULKAN_PATH}/Include)
    list(APPEND CPP_INCLUDE_DIRS ${VULKAN_PATH}/Include)
    # Link directory for vulkan-1
    link_directories(${VULKAN_PATH}/Bin;${VULKAN_PATH}/Lib;)
  endif()
endif()

#================================================
# INCLUDE DIR FOLDERS
#================================================
include_directories(${CPP_INCLUDE_DIRS})
#================================================
# EXECUTE APP
#================================================
#add_executable(${PROJECT_NAME} ${ENTRYPOINT})
add_executable(${PROJECT_NAME} 
  ${ENTRYPOINT} 
  ${CPP_SOURCE_FILES}
  ${CPP_HEADER_FILES}
)
#================================================
# INCLUDE DIRS
#================================================
target_include_directories(${PROJECT_NAME} 
  PRIVATE 
  ${CPP_HEADER_FILES}
)
#================================================
# LIBRARIES
#================================================
#target_link_libraries(${PROJECT_NAME} SDL2main SDL2-static)
target_link_libraries(${PROJECT_NAME} 
  PRIVATE 
  ${CPP_LIBS}

)
#================================================
# COMPILER
#================================================
#target_compile_options(${PROJECT_NAME} 
  #PRIVATE 
  #-Wall

#)
#set(CPACK_PROJECT_NAME ${PROJECT_NAME})
#set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
#include(CPack)
message("END OF CMAKELIST...")