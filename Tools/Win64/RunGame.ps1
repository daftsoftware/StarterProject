# Copyright (c) 2025 Daft Software.

. $PSScriptRoot/SetupEnv.ps1

# Compile C++ for Development.
& $ubt -project="$uprojectPath" $projectName Win64 Development `
	-WaitMutex `
	-FromMsBuild `

& $unreal $uprojectPath -game -log -newconsole
