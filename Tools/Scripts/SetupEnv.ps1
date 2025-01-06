# Copyright (c) 2025 Daft Software.

# Setup Environment Script - Provides scripts with paths like engine locations ect.

# Go up 2 directories from this script
$projectRoot = Split-Path -Parent -Path (Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition))

$uproject = Get-ChildItem -Path $projectPath -Filter "*.uproject"
$uprojectPath = Join-Path $projectRoot $uproject

# Extract the game name from the left-hand side of the .uproject file
$projectName = $uproject.Name.Split(".")[0]

# Since .uproject is really just a json file we can just read the unrealVersion from it
$unrealVersion = (Get-Content -Raw $uproject.FullName | ConvertFrom-Json).EngineAssociation

# Check if we are using a source build - launcher versions aren't wrapped in {}
$sourceBuild = $unrealVersion -match "\{" -and $unrealVersion -match "\}"

function Get-LauncherInstalledUEVersions($Ver = "*")
{
    $Ret = [System.Collections.ArrayList]@()
    $ProgramData = [Environment]::GetFolderPath([Environment+SpecialFolder]::CommonApplicationData)
    $LauncherInstalledFile = Join-Path $ProgramData "Epic\UnrealEngineLauncher\LauncherInstalled.dat"
    $JSONData = Get-Content -Raw $LauncherInstalledFile | ConvertFrom-JSON
    $JSONData.InstallationList | Where-Object {$_.AppName -like "UE_$Ver"} | ForEach-Object {[String]$_.InstallLocation}
}

function Get-RegistryInstalledUEVersion($Ver = "*")
{
    $path = "HKCU:\Software\Epic Games\Unreal Engine\Builds"
    $versionPath = (Get-ItemProperty -Path $path -Name $Ver -ErrorAction SilentlyContinue).$unrealVersion
    return $versionPath
}

write-host "---------------------- ENVIRONMENT ----------------------"

$enginePath = if($sourceBuild) { Get-RegistryInstalledUEVersion -Ver $unrealVersion } else { Get-LauncherInstalledUEVersions -Ver $unrealVersion }
write-host "Engine Path: $enginePath"

$unreal = Join-Path $enginePath "Engine\Binaries\Win64\UnrealEditor.exe"
write-host "Unreal Editor Path: $unreal"

$unrealCmd = Join-Path $enginePath "Engine\Binaries\Win64\UnrealEditor-Cmd.exe"
write-host "Unreal Editor Command Line Path: $unrealCmd"

$ubt = Join-Path $enginePath "Engine\Build\BatchFiles\Build.bat"
write-host "UBT Path: $ubt"

$uat = Join-Path $enginePath "Engine\Build\BatchFiles\RunUAT.bat"
write-host "UAT Path: $uat"

write-host "UProject Path: $uprojectPath"
write-host "Project Root: $projectRoot"
write-host "Project Name: $projectName"
write-host "Unreal Version: $unrealVersion"
write-host "Source Build: $sourceBuild"

write-host "---------------------- ENVIRONMENT ----------------------"
write-host ""
