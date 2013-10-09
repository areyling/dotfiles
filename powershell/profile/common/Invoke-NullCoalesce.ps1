function Invoke-NullCoalesce {
<#
.SYNOPSIS
    Mimics the C# ?? operator.

.EXAMPLE
    PS> ?? $myVar $myNullFallback
    -----------
    Description
    If $myVar is equal to $null, falls back to the value of $myNullFallback.
#>
param(
    [Parameter(Position=0)]
    [object[]] $values
)

    $result = $null
    $values | % { if($null -eq $result) { $result = $_ } }
    return $result
}

Set-Alias ?? Invoke-NullCoalesce -Option AllScope -Scope Global -Description 'Null coalesce operator'