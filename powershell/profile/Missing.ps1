<#
.SYNOPSIS
    A prompt helper for dealing with CommandNotFoundException.

.PARAMETER Input
    The CommandLine that caused the CommandNotFoundException to be thrown
#>
function Missing ([string] $input = (Get-History | Select -Last 1).CommandLine) {
    $cmdName = $^
    $cmdArgs = $input | % { $_.TrimStart($cmdName) }

    # check for an npm package command
    $npmCommand = Join-Path (Get-Location).Path "node_modules\.bin\$cmdName.cmd"
    if(Test-Path $npmCommand) {
        & $npmCommand $cmdArgs
        return ''
    }

    # TODO check if a space was used instead of a dash within a command ("get command" instead of "get-command")
}

# TODO search current location for script file and run it if the .\ was missing. Search all PATH vars as well?