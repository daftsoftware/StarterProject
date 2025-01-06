# Copyright (c) 2025 Daft Software.

. $PSScriptRoot/SetupEnv.ps1

& $uat BuildCookRun `
  	-target=StarterServer `
  	-project="$uprojectPath" `
  	-targetplatform=Win64 `
  	-serverconfig=Development `
	-cook `
  	-iostore `
  	-nop4