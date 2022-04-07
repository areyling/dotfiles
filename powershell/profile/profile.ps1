$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$profilePath = Split-Path -Parent $profile
$scriptName = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$nppPath = "$(${env:ProgramFiles(x86)})\Notepad++\notepad++.exe"
$env:EDITOR = $nppPath

$MaximumHistoryCount = 1024
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')

$global:promptTheme = @{
    shortenPathLength = 3
    prefixColor = [ConsoleColor]::Cyan
    pathColor = [ConsoleColor]::Cyan
    delimiterColor = [ConsoleColor]::DarkCyan
    promptColor = [ConsoleColor]::Cyan
    hostnameColor = $(if($isAdmin) { [ConsoleColor]::Red } else { [ConsoleColor]::Green })
    stackColor = [ConsoleColor]::Yellow
    bannerColor = [ConsoleColor]::Green
    foregroundColor = [ConsoleColor]::Gray
    backgroundColor = [ConsoleColor]::Black
    # Get-ChildItemColor colors
    defaultColor = [ConsoleColor]::White
    directoriesColor = [ConsoleColor]::DarkGray
    archivesColor = [ConsoleColor]::Gray
    executablesColor = [ConsoleColor]::Green
    plainTextColor = [ConsoleColor]::Cyan
    docsColor = [ConsoleColor]::DarkCyan
    codesColor = [ConsoleColor]::Yellow
    projectsColor = [ConsoleColor]::DarkGreen
    settingsColor = [ConsoleColor]::Magenta
    dataColor = [ConsoleColor]::DarkMagenta
    linksColor = [ConsoleColor]::Blue
}

# import and configure posh-git
Import-Module posh-git
Enable-GitColors
# Start-SshAgent -Quiet
$GitPromptSettings.EnableWindowTitle = ''

# dot source helper scripts
Get-ChildItem $scriptPath -include *.ps1 -exclude $scriptName,*.Tests.ps1 -recurse | %{
    Write-Verbose "`tLoading $($_.FullName)"
    . $_.FullName
}
Get-Command | ?{ ($_.CommandType -match 'Alias|Function') -and [string]::IsNullOrEmpty($_.ModuleName) -and [string]::IsNullOrEmpty($_.Description) } | %{
    $_.Description = 'Profile'
}

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    if(!$?) {
        if($Error[0].FullyQualifiedErrorId -eq "CommandNotFoundException") {
            (Get-History | Select -Last 1).CommandLine | Missing
        }
    }

    Write-Host ([Environment]::UserName) -noNewLine -foregroundColor $promptTheme.hostnameColor
    Write-Host '@' -noNewLine -foregroundColor $promptTheme.delimiterColor
    Write-Host ([Environment]::MachineName.ToLower()) -noNewLine -foregroundColor $promptTheme.hostnameColor
    Write-Host ' {' -noNewLine -foregroundColor $promptTheme.delimiterColor
    Write-Host (Shorten-Path) -noNewLine -foregroundColor $promptTheme.pathColor
    Write-Host '}' -noNewLine -foregroundColor $promptTheme.delimiterColor

    # write location stack indicator
    if((Get-Location -Stack).Count -gt 0) {
        Write-Host ("$('+' * (get-location -stack).Count) ") -noNewLine -foregroundColor $promptTheme.stackColor
    }

    # add version control status, if we're in a repo
    if(Test-Repository '.git') { Write-VcsStatus; Write-Host ' '; }

    # §, [char]0x221e is infinity
    Write-Host "`n$([char]0x0A7)" -noNewLine -foregroundColor $promptTheme.promptColor
    $Host.UI.RawUI.ForegroundColor = $promptTheme.foregroundColor

    $global:LASTEXITCODE = $realLASTEXITCODE
    return ' '
}

# configure the window title, colors and buffer
$bits = $(if([IntPtr]::Size -eq 8) { '64-bit' } else { '32-bit' })
$title = "PowerShell v{0}.{1} ({2})" -f $Host.Version.Major,$Host.Version.Minor,$bits
if($isAdmin) { $title = 'Admin: ' + $title }
$Host.Ui.RawUi.WindowTitle = $title
$host.UI.RawUI.ForegroundColor = $promptTheme.foregroundColor
$host.UI.RawUI.BackgroundColor = $promptTheme.backgroundColor
[Console]::BackgroundColor = $promptTheme.backgroundColor
$bufferSize = $host.UI.RawUI.BufferSize
$bufferSize.Height = 6000
$host.UI.RawUI.BufferSize = $bufferSize