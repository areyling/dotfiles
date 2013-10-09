# prompt customization based on http://winterdom.com/2008/08/mypowershellprompt and https://github.com/tomasr
function Shorten-Path {
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, Position=0)]
    [ValidateScript({( Test-Path -Path $_ )})]
    [string] $path = (Get-Location).Path
)

    $loc = $path.Replace($HOME, '~').Replace($env:WINDIR, '[Windows]')
    # remove prefix for UNC paths
    $loc = $loc -replace '^[^:]+::', ''
    # make path shorter like tabs in Vim
    return ($loc -replace "\\(\.?)([^\\]{$global:promptTheme.shortenPathLength})[^\\]*(?=\\)",'\$1$2')
}