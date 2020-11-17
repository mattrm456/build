.SUFFIXES:

build: .phony
	@echo Build

install:
	@echo Installing to C:\gde\lib\cmake\build
	-@mkdir C:\gde\lib\cmake\build
	-@mkdir C:\gde\lib\cmake\build\module
    @copy /A /Y /V C:\development\build\src\cmake\module\gde.cmake C:\gde\lib\cmake\build\module\gde.cmake
	-@mkdir C:\gde\lib\cmake\build\template
    @copy /A /Y /V C:\development\build\src\cmake\template\gde-config.cmake C:\gde\lib\cmake\build\template\gde-config.cmake
    @copy /A /Y /V C:\development\build\src\cmake\template\gde.pc C:\gde\lib\cmake\build\template\gde.pc
	-@mkdir C:\gde\lib\cmake\build\toolchain
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\default.cmake C:\gde\lib\cmake\build\toolchain\default.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang.cmake C:\gde\lib\cmake\build\toolchain\clang.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc.cmake C:\gde\lib\cmake\build\toolchain\gcc.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\msvc.cmake C:\gde\lib\cmake\build\toolchain\msvc.cmake
	-@mkdir C:\gde\lib\cmake\build\toolchain\clang
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang\darwin.cmake C:\gde\lib\cmake\build\toolchain\clang\darwin.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang\freebsd.cmake C:\gde\lib\cmake\build\toolchain\clang\freebsd.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang\linux.cmake C:\gde\lib\cmake\build\toolchain\clang\linux.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang\openbsd.cmake C:\gde\lib\cmake\build\toolchain\clang\openbsd.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang\solaris.cmake C:\gde\lib\cmake\build\toolchain\clang\solaris.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\clang\windows.cmake C:\gde\lib\cmake\build\toolchain\clang\windows.cmake
	-@mkdir C:\gde\lib\cmake\build\toolchain\gcc
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc\darwin.cmake C:\gde\lib\cmake\build\toolchain\gcc\darwin.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc\freebsd.cmake C:\gde\lib\cmake\build\toolchain\gcc\freebsd.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc\linux.cmake C:\gde\lib\cmake\build\toolchain\gcc\linux.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc\openbsd.cmake C:\gde\lib\cmake\build\toolchain\gcc\openbsd.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc\solaris.cmake C:\gde\lib\cmake\build\toolchain\gcc\solaris.cmake
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\gcc\windows.cmake C:\gde\lib\cmake\build\toolchain\gcc\windows.cmake
	-@mkdir C:\gde\lib\cmake\build\toolchain\msvc
    @copy /A /Y /V C:\development\build\src\cmake\toolchain\msvc\windows.cmake C:\gde\lib\cmake\build\toolchain\msvc\windows.cmake

clean:
	@echo Clean

.phony:
