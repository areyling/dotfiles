function Test-Repository {
[CmdletBinding()]
param(
    [parameter(Position=0, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $type,

    [Parameter(Position=1, Mandatory=$false)]
    [ValidateScript({ Test-Path $_ })]
    [Alias('Location','Target')]
    [string] $path = (Get-Location).Path
)

    if(-not $type.StartsWith('.')) { $type = ".$type" }

    if(Test-Path (Join-Path $path $type)) { return $true }

    $checkIn = (Get-Item $path).parent
    while($checkIn -ne $null) {
        $pathToTest = $checkIn.fullname + '/' + $type;
        if (Test-Path $pathToTest) { return $true }
        $checkIn = $checkIn.parent
    }

    return $false
}