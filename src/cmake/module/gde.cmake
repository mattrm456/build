###############################################################################
# The Abraxas Project
# Copyright (c) 2002-2019
###############################################################################

message(STATUS "GDE Build version 1.0.0")
set(GDE_MODULE_DIR "${CMAKE_CURRENT_LIST_DIR}")
message(STATUS "GDE Build: GDE_MODULE_DIR = ${GDE_MODULE_DIR}")

# Getting the real path is only available in CMake >= 3.19
# file(REAL_PATH ${PROJECT_SOURCE_DIR}/.. GDE_PROJECT_ROOT_DIR)
set(GDE_PROJECT_ROOT_DIR "${PROJECT_SOURCE_DIR}/..")
message(STATUS "GDE Build: GDE_PROJECT_ROOT_DIR = ${GDE_PROJECT_ROOT_DIR}")

# MRM: Change to be a subdirectory from the project root dir
set(GDE_PROJECT_GENERATOR_VSCODE_DIR "${GDE_PROJECT_ROOT_DIR}/.vscode")

set(GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_TASKS "${GDE_PROJECT_GENERATOR_VSCODE_DIR}/tasks.json")
set(GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_LAUNCH "${GDE_PROJECT_GENERATOR_VSCODE_DIR}/launch.json")
set(GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_SETTINGS "${GDE_PROJECT_GENERATOR_VSCODE_DIR}/settings.json")
set(GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_C_CPP_PROPERTIES "${GDE_PROJECT_GENERATOR_VSCODE_DIR}/c_cpp_properties.json")

set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS)
set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH)
set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_SETTINGS)
set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES)

message(STATUS "GDE Build: GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_TASKS = ${GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_TASKS}")

file(MAKE_DIRECTORY ${GDE_PROJECT_GENERATOR_VSCODE_DIR})

if("${GDE_TOOLCHAIN_COMPILER_CXX_NAME}" STREQUAL "cl")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS_PROBLEM_MATCHER "\$msCompile")
else()
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS_PROBLEM_MATCHER "\$gcc")
endif()

if("${GDE_TOOLCHAIN_COMPILER_CXX_NAME}" STREQUAL "cl")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH_TYPE "cppvsdbg")
else()
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH_TYPE "cppdbg")
endif()


if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_NAME "Linux")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_INTELLISENSE_MODE "clang-x64")
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_NAME "macOS")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_INTELLISENSE_MODE "clang-x64")
elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_NAME "Win32")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_INTELLISENSE_MODE "msvc-x64")
else()
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_NAME "Other")
    set(GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_C_CPP_PROPERTIES_INTELLISENSE_MODE "")
endif()


function (gde_project_generator_vscode_tasks_add_prolog)
    get_property(tasks_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS)
    string(APPEND tasks_text "\
{\n\
  \"version\": \"2.0.0\",\n\
  \"tasks\": [\n\
    {\n\
      \"type\": \"shell\",\n\
      \"label\": \"all\",\n\
      \"command\": \"${CMAKE_COMMAND}\",\n\
      \"args\": [\n\
        \"--build\",\n\
        \"${CMAKE_BINARY_DIR}\",\n\
        \"--parallel\",\n\
        \"8\",\n\
        \"--target\"\n\
      ],\n\
      \"problemMatcher\": [ \"${GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS_PROBLEM_MATCHER}\" ],\n\
      \"group\": {\n\
        \"kind\": \"build\",\n\
        \"isDefault\": true\n\
      }\n\
    }")
    set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS ${tasks_text})
endfunction()

function (gde_project_generator_vscode_tasks_add_target target)
    get_property(tasks_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS)
    string(APPEND tasks_text ",\n\
    {\n\
      \"type\": \"shell\",\n\
      \"label\": \"${target}\",\n\
      \"command\": \"${CMAKE_COMMAND}\",\n\
      \"args\": [\n\
        \"--build\",\n\
        \"${CMAKE_BINARY_DIR}\",\n\
        \"--parallel\",\n\
        \"8\",\n\
        \"--target\",\n\
        \"${target}\"\n\
      ],\n\
      \"problemMatcher\": [ \"${GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS_PROBLEM_MATCHER}\" ],\n\
      \"group\": {\n\
        \"kind\": \"build\",\n\
        \"isDefault\": true\n\
      }\n\
    }")
    set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS ${tasks_text})
endfunction()

function (gde_project_generator_vscode_tasks_add_epilog)
    get_property(tasks_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS)
    string(APPEND tasks_text "\n\
  ]\n\
}")
    set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS ${tasks_text})
endfunction()

function (gde_project_generator_vscode_tasks_write)
    get_property(tasks_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_TASKS)
    file(WRITE ${GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_TASKS} ${tasks_text})
endfunction()










function (gde_project_generator_vscode_launch_add_prolog)
    get_property(launch_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH)
    string(APPEND launch_text "\
{\n\
  \"version\": \"0.2.0\",\n\
  \"configuration\": [\n\
    {\n\
      \"name\": \"attach\",\n\
      \"type\": \"${GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH_TYPE}\",\n\
      \"request\": \"attach\",\n\
      \"externalConsole\": false\n\
    }")
    set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH ${launch_text})
endfunction()

function (gde_project_generator_vscode_launch_add_target target)
    get_property(launch_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH)
    get_filename_component(bin_dir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ABSOLUTE)
    string(APPEND launch_text ",\n\
    {\n\
      \"name\": \"${target}\",\n\
      \"type\": \"${GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH_TYPE}\",\n\
      \"request\": \"launch\",\n\
      \"program\": \"${bin_dir}/${target}${CMAKE_EXECUTABLE_SUFFIX}\",\n\
      \"args\": [],\n\
      \"stopAtEntry\": false,\n\
      \"cwd\": \"${bin_dir}\",\n\
      \"environment\": [],\n\
      \"externalConsole\": false\n\
    }")
    set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH ${launch_text})
endfunction()

function (gde_project_generator_vscode_launch_add_epilog)
    get_property(launch_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH)
    string(APPEND launch_text "\n\
  ]\n\
}")
    set_property(GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH ${launch_text})
endfunction()

function (gde_project_generator_vscode_launch_write)
    get_property(launch_text GLOBAL PROPERTY GDE_PROJECT_GENERATOR_VSCODE_FILE_TEXT_LAUNCH)
    file(WRITE ${GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_LAUNCH} ${launch_text})
endfunction()

function (gde_project_generator_vscode_c_cpp_properties_write)
    set(c_cpp_properties_text "")
    if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
        string(APPEND c_cpp_properties_text "\
{\n\
  \"version\": 4,\n\
  \"configurations\": [\n\
    {\n\
    \"name\": \"Linux\",\n\
      \"includePath\": [ \"${PROJECT_SOURCE_DIR}/**\", \"${CMAKE_INSTALL_PREFIX}/include\" ],\n\
      \"defines\": [ \"GDE_EXPORT=\" ],\n\
      \"compilerPath\": \"${GDE_TOOLCHAIN_COMPILER_CXX_PATH}\",\n\
      \"compilerArgs\": [ \"-I${PROJECT_SOURCE_DIR}\" ],\n\
      \"cStandard\": \"c11\",\n\
      \"cppStandard\": \"c++11\",\n\
      \"intelliSenseMode\": \"gcc-x64\"\n\
    }\n\
  ]\n\
}")
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
        string(APPEND c_cpp_properties_text "\
{\n\
  \"version\": 4,\n\
  \"configurations\": [\n\
    {\n\
      \"name\": \"macOS\",\n\
      \"includePath\": [ \"${PROJECT_SOURCE_DIR}/**\", \"${CMAKE_INSTALL_PREFIX}/include\" ],\n\
      \"defines\": [ \"GDE_EXPORT=\" ],\n\
      \"compilerPath\": \"${GDE_TOOLCHAIN_COMPILER_CXX_PATH}\",\n\
      \"compilerArgs\": [ \"-I${PROJECT_SOURCE_DIR}\" ],\n\
      \"cStandard\": \"c11\",\n\
      \"cppStandard\": \"c++11\",\n\
      \"intelliSenseMode\": \"clang-x64\",\n\
      \"macFrameworkPath\": [ \"/System/Library/Frameworks\", \"/Library/Frameworks\" ]\n\
    }\n\
  ]\n\
}")
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
        string(APPEND c_cpp_properties_text "\
{\n\
  \"version\": 4,\n\
  \"configurations\": [\n\
    {\n\
      \"name\": \"Win32\",\n\
      \"includePath\": [ \"${PROJECT_SOURCE_DIR}/**\", \"${CMAKE_INSTALL_PREFIX}/include\" ],\n\
      \"defines\": [ \"GDE_EXPORT=\" ],\n\
      \"windowsSdkVersion\": \"10.0.18362.0\",\n\
      \"compilerPath\": \"${GDE_TOOLCHAIN_COMPILER_CXX_PATH}\",\n\
      \"compilerArgs\": [ \"-I${PROJECT_SOURCE_DIR}\" ],\n\
      \"cStandard\": \"c11\",\n\
      \"cppStandard\": \"c++11\",\n\
      \"intelliSenseMode\": \"msvc-x64\"\n\
    }\n\
  ]\n\
}")
    endif()
    file(WRITE ${GDE_PROJECT_GENERATOR_VSCODE_FILE_PATH_C_CPP_PROPERTIES} ${c_cpp_properties_text})
endfunction()














# Load into the specified 'output' the directory of the file of the specified
# 'path', if any.
function (gde_dirname output path)
    get_filename_component(result ${path} DIRECTORY)
    set(${output} ${result} PARENT_SCOPE)
endfunction()

# Load into the specified 'output' the name of the file of the specified
# 'path', without the directory, but including the file extenions, if any,
# including the period.
function (gde_basename output path)
    get_filename_component(result ${path} NAME)
    set(${output} ${result} PARENT_SCOPE)
endfunction()

# Load into the specified 'output' the name of the file of the specified
# 'path', without the directory and the file extension, if any.
function (gde_barename output path)
    get_filename_component(result ${path} NAME_WE)
    set(${output} ${result} PARENT_SCOPE)
endfunction()

# Load into the specified 'output' the file extension of the specified 'path',
# if any, including the period.
function (gde_extension output path)
    get_filename_component(result ${path} EXT)
    set(${output} ${result} PARENT_SCOPE)
endfunction()

# Load into the specified 'output' the absolute path to the specified relative
# 'path'.
function (gde_fullpath output path)
    get_filename_component(result ${path} ABSOLUTE ${PROJECT_SOURCE_DIR})
    set(${output} ${result} PARENT_SCOPE)
endfunction()

# Add the specified 'library_group' aggregating the libraries specified
# subsequently as 'ARGN'.
function (gde_add_library_group library_group)
    set(library_index 0)
    foreach(library ${ARGN})
        set(object_library "${library}.objects")
        if(NOT(${library_index}))
            add_library(
                ${library_group}
                STATIC
                $<TARGET_OBJECTS:${object_library}>
            )
        else()
            target_sources(
                ${library_group}
                PRIVATE
                $<TARGET_OBJECTS:${object_library}>
            )
        endif()
        set(library_index 1)
    endforeach()

    target_include_directories(
        ${library_group}
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    )

    install(
        TARGETS
            ${library_group}
        EXPORT
            ${CMAKE_PROJECT_NAME}-targets
        RUNTIME
            DESTINATION
                bin
            COMPONENT
                runtime
        LIBRARY
            DESTINATION
                lib
            COMPONENT
                runtime
        ARCHIVE
            DESTINATION
                lib
            COMPONENT
                development
    )

endfunction()

# Add to the specified 'library' the library dependencies specified
# subsequently in 'ARGN'.
function (gde_add_library_dependency library)
    target_link_libraries(${library} PUBLIC ${ARGN})

    set(object_library "${library}.objects")
    target_link_libraries(${object_library} PUBLIC ${ARGN})
endfunction()

# Add the specified 'library' and associated object library from the sources
# specified subsequently as 'ARGN'.
function (gde_add_library library)

    set(object_library "${library}.objects")

    add_library(
        ${object_library}
        OBJECT
        ${ARGN}
    )

    add_library(
        ${library}
        STATIC
        $<TARGET_OBJECTS:${object_library}>
    )

    set_target_properties(
        ${library} PROPERTIES VERSION ${PROJECT_VERSION})

    set_target_properties(
        ${library} PROPERTIES SOVERSION ${PROJECT_VERSION_MAJOR})

    target_include_directories(
        ${library}
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    )

    target_include_directories(
        ${object_library}
        PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    )

    if("${CMAKE_SYSTEM_NAME}" STREQUAL "FreeBSD")

    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "OpenBSD")

        target_include_directories(
            ${library}
            SYSTEM PRIVATE
            /usr/X11R6/include)

        target_include_directories(
            ${object_library}
            SYSTEM PRIVATE
            /usr/X11R6/include)

        target_link_directories(
            ${library}
            PUBLIC
            /usr/X11R6/lib)

        target_link_directories(
            ${object_library}
            PUBLIC
            /usr/X11R6/lib)

    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")

    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")

        target_include_directories(
            ${library}
            SYSTEM PUBLIC
            /opt/local/include)

        target_include_directories(
            ${object_library}
            SYSTEM PUBLIC
            /opt/local/include)

        target_link_directories(
            ${library}
            PUBLIC
            /opt/local/lib)

        target_link_directories(
            ${object_library}
            PUBLIC
            /opt/local/lib)

    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "SunOS")

    endif()

    foreach(source ${ARGN})
        gde_dirname(source_dirname ${source})
        gde_basename(source_basename ${source})
        gde_barename(source_barename ${source})
        gde_extension(source_extension ${source})

        if("${source_dirname}" STREQUAL "")
            set(source_testpath "${source_barename}.t${source_extension}")
            set(header "${source_barename}.h")
            set(schema "${source_barename}.uidl")
        else()
            set(source_testpath
                "${source_dirname}/${source_barename}.t${source_extension}")
            set(header "${source_dirname}/${source_barename}.h")
            set(schema "${source_dirname}/${source_barename}.uidl")
        endif()

        gde_fullpath(source_fullpath ${source})

        STRING(REGEX REPLACE "^${PROJECT_SOURCE_DIR}/" "" source_projpath ${source_fullpath})
        gde_dirname(source_installdir ${source_projpath})

        gde_dirname(source_fullpath_dirname ${source_fullpath})
        set(header_fullpath
            "${source_fullpath_dirname}/${source_barename}.h")
        set(schema_fullpath
            "${source_fullpath_dirname}/${source_barename}.uidl")

        STRING(REGEX REPLACE "[/\\]" "." component_impl_build_target ${source_projpath})
        STRING(REGEX REPLACE "${source_extension}" "" component_impl_build_target ${component_impl_build_target})

        set(component_test_build_target "${component_impl_build_target}.t")

        # message("--")
        # message("source='${source}'")
        # message("header='${header}'")
        # message("schema='${schema}'")
        # message("source_barename='${source_barename}'")
        # message("source_basename='${source_basename}'")
        # message("source_extension='${source_extension}'")
        # message("source_dirname='${source_dirname}'")
        # message("source_testpath='${source_testpath}'")
        # message("source_fullpath='${source_fullpath}'")
        # message("source_projpath='${source_projpath}'")
        # message("source_installdir='${source_installdir}'")
        # message("header_fullpath='${header_fullpath}'")
        # message("schema_fullpath='${schema_fullpath}'")
        # message("proj_sourcedir='${PROJECT_SOURCE_DIR}'")
        # message("component_impl_build_target='${component_impl_build_target}'")
        # message("component_test_build_target='${component_test_build_target}'")

        if(${GDE_TEST})
            add_executable(
                ${component_test_build_target}
                EXCLUDE_FROM_ALL
                ${source_testpath}
            )

            add_dependencies(
                ${component_test_build_target}
                ${library}
            )

            add_dependencies(
                build_test
                ${component_test_build_target}
            )

            target_include_directories(
                ${component_test_build_target}
                PUBLIC
                $<INSTALL_INTERFACE:include>
                $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
            )

            target_link_libraries(
                ${component_test_build_target}
                PUBLIC
                ${library}
            )

            add_test(
                NAME ${component_test_build_target}
                COMMAND ${component_test_build_target}
            )

            set_tests_properties(${component_test_build_target} PROPERTIES TIMEOUT 60)

            gde_project_generator_vscode_tasks_add_target(${component_test_build_target})
            gde_project_generator_vscode_launch_add_target(${component_test_build_target})
        endif()

        if (EXISTS ${header_fullpath})
            install(
                FILES
                    ${header}
                DESTINATION
                    include/${source_installdir}
                COMPONENT
                    development
            )
        endif()

        if (EXISTS ${schema_fullpath})
            install(
                FILES
                    ${schema}
                DESTINATION
                    include/${source_installdir}
                COMPONENT
                    development
            )
        endif()

    endforeach()

    # Install the library to ${CMAKE_INSTALL_PREFIX}/lib.

    install(
        TARGETS
            ${library}
        RUNTIME
            DESTINATION
                bin
            COMPONENT
                runtime
        LIBRARY
            DESTINATION
                lib
            COMPONENT
                development
        ARCHIVE
            DESTINATION
                lib
            COMPONENT
                development
    )

    # Install the "Debug" build type configuration to its project-specific
    # directory.

    # install(
    #     TARGETS
    #         ${library}
    #     CONFIGURATIONS
    #         Debug
    #     ARCHIVE DESTINATION
    #         lib/${CMAKE_PROJECT_NAME}/debug
    #     LIBRARY DESTINATION
    #         lib/${CMAKE_PROJECT_NAME}/debug
    # )

    # Install the "Release" build type configuration to its project-specific
    # directory.

    # install(
    #     TARGETS
    #         ${library}
    #     CONFIGURATIONS
    #         Release
    #     ARCHIVE DESTINATION
    #         lib/${CMAKE_PROJECT_NAME}/release
    #     LIBRARY DESTINATION
    #         lib/${CMAKE_PROJECT_NAME}/release
    # )

    # Install the "RelWithDebInfo" build type configuration to its
    # project-specific directory.

    # install(
    #     TARGETS
    #         ${library}
    #     CONFIGURATIONS
    #         RelWithDebInfo
    #     ARCHIVE DESTINATION
    #         lib/${CMAKE_PROJECT_NAME}/debug_release
    #     LIBRARY DESTINATION
    #         lib/${CMAKE_PROJECT_NAME}/debug_release
    # )

    # TODO: Install a pkg-config .pc file to
    # ${CMAKE_INSTALL_PREFIX}/lib/pkgconfig

endfunction()

# Register the current project as a GDE-style repository layout. This
# function should be called in the top-level CMakeLists.txt file *after*
# the project() is declared.
function (gde_project)

    add_custom_target(
            generate
        COMMAND
            cloud generate --include "${PROJECT_SOURCE_DIR}" --include "${CMAKE_INSTALL_PREFIX}/include" ${PROJECT_SOURCE_DIR}
    )

    if(${GDE_TEST})
        add_custom_target(
            build_test
        )

    #add_dependencies(
    #        test
    #        build_test
    #    )

    #    add_dependencies(
    #        build_test
    #        all
    #    )

    endif()

    # Maintain a file structure like:
    #
    # bin - Application and test driver executable binaries
    # lib - Static and shared libraries
    # obj - CMake-generated and other compiler-generated artifacts
    # pkg - CPack-generated binary and source packages

    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../lib PARENT_SCOPE)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../lib PARENT_SCOPE)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin PARENT_SCOPE)
    set(CPACK_OUTPUT_FILE_PREFIX ${CMAKE_BINARY_DIR}/../pkg PARENT_SCOPE)

    # Do not include a top-level <project>-<version> directory in generated
    # source archive packages (e.g., .tar.gz).

    set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE PARENT_SCOPE)

    # Include the root of the repository when packaging.

    set(CPACK_SOURCE_INSTALLED_DIRECTORIES "${CMAKE_SOURCE_DIR}/..;/" PARENT_SCOPE)

    gde_project_generator_vscode_tasks_add_prolog()
    gde_project_generator_vscode_launch_add_prolog()

endfunction()


# Wrap up the declaration of the GDE project by instructing CMake how to
# generate and install the packaging meta-data.
function (gde_project_end)
    write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-config-version.cmake"
        VERSION
            ${CMAKE_PROJECT_VERSION}
        COMPATIBILITY
            AnyNewerVersion
    )

    export(
        EXPORT
            ${CMAKE_PROJECT_NAME}-targets
        FILE
            "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-targets.cmake"
        NAMESPACE
            ${CMAKE_PROJECT_NAME}::
    )

    configure_file(
        ${GDE_MODULE_DIR}/../template/gde-config.cmake
        "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-config.cmake"
        @ONLY
    )

    set(ConfigPackageLocation lib/cmake/${CMAKE_PROJECT_NAME})

    install(
        EXPORT
            ${CMAKE_PROJECT_NAME}-targets
        FILE
            ${CMAKE_PROJECT_NAME}-targets.cmake
        NAMESPACE
            ${CMAKE_PROJECT_NAME}::
        DESTINATION
            ${ConfigPackageLocation}
        COMPONENT
            development
    )

    install(
        FILES
            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-config.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-config-version.cmake
        DESTINATION
            ${ConfigPackageLocation}
        COMPONENT
            development
    )

    set(CPACK_PACKAGE_VENDOR "GDE" PARENT_SCOPE)
    set(CPACK_PACKAGE_DESCRIPTION ${PROJECT_NAME} PARENT_SCOPE)
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_DESCRIPTION} PARENT_SCOPE)
    set(CPACK_PACKAGE_CONTACT
        "Matthew Millett <mmillett@usvc.io>"
        PARENT_SCOPE)
    set(CPACK_PACKAGE_FILE_NAME
        ${PROJECT_NAME}-${PROJECT_VERSION}
        PARENT_SCOPE)
    set(CPACK_SOURCE_PACKAGE_FILE_NAME
        ${PROJECT_NAME}-${PROJECT_VERSION}-src
        PARENT_SCOPE)

    if("${CMAKE_SYSTEM_NAME}" STREQUAL "FreeBSD")
    set(CPACK_GENERATOR TGZ ZIP PARENT_SCOPE)
    set(CPACK_SOURCE_GENERATOR TGZ ZIP PARENT_SCOPE)
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "OpenBSD")
    set(CPACK_GENERATOR TGZ ZIP PARENT_SCOPE)
    set(CPACK_SOURCE_GENERATOR TGZ ZIP PARENT_SCOPE)
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    set(CPACK_GENERATOR TGZ ZIP DEB PARENT_SCOPE) # RPM
    set(CPACK_SOURCE_GENERATOR TGZ ZIP PARENT_SCOPE)
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
    set(CPACK_GENERATOR TGZ ZIP PARENT_SCOPE)
    set(CPACK_SOURCE_GENERATOR TGZ ZIP PARENT_SCOPE)
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "SunOS")
    set(CPACK_GENERATOR TGZ ZIP PARENT_SCOPE)
    set(CPACK_SOURCE_GENERATOR TGZ ZIP PARENT_SCOPE)
    endif()

    set(CPACK_SOURCE_IGNORE_FILES
        ".git" ".gitignore .vscode "
        "bin" "build" "cmake" "include" "lib" "obj" "pkg" "tmp"
        PARENT_SCOPE)

    set(CPACK_ARCHIVE_COMPONENT_INSTALL ON PARENT_SCOPE)

    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64" PARENT_SCOPE)
    #set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>=2.7-18)")
    #set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
    #set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
    #    "${CMAKE_CURRENT_SOURCE_DIR}/debian/postinst")

    gde_project_generator_vscode_tasks_add_epilog()
    gde_project_generator_vscode_tasks_write()

    gde_project_generator_vscode_launch_add_epilog()
    gde_project_generator_vscode_launch_write()

    gde_project_generator_vscode_c_cpp_properties_write()

endfunction()

###############################################################################
#
###############################################################################
function (gde_project_info)

# ------------------------- Begin Generic CMake Variable Logging ------------------

# /*	C++ comment style not allowed	*/


# if you are building in-source, this is the same as CMAKE_SOURCE_DIR, otherwise
# this is the top level directory of your build tree
MESSAGE( STATUS "CMAKE_BINARY_DIR:         " ${CMAKE_BINARY_DIR} )

# if you are building in-source, this is the same as CMAKE_CURRENT_SOURCE_DIR, otherwise this
# is the directory where the compiled or generated files from the current CMakeLists.txt will go to
MESSAGE( STATUS "CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR} )

# this is the directory, from which cmake was started, i.e. the top level source directory
MESSAGE( STATUS "CMAKE_SOURCE_DIR:         " ${CMAKE_SOURCE_DIR} )

# this is the directory where the currently processed CMakeLists.txt is located in
MESSAGE( STATUS "CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR} )

# contains the full path to the top level directory of your build tree
MESSAGE( STATUS "PROJECT_BINARY_DIR: " ${PROJECT_BINARY_DIR} )

# contains the full path to the root of your project source directory,
# i.e. to the nearest directory where CMakeLists.txt contains the PROJECT() command
MESSAGE( STATUS "PROJECT_SOURCE_DIR: " ${PROJECT_SOURCE_DIR} )

MESSAGE( STATUS "CMAKE_CACHEFILE_DIR: " ${CMAKE_CACHEFILE_DIR} )

# set this variable to specify a common place where CMake should put all executable files
# (instead of CMAKE_CURRENT_BINARY_DIR)
MESSAGE( STATUS "EXECUTABLE_OUTPUT_PATH: " ${EXECUTABLE_OUTPUT_PATH} )

# set this variable to specify a common place where CMake should put all libraries
# (instead of CMAKE_CURRENT_BINARY_DIR)
MESSAGE( STATUS "LIBRARY_OUTPUT_PATH:     " ${LIBRARY_OUTPUT_PATH} )

MESSAGE( STATUS "CMAKE_ARCHIVE_OUTPUT_DIRECTORY:     " ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} )
MESSAGE( STATUS "CMAKE_LIBRARY_OUTPUT_DIRECTORY:     " ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} )
MESSAGE( STATUS "CMAKE_RUNTIME_OUTPUT_DIRECTORY:     " ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} )

MESSAGE( STATUS "CMAKE_INSTALL_PREFIX: " ${CMAKE_INSTALL_PREFIX} )
MESSAGE( STATUS "CMAKE_INSTALL_BINDIR: " ${CMAKE_INSTALL_BINDIR} )
MESSAGE( STATUS "CMAKE_INSTALL_LIBDIR: " ${CMAKE_INSTALL_LIBDIR} )
MESSAGE( STATUS "CMAKE_INSTALL_DATADIR: " ${CMAKE_INSTALL_DATADIR} )

# tell CMake to search first in directories listed in CMAKE_MODULE_PATH
# when you use FIND_PACKAGE() or INCLUDE()
MESSAGE( STATUS "CMAKE_MODULE_PATH: " ${CMAKE_MODULE_PATH} )

# this is the complete path of the cmake which runs currently (e.g. /usr/local/bin/cmake)
MESSAGE( STATUS "CMAKE_COMMAND: " ${CMAKE_COMMAND} )

# this is the CMake installation directory
MESSAGE( STATUS "CMAKE_ROOT: " ${CMAKE_ROOT} )

# this is the filename including the complete path of the file where this variable is used.
MESSAGE( STATUS "CMAKE_CURRENT_LIST_FILE: " ${CMAKE_CURRENT_LIST_FILE} )

# this is linenumber where the variable is used
MESSAGE( STATUS "CMAKE_CURRENT_LIST_LINE: " ${CMAKE_CURRENT_LIST_LINE} )

# this is used when searching for include files e.g. using the FIND_PATH() command.
MESSAGE( STATUS "CMAKE_INCLUDE_PATH: " ${CMAKE_INCLUDE_PATH} )

# this is used when searching for libraries e.g. using the FIND_LIBRARY() command.
MESSAGE( STATUS "CMAKE_LIBRARY_PATH: " ${CMAKE_LIBRARY_PATH} )

# the complete system name, e.g. "Linux-2.4.22", "FreeBSD-5.4-RELEASE" or "Windows 5.1"
MESSAGE( STATUS "CMAKE_SYSTEM: " ${CMAKE_SYSTEM} )

# the short system name, e.g. "Linux", "FreeBSD" or "Windows"
MESSAGE( STATUS "CMAKE_SYSTEM_NAME: " ${CMAKE_SYSTEM_NAME} )

# only the version part of CMAKE_SYSTEM
MESSAGE( STATUS "CMAKE_SYSTEM_VERSION: " ${CMAKE_SYSTEM_VERSION} )

# the processor name (e.g. "Intel(R) Pentium(R) M processor 2.00GHz")
MESSAGE( STATUS "CMAKE_SYSTEM_PROCESSOR: " ${CMAKE_SYSTEM_PROCESSOR} )

# is TRUE on all UNIX-like OS's, including Apple OS X and CygWin
MESSAGE( STATUS "UNIX: " ${UNIX} )

# is TRUE on Windows, including CygWin
MESSAGE( STATUS "WIN32: " ${WIN32} )

# is TRUE on Apple OS X
MESSAGE( STATUS "APPLE: " ${APPLE} )

# is TRUE when using the MinGW compiler in Windows
MESSAGE( STATUS "MINGW: " ${MINGW} )

# is TRUE on Windows when using the CygWin version of cmake
MESSAGE( STATUS "CYGWIN: " ${CYGWIN} )

# is TRUE on Windows when using a Borland compiler
MESSAGE( STATUS "BORLAND: " ${BORLAND} )

# Microsoft compiler
MESSAGE( STATUS "MSVC: " ${MSVC} )
MESSAGE( STATUS "MSVC_IDE: " ${MSVC_IDE} )
MESSAGE( STATUS "MSVC60: " ${MSVC60} )
MESSAGE( STATUS "MSVC70: " ${MSVC70} )
MESSAGE( STATUS "MSVC71: " ${MSVC71} )
MESSAGE( STATUS "MSVC80: " ${MSVC80} )
MESSAGE( STATUS "CMAKE_COMPILER_2005: " ${CMAKE_COMPILER_2005} )


# set this to true if you don't want to rebuild the object files if the rules have changed,
# but not the actual source files or headers (e.g. if you changed the some compiler switches)
MESSAGE( STATUS "CMAKE_SKIP_RULE_DEPENDENCY: " ${CMAKE_SKIP_RULE_DEPENDENCY} )

# since CMake 2.1 the install rule depends on all, i.e. everything will be built before installing.
# If you don't like this, set this one to true.
MESSAGE( STATUS "CMAKE_SKIP_INSTALL_ALL_DEPENDENCY: " ${CMAKE_SKIP_INSTALL_ALL_DEPENDENCY} )

# If set, runtime paths are not added when using shared libraries. Default it is set to OFF
MESSAGE( STATUS "CMAKE_SKIP_RPATH: " ${CMAKE_SKIP_RPATH} )

# set this to true if you are using makefiles and want to see the full compile and link
# commands instead of only the shortened ones
MESSAGE( STATUS "CMAKE_VERBOSE_MAKEFILE: " ${CMAKE_VERBOSE_MAKEFILE} )

# this will cause CMake to not put in the rules that re-run CMake. This might be useful if
# you want to use the generated build files on another machine.
MESSAGE( STATUS "CMAKE_SUPPRESS_REGENERATION: " ${CMAKE_SUPPRESS_REGENERATION} )


# A simple way to get switches to the compiler is to use ADD_DEFINITIONS().
# But there are also two variables exactly for this purpose:

# the compiler flags for compiling C sources
MESSAGE( STATUS "CMAKE_C_FLAGS: " ${CMAKE_C_FLAGS} )

# the compiler flags for compiling C++ sources
MESSAGE( STATUS "CMAKE_CXX_FLAGS: " ${CMAKE_CXX_FLAGS} )


# Choose the type of build.  Example: set(CMAKE_BUILD_TYPE Debug)
MESSAGE( STATUS "CMAKE_BUILD_TYPE: " ${CMAKE_BUILD_TYPE} )

# if this is set to ON, then all libraries are built as shared libraries by default.
MESSAGE( STATUS "BUILD_SHARED_LIBS: " ${BUILD_SHARED_LIBS} )

# the compiler used for C files
MESSAGE( STATUS "CMAKE_C_COMPILER: " ${CMAKE_C_COMPILER} )

# the compiler used for C++ files
MESSAGE( STATUS "CMAKE_CXX_COMPILER: " ${CMAKE_CXX_COMPILER} )

# if the compiler is a variant of gcc, this should be set to 1
MESSAGE( STATUS "CMAKE_COMPILER_IS_GNUCC: " ${CMAKE_COMPILER_IS_GNUCC} )

# if the compiler is a variant of g++, this should be set to 1
MESSAGE( STATUS "CMAKE_COMPILER_IS_GNUCXX : " ${CMAKE_COMPILER_IS_GNUCXX} )

# the tools for creating libraries
MESSAGE( STATUS "CMAKE_AR: " ${CMAKE_AR} )
MESSAGE( STATUS "CMAKE_RANLIB: " ${CMAKE_RANLIB} )

#
#MESSAGE( STATUS ": " ${} )

# ------------------------- End of Generic CMake Variable Logging ------------------

endfunction()
