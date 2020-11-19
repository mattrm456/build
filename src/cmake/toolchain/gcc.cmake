
# GDE

include_guard(GLOBAL)

include(CMakeInitializeConfigs)

set(CMAKE_C_COMPILER ${GDE_TOOLCHAIN_COMPILER_CC_PATH} CACHE STRING "Default" FORCE)
set(CMAKE_CXX_COMPILER ${GDE_TOOLCHAIN_COMPILER_CXX_PATH} CACHE STRING "Default" FORCE)

message(STATUS "GDE Build Toolchain: GCC: CMAKE_HOST_SYSTEM_NAME = ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "GDE Build Toolchain: GCC: CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")

message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}")

message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}")
message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_FLAGS_DEBUG = ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_FLAGS_DEBUG_RELEASE = ${CMAKE_CXX_FLAGS_RELEASE}")

message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_FLAGS_INIT = ${CMAKE_CXX_FLAGS_INIT}")
message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_FLAGS_DEBUG_INIT = ${CMAKE_CXX_FLAGS_DEBUG_INIT}")
message(STATUS "GDE Build Toolchain: GCC: CMAKE_CXX_FLAGS_DEBUG_RELEASE_INIT = ${CMAKE_CXX_FLAGS_RELEASE_INIT}")

message(STATUS "GDE Build Toolchain: GCC: DEFAULT_CXX_FLAGS = ${DEFAULT_CXX_FLAGS}")
message(STATUS "GDE Build Toolchain: GCC: DEFAULT_CXX_FLAGS_DEBUG = ${DEFAULT_CXX_FLAGS_DEBUG}")
message(STATUS "GDE Build Toolchain: GCC: DEFAULT_CXX_FLAGS_DEBUG_RELEASE = ${DEFAULT_CXX_FLAGS_RELEASE}")

message(STATUS "GDE Build Toolchain: GCC: DEFAULT_CXX_FLAGS_INIT = ${DEFAULT_CXX_FLAGS_INIT}")
message(STATUS "GDE Build Toolchain: GCC: DEFAULT_CXX_FLAGS_DEBUG_INIT = ${DEFAULT_CXX_FLAGS_DEBUG_INIT}")
message(STATUS "GDE Build Toolchain: GCC: DEFAULT_CXX_FLAGS_DEBUG_RELEASE_INIT = ${DEFAULT_CXX_FLAGS_RELEASE_INIT}")

set(CMAKE_C_FLAGS_INIT                  "" CACHE STRING "Default"        FORCE)
set(CMAKE_C_FLAGS_DEBUG_INIT            "" CACHE STRING "Debug"          FORCE)
set(CMAKE_C_FLAGS_RELEASE_INIT          "" CACHE STRING "Release"        FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL_INIT       "" CACHE STRING "MinSizeRel"     FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT   "" CACHE STRING "RelWithDebInfo" FORCE)

set(CMAKE_CXX_FLAGS_INIT                "" CACHE STRING "Default"        FORCE)
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "" CACHE STRING "Debug"          FORCE)
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "" CACHE STRING "Release"        FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "" CACHE STRING "MinSizeRel"     FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "" CACHE STRING "RelWithDebInfo" FORCE)

set(CMAKE_C_FLAGS                       "" CACHE STRING "Default"        FORCE)
set(CMAKE_C_FLAGS_DEBUG                 "" CACHE STRING "Debug"          FORCE)
set(CMAKE_C_FLAGS_RELEASE               "" CACHE STRING "Release"        FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL            "" CACHE STRING "MinSizeRel"     FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO        "" CACHE STRING "RelWithDebInfo" FORCE)

set(CMAKE_CXX_FLAGS                     "" CACHE STRING "Default"        FORCE)
set(CMAKE_CXX_FLAGS_DEBUG               "" CACHE STRING "Debug"          FORCE)
set(CMAKE_CXX_FLAGS_RELEASE             "" CACHE STRING "Release"        FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL          "" CACHE STRING "MinSizeRel"     FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO      "" CACHE STRING "RelWithDebInfo" FORCE)

# set(CMAKE_C_FLAGS_DEBUG             "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O0 -g2" CACHE STRING "Debug"          FORCE)
# set(CMAKE_C_FLAGS_RELEASE           "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O2 -g0" CACHE STRING "Release"        FORCE)
# set(CMAKE_C_FLAGS_MINSIZEREL        "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O2 -g0" CACHE STRING "MinSizeRel"     FORCE)
# set(CMAKE_C_FLAGS_RELWITHDEBINFO    "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O2 -g0" CACHE STRING "RelWithDebInfo" FORCE)
#
# set(CMAKE_CXX_FLAGS_DEBUG           "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O0 -g2" CACHE STRING "Debug"          FORCE)
# set(CMAKE_CXX_FLAGS_RELEASE         "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O2 -g0" CACHE STRING "Release"        FORCE)
# set(CMAKE_CXX_FLAGS_MINSIZEREL      "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O2 -g0" CACHE STRING "MinSizeRel"     FORCE)
# set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "-m64 -fno-strict-aliasing -fno-omit-frame-pointer -O2 -g0" CACHE STRING "RelWithDebInfo" FORCE)

add_compile_definitions(GDE_EXPORT= _REENTRANT _THREAD_SAFE _FORTIFY_SOURCE=0)

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "FreeBSD")
    add_compile_definitions(_BSD_SOURCE)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "OpenBSD")
    add_compile_definitions(_BSD_SOURCE)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
    add_compile_definitions(_BSD_SOURCE)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
    add_compile_definitions(_GNU_SOURCE)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "SunOS")
    add_compile_definitions(_GNU_SOURCE)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    # TODO
else()
    # TODO
endif()

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    add_compile_definitions(_DEBUG GDE_BUILD_DEBUG)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    add_compile_definitions(NDEBUG GDE_BUILD_RELEASE)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    add_compile_definitions(NDEBUG GDE_BUILD_RELEASE GDE_BUILD_DEBUG)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    add_compile_definitions(NDEBUG GDE_BUILD_RELEASE GDE_BUILD_STRIP)
else()
    add_compile_definitions(GDE_BUILD_UNKNOWN)
endif()

# Add compiler options: general

add_compile_options(-m64 -fno-strict-aliasing -fno-omit-frame-pointer)

# Add compiler options: build type

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    add_compile_options(-O0 -g2)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    add_compile_options(-O0 -g2)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    add_compile_options(-O0 -g2)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    add_compile_options(-O0 -g2)
else()
    # TODO
endif()

# Add compiler options: platform

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "FreeBSD")
    add_compile_options(-pipe)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "OpenBSD")
    add_compile_options(-pipe)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
    add_compile_options(-pipe)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
    add_compile_options(-pipe)
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "SunOS")
    # Solaris can encounter compiler errors piping to /usr/ccs/as, so do not specify -pipe.
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    # TODO
else()
    # TODO
endif()

# Add compiler options: linkage

if(${GDE_STATIC})
    add_compile_options(-static -static-libgcc -static-libstdc++)
    add_link_options(-static -static-libgcc -static-libstdc++)
endif()

# Add compiler options: warnings

if(${GDE_WARN})
    add_compile_options(-Wall -Wextra)
else()
    add_compile_options(-w)
endif()

# Disable GNU c++ extensions.

set(CMAKE_CXX_EXTENSIONS OFF)
