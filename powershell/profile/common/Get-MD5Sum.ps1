function Get-MD5Sum {
    <#
    .SYNOPSIS
        Calculates the MD5 hash for the specified file.

    .PARAMETER Target
        File to get the hash for.

    .EXAMPLE
        PS> Get-MD5Sum '.\MyTextFile.txt'
        -----------
        Description
        Calculates and returns the MD5 sum for the file MyTextFile.txt in the current directory.
    #>
    [CmdletBinding()]
    param (
        [ValidateScript({( Test-Path -Path $_ )})]
        [Parameter(Mandatory=$true, Position=0)]
        [string] $target
    )

    try {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        $path = Resolve-Path $filePath
        $file = [System.IO.File]::OpenRead($path)
        $hash = $md5.ComputeHash($file);
        [System.BitConverter]::ToString($hash).Replace('-', '')
    } finally {
        if ($md5) { $md5.dispose() }
    }
}