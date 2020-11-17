cmake_minimum_required(VERSION 3.12.0)

project(
    example
    VERSION
        0.1.0
    DESCRIPTION
        "GDE Build Example"
    HOMEPAGE_URL
        http://github.com/mattrm456/build
    LANGUAGES
        C CXX
)

set(CMAKE_NO_SYSTEM_FROM_IMPORTED 1)

include(CMakePackageConfigHelpers)

set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)

# find_package(infrastructure REQUIRED)

include(CTest)
enable_testing()

include(gde)

gde_project()

add_subdirectory(library/example)
add_subdirectory(executable/example-console)

gde_project_end()

include(CPack)



