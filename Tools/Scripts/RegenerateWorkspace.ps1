# Copyright (c) 2025 Daft Software.

. $PSScriptRoot/SetupEnv.ps1

function Find-UnrealVersionSelector {
    # First, check the specified directory
    $specifiedPath = "C:\Program Files (x86)\Epic Games\Launcher\Engine\Binaries\Win64\UnrealVersionSelector.exe"
    if (Test-Path $specifiedPath) {
        return $specifiedPath
    }

    # If not found, define likely base paths for a broader search
    $basePaths = @(
        "C:\Program Files\Epic Games",
        "C:\Program Files (x86)\Epic Games"
    )

    # Search for UnrealVersionSelector.exe in each base path
    foreach ($basePath in $basePaths) {
        $versionSelectorPaths = Get-ChildItem -Path $basePath -Recurse -Filter "UnrealVersionSelector.exe" -ErrorAction SilentlyContinue -File
        foreach ($path in $versionSelectorPaths) {
            if ($path) {
                return $path.FullName
            }
        }
    }

    throw "UnrealVersionSelector.exe not found."
}

function GenerateProjectFiles($uproject) {
    try {
        $versionSelector = Find-UnrealVersionSelector
        if (-not $versionSelector) {
            throw "Unreal Version Selector not found."
        }

        $fullProjectPath = (Resolve-Path $uproject).Path
        Write-Host "Using Unreal Version Selector at $versionSelector to generate project files for $fullProjectPath..."

        & $versionSelector /projectfiles "$fullProjectPath"
        if ($?) {
            Write-Host "Project files generated successfully."
        } else {
            Write-Host "Failed to generate project files."
        }
    } catch {
        Write-Host $_.Exception.Message
    }
}

GenerateProjectFiles $uproject
