@echo off

PowerShell.exe -NoProfile -NoLogo -ExecutionPolicy Bypass -Command "& '%~dp0/Tools/Scripts/RemoveProjectIntermediate.ps1'"
pause