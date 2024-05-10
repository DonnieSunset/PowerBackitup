#the directory where THIS script is executed
#$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path

#Set-ExecutionPolicy Unrestricted

$ScriptDir="C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PowerBackitup\v0.2"
Import-Module $ScriptDir\rarModule.psm1

$Drive="P:\"
$Ending=".rar"
$password = ReadPassword


$name="Bilder"
RarSingleFolder "$Drive" "$name" "$Drive$name" "1G" "$password"

Write-Output "Finished."