


include_guard(GLOBAL)

include(CMakeInitializeConfigs)


message(STATUS "GDE Build Toolchain 1.0.0")
set(GDE_TOOLCHAIN_DIR "${CMAKE_CURRENT_LIST_DIR}")

message(STATUS "GDE Build Toolchain: GDE_TOOLCHAIN_DIR = ${GDE_TOOLCHAIN_DIR}")

include(${GDE_TOOLCHAIN_DIR}/gcc.cmake)
