
. $PSScriptRoot/SetupEnv.ps1

& $unreal $uprojectPath -game -customconfig=EOS -AUTH_LOGIN=localhost:6666 -AUTH_PASSWORD=Player1 -AUTH_TYPE=developer
