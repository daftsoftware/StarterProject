# Copyright (c) 2025 Daft Software.

. $PSScriptRoot/SetupEnv.ps1

Remove-Item -Path "$projectRoot/Intermediate/Build/Win64" -Recurse -Force
write-host "Cleaned Build/Win64"