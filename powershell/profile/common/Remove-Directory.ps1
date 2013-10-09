function Remove-Directory {
[CmdletBinding(ConfirmImpact='Medium', SupportsShouldProcess)]
param (
    [Parameter(Position=0, Mandatory=$false)]
    [ValidateScript({ Test-Path $_ })]
    [string] $path = (Get-Location).Path
)

    if($PSCmdlet.ShouldProcess($path, 'Delete')) { &cmd /c rd /s /q $path }
}