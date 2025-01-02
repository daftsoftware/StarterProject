@echo off

PowerShell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -Command "& '%~dp0/Tools/Scripts/CookServerContent.ps1'"

pause