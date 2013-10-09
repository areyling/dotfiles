[CmdletBinding()]
param (
    [Parameter(Position=0, Mandatory=$false)]
    [string[]] $modules = @('Find-String',
                            'pscx',
                            'posh-git',
                            'posh-npm',
                            'PsJson',
                            'PsUrl')
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# back up our current profile if one exists
if(Test-Path $profile) {
    Write-Verbose '... backing up the current PowerShell profile'
    $backupPath = [System.IO.Path]::ChangeExtension($profile,'.bak')
    if(Test-Path $backupPath) { Remove-Item -Path $backupPath -Force }
    Rename-Item $profile $backupPath -Force
}

# make sure PsGet is installed and loaded
if(-not (Get-Module -ListAvailable | ?{ $_.Name -eq 'PsGet' })) {
    Write-Verbose '... installing PsGet'
    (New-Object Net.WebClient).DownloadString('http://psget.net/GetPsGet.ps1') | iex
}
Import-Module PsGet

# install modules we want using PsGet
if($null -eq $modules) { $modules = @() }
$modules | %{
    Write-Verbose "... installing module using PsGet: $_"
    Install-Module $_
}

# add the modules directory to our PSModulePath environment variable (user)
$modulesPath = Join-Path $scriptPath 'modules'
$oldValue = [Environment]::GetEnvironmentVariable('PSModulePath','User')
if(-not [string]::IsNullOrEmpty($oldValue)) {
    $modulesPath = $modulesPath + ';' + $oldValue
}
[Environment]::SetEnvironmentVariable('PSModulePath',$modulesPath,'User')

# install the custom profile
$source = Join-Path $scriptPath 'profile\profile.ps1'
if(Test-Path $source) {
    (". '{0}'" -f $source) | Out-File $profile
    Write-Host 'Profile installed.' -f green
} else {
    Write-Error "Profile source not found: $source"
}