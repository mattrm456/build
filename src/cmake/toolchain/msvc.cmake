
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

add_compile_definitions(GDE_EXPORT= WIN32 _WIN32 _MBCS _CONSOLE _CRT_SECURE_NO_DEPRECATE _CRT_SECURE_NO_WARNINGS _SCL_SECURE_NO_WARNINGS _ITERATOR_DEBUG_LEVEL=0)

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
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

add_compile_options(/nologo /bigobj /ERRORREPORT:NONE /MT /Z7 /GF /FD /EHa)
add_link_options(/NOLOGO /MACHINE:X64 /SUBSYSTEM:CONSOLE /INCREMENTAL:NO)

add_link_options(/DEFAULTLIB:kernel32.lib)
add_link_options(/DEFAULTLIB:user32.lib)
add_link_options(/DEFAULTLIB:gdi32.lib)
add_link_options(/DEFAULTLIB:winspool.lib)
add_link_options(/DEFAULTLIB:comdlg32.lib)
add_link_options(/DEFAULTLIB:advapi32.lib)
add_link_options(/DEFAULTLIB:shell32.lib)
add_link_options(/DEFAULTLIB:ole32.lib)
add_link_options(/DEFAULTLIB:oleaut32.lib)
add_link_options(/DEFAULTLIB:uuid.lib)
add_link_options(/DEFAULTLIB:odbc32.lib)
add_link_options(/DEFAULTLIB:odbccp32.lib)

# Add compiler options: build type

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    add_compile_options(/Od /RTC1)
    add_link_options(/DEBUG /OPT:NOREF)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    add_compile_options(/Ox /Ob2 /GL /GS-)
    add_link_options(/LTCG /OPT:REF)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    add_compile_options(/Ox /Ob2 /GL /GS-)
    add_link_options(/LTCG /OPT:REF)
elseif("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    add_compile_options(/Ox /Ob2 /GL /GS-)
    add_link_options(/LTCG /OPT:REF)
else()
    # TODO
endif()

# Add compiler options: platform

if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    # TODO
else()
    # TODO
endif()

# Add compiler options: linkage

# if(${GDE_STATIC})
#     add_compile_options(/MT)
# else()
#     add_compile_options(/MD)
# endif()

# Add compiler options: warnings

if(${GDE_WARN})
    add_compile_options(/W4)
else()
    add_compile_options(/W0)
endif()

