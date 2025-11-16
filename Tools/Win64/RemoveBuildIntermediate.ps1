# Copyright (c) 2025 Daft Software.

. $PSScriptRoot/SetupEnv.ps1

$pathToRemove = "$projectRoot/Intermediate/Build/Win64"
if (Test-Path -Path $pathToRemove) {
    Remove-Item -Path $pathToRemove -Recurse -Force
    Write-Host "Removed $pathToRemove"
} else {
    Write-Host "Directory $pathToRemove does not exist"
}

Start-Sleep -Seconds 2