function Set-ModifiedDate {
<#
.SYNOPSIS Sets the LastWriteTime of a file.

.PARAMETER Path
Path(s) to the item(s) to change.

.PARAMETER InputObject
Item(s) to change.

.PARAMETER Date
The new DateTime to use.

.EXAMPLE
PS> Set-ModifiedDate 'C:\myFile.txt'
-----------
Sets the LastWriteTime of C:\myFile.txt to now.
#>
[CmdletBinding(SupportsShouldProcess=$true, DefaultParameterSetName='Path')]
param (
    [Parameter(Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='Path')]
    [Alias('FullName','p')]
    [string[]] $path,

    [Parameter(Position=0, ValueFromPipeline=$true, ParameterSetName='InputObject')]
    [Alias('a','All')]
    [System.IO.FileSystemInfo[]] $inputObject,

    [Parameter(Position=1)]
    [ValidateNotNull()]
    [DateTime] $date = $(Get-Date),

    [Parameter(Mandatory=$false, ParameterSetName='Path')]
    [string] $encoding = $null
)

process {
    if($PSCmdlet.ParameterSetName -eq 'Path') {
        $path | %{
            if(-not (Test-Path $_)) {
                if($PSCmdlet.ShouldProcess("$_", 'Create')) {
                    if($null -eq $encoding) {
                        '' | Out-File $_
                    } else {
                        '' | Out-File $_ -Encoding $encoding
                    }
                }
            } elseif($PSCmdlet.ShouldProcess("$_", "LastWriteTime = $date")) {
                (Get-Item $_).LastWriteTime = $date
            }
        }
    } else {
        $inputObject | %{
            if($PSCmdlet.ShouldProcess("$_", "LastWriteTime = $date")) {
                $_.LastWriteTime = $date
            }
        }
    }
}
}

Set-Alias touch Set-ModifiedDate -Option AllScope -Scope Global