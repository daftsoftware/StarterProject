# Copyright (c) 2025 Daft Software.

. $PSScriptRoot/SetupEnv.ps1

$Global:buildTarget = "{0}Editor" -f $projectName

# Compile C++ for Development.
& $ubt -project="$uprojectPath" $buildTarget Win64 Development `
	-WaitMutex `
	-FromMsBuild `
    -architecture=x64 `

& $unreal -project="$uprojectPath"