# The Abraxas Project
# Copyright (c) 2002-2020 Matthew Millett (mattrm456@gmail.com)

Set-Variable -name CONFIGURE_REPOSITORY -value $PSScriptRoot
Set-Variable -name CONFIGURE_UNAME -value "Windows"
Set-Variable -name CONFIGURE_PREFIX -value "C:\gde"
Set-Variable -name CONFIGURE_BUILD_DIRECTORY -value "$CONFIGURE_REPOSITORY\tmp"
Set-Variable -name CONFIGURE_JOBS -value 8
Set-Variable -name CONFIGURE_DEBUG -value $false
Set-Variable -name CONFIGURE_OPTIMIZE -value $false
Set-Variable -name CONFIGURE_CLEAN -value $false
Set-Variable -name CONFIGURE_TEST -value $false
Set-Variable -name CONFIGURE_WARN -value $false
Set-Variable -name CONFIGURE_VERBOSE -value $false

function Help {
    $HELP_TEXT = @"
usage: configure [--verbose] [--prefix <directory>]
where:
    --prefix     <directory>    Path to the installation directory [$CONFIGURE_PREFIX]
    --build-dir  <directory>    Path to the generated cmake artifacts [$CONFIGURE_BUILD_DIRECTORY)
    --jobs       <number>       Maximum number of parallel build jobs [$CONFIGURE_JOBS]
    --clean                     Clean build directory before configuring
    --debug                     Compile with debug symbols
    --optimize                  Compile with optimizations
    --test                      Enable test drivers
    --warn                      Enable warnings
    --verbose                   Generate makefiles with verbose output
"@
    Write-Output $HELP_TEXT
}

for ($i = 0; $i -lt $args.count; $i++) {
    if ($args[$i] -eq "--help") { 
        Help
        exit 0
    }
    elseif ($args[$i] -eq "--prefix") { 
        Set-Variable -name CONFIGURE_PREFIX -value $args[$i + 1]
        $i++
    }
    elseif ($args[$i] -eq "--build-dir") { 
        Set-Variable -name CONFIGURE_BUILD_DIRECTORY -value $args[$i + 1]
        $i++
    }
    elseif ($args[$i] -eq "--clean") { 
        Set-Variable -name CONFIGURE_CLEAN -value $true
    }
    elseif ($args[$i] -eq "--debug") { 
        Set-Variable -name CONFIGURE_DEBUG -value $true
    }
    elseif ($args[$i] -eq "--optimize") { 
        Set-Variable -name CONFIGURE_OPTIMIZE -value $true
    }
    elseif ($args[$i] -eq "--test") { 
        Set-Variable -name CONFIGURE_TEST -value $true
    }
    elseif ($args[$i] -eq "--warn") { 
        Set-Variable -name CONFIGURE_WARN -value $true
    }
    elseif ($args[$i] -eq "--verbose") { 
        Set-Variable -name CONFIGURE_VERBOSE -value $true
    }
    else {
        Help
        exit 1
    }
}

Set-Variable -name CONFIGURE_CMAKE -value cmake.exe

Set-Variable -name CONFIGURE_CMAKE_OPTION_INSTALL_PREFIX -value "-DCMAKE_INSTALL_PREFIX:PATH=$CONFIGURE_PREFIX"

if ($CONFIGURE_VERBOSE) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_VERBOSE_MAKEFILE -value "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
} 
else {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_VERBOSE_MAKEFILE -value "-DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF"
}

if ($CONFIGURE_TEST) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_GDE_TEST -value "-DGDE_TEST:BOOL=ON"
} 
else {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_GDE_TEST -value "-DGDE_TEST:BOOL=OFF"
}

if ($CONFIGURE_WARN) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_GDE_WARN -value "-DGDE_WARN:BOOL=ON"
} 
else {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_GDE_WARN -value "-DGDE_WARN:BOOL=OFF"
}

Set-Variable -name CONFIGURE_CMAKE_GENERATOR -value "-G `"Ninja`""

if ((-not $CONFIGURE_DEBUG) -and (-not $CONFIGURE_OPTIMIZE)) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_BUILD_TYPE -value "-DCMAKE_BUILD_TYPE:STRING=Release"
    Set-Variable -name CONFIGURE_BUILD_DIRECTORY -value "$CONFIGURE_BUILD_DIRECTORY\release"
}

if ((-not $CONFIGURE_DEBUG) -and ($CONFIGURE_OPTIMIZE)) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_BUILD_TYPE -value "-DCMAKE_BUILD_TYPE:STRING=Release"
    Set-Variable -name CONFIGURE_BUILD_DIRECTORY -value "$CONFIGURE_BUILD_DIRECTORY\release"
}


if (($CONFIGURE_DEBUG) -and (-not $CONFIGURE_OPTIMIZE)) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_BUILD_TYPE -value "-DCMAKE_BUILD_TYPE:STRING=Debug"
    Set-Variable -name CONFIGURE_BUILD_DIRECTORY -value "$CONFIGURE_BUILD_DIRECTORY\debug"
}

if (($CONFIGURE_DEBUG) -and ($CONFIGURE_OPTIMIZE)) {
    Set-Variable -name CONFIGURE_CMAKE_OPTION_BUILD_TYPE -value "-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo"
    Set-Variable -name CONFIGURE_BUILD_DIRECTORY -value "$CONFIGURE_BUILD_DIRECTORY\debug_release"
}

Set-Variable -Name CONFIGURE_BUILD_DIRECTORY -Value "$CONFIGURE_BUILD_DIRECTORY\obj"

if ($CONFIGURE_CLEAN) {
    if (Test-Path $CONFIGURE_BUILD_DIRECTORY) {
        Remove-Item -Force -Recurse $CONFIGURE_BUILD_DIRECTORY
        if (-not $?) {
            Write-Output "Failed to clean build directory '$CONFIGURE_BUILD_DIRECTORY'"
            exit 1
        }
    }
}

if (-not (Test-Path $CONFIGURE_BUILD_DIRECTORY)) {
    New-Item -ItemType directory -Path $CONFIGURE_BUILD_DIRECTORY | Out-Null
    if (-not $?) {
        Write-Output "Failed to create build directory '$CONFIGURE_BUILD_DIRECTORY'"
        exit 1
    }
}

if ((Get-Command "cl.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Write-Output "Setting Visual Studio environment variables"

    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

    $vcvarspath = &$vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath

    foreach($_ in cmd /c "`"$vcvarspath\VC\Auxiliary\Build\vcvars64.bat`" > nul 2>&1 & SET") {
        if ($_ -match '^([^=]+)=(.*)') {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}

Set-Location -Path $CONFIGURE_BUILD_DIRECTORY

Write-Output "$CONFIGURE_CMAKE $CONFIGURE_CMAKE_OPTION_INSTALL_PREFIX $CONFIGURE_CMAKE_OPTION_GDE_WARN $CONFIGURE_CMAKE_OPTION_GDE_TEST $CONFIGURE_CMAKE_OPTION_VERBOSE_MAKEFILE $CONFIGURE_CMAKE_OPTION_BUILD_TYPE $CONFIGURE_CMAKE_GENERATOR -DCMAKE_MODULE_PATH:PATH=$CONFIGURE_PREFIX\lib\cmake\build\module -DCMAKE_TOOLCHAIN_FILE:PATH=${CONFIGURE_PREFIX}\lib\cmake\build\toolchain\default.cmake ..\..\..\src"

Start-Process -Wait -NoNewWindow -FilePath $CONFIGURE_CMAKE -ArgumentList "$CONFIGURE_CMAKE_OPTION_INSTALL_PREFIX $CONFIGURE_CMAKE_OPTION_GDE_WARN $CONFIGURE_CMAKE_OPTION_GDE_TEST $CONFIGURE_CMAKE_OPTION_VERBOSE_MAKEFILE $CONFIGURE_CMAKE_OPTION_BUILD_TYPE $CONFIGURE_CMAKE_GENERATOR -DCMAKE_MODULE_PATH:PATH=$CONFIGURE_PREFIX\lib\cmake\build\module -DCMAKE_TOOLCHAIN_FILE:PATH=${CONFIGURE_PREFIX}\lib\cmake\build\toolchain\default.cmake ..\..\..\src"
if (-not $?) {
    Write-Output "Failed to configure"
    Set-Location -Path $CONFIGURE_REPOSITORY
    exit 1
}

Set-Location -Path $CONFIGURE_REPOSITORY

$MAKEFILE_TEXT = @"
.SUFFIXES:

build: .phony
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel $CONFIGURE_JOBS --target

build_test:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel $CONFIGURE_JOBS --target build_test

test:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target test

install:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target install

clean:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target clean

distclean:
	@rmdir /S /Q $CONFIGURE_DISTCLEAN_DIRECTORY

generate:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target generate

package:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target package

package_source:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target package_source

help:
	@$CONFIGURE_CMAKE --build $CONFIGURE_BUILD_DIRECTORY --parallel 1 --target help

.phony:
"@

Set-Content -Path $CONFIGURE_REPOSITORY\makefile -Value $MAKEFILE_TEXT

Write-Output "OK."

