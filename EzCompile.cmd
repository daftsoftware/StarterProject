@echo off

PowerShell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -Command "& '%~dp0/Tools/Scripts/EzCompile.ps1'"

REM Check if there was an error (ERRORLEVEL non-zero means an error occurred)
if %ERRORLEVEL% neq 0 (
	echo Compiled with Errors
	pause
)