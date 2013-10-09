[CmdletBinding()]
param ()

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

Get-ChildItem $scriptPath -include install.ps1 -recurse | %{
    $path = $_.FullName
    Write-Verbose "running installer: $path"
    &$path | Out-Host
}
