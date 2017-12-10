#the directory where THIS script is executed
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\rarModule.psm1

$password = ReadPassword
RarSingleFolder "H:\rarTest\de st" "bla" "H:\rarTest\sou rce" "200k" "$password"

Write-Output "Finished."