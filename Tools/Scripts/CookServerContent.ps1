
. $PSScriptRoot/SetupEnv.ps1

& $uat BuildCookRun `
  	-target=FPSServer `
  	-project="$uprojectPath" `
  	-targetplatform=Win64 `
  	-serverconfig=Development `
	-cook `
  	-iostore `
  	-nop4