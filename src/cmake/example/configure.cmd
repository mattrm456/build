@echo off

powershell.exe -file %~dp0\configure.ps1 %*
if %ERRORLEVEL% neq 0 (
    echo Failed to configure
    exit /B %ERRORLEVEL%
)

exit /B 0

