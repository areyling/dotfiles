function Get-MappedDrive {
[CmdletBinding()]
param ()

    $lines = &wmic 'path','Win32_LogicalDisk','Where','DriveType="4"','get','DeviceID,','ProviderName'
    if($lines -and ($lines.Count -gt 1) -and ($lines[0].StartsWith('DeviceID'))) {
        $lines | ?{ $_ -and -not ($_.StartsWith('DeviceID')) } | %{
            $index = $_.IndexOf(':')
            if($index -ge 0) {
                New-Object PSObject -Property @{DriveLetter=$_.substring(0,$index); Path=$_.Substring($index+1).Trim()}
            } else {
                Write-Error "Failed to parse mapped drive for line: $_"
            }
        }
    }
}