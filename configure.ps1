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

Set-Location -Path $CONFIGURE_REPOSITORY

$MAKEFILE_TEXT = @"
.SUFFIXES:

build: .phony
	@echo Build

install:
	@echo Installing to $CONFIGURE_PREFIX\lib\cmake\build
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build\module
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\module\gde.cmake $CONFIGURE_PREFIX\lib\cmake\build\module\gde.cmake
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build\template
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\template\gde-config.cmake $CONFIGURE_PREFIX\lib\cmake\build\template\gde-config.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\template\gde.pc $CONFIGURE_PREFIX\lib\cmake\build\template\gde.pc
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build\toolchain
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\default.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\default.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\msvc.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\msvc.cmake
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang\darwin.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang\darwin.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang\freebsd.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang\freebsd.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang\linux.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang\linux.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang\openbsd.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang\openbsd.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang\solaris.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang\solaris.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\clang\windows.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\clang\windows.cmake
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc\darwin.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc\darwin.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc\freebsd.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc\freebsd.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc\linux.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc\linux.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc\openbsd.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc\openbsd.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc\solaris.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc\solaris.cmake
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\gcc\windows.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\gcc\windows.cmake
	-@mkdir $CONFIGURE_PREFIX\lib\cmake\build\toolchain\msvc
    @copy /A /Y /V $CONFIGURE_REPOSITORY\src\cmake\toolchain\msvc\windows.cmake $CONFIGURE_PREFIX\lib\cmake\build\toolchain\msvc\windows.cmake

clean:
	@echo Clean

.phony:
"@

Set-Content -Path $CONFIGURE_REPOSITORY\makefile -Value $MAKEFILE_TEXT

Write-Output "OK."

