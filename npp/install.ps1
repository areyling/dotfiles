[CmdletBinding()]
param ()

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition;

if(-not $global:nppPath) { $global:nppPath = "$(${env:ProgramFiles(x86)})\Notepad++" }
if(-not (Test-Path $global:nppPath)) { throw 'Notepad++ not found!' }

$nppUserPath = Join-Path $env:userprofile 'AppData\Roaming\Notepad++'
if(-not (Test-Path $nppUserPath)) { &mkdir $nppUserPath | Out-Null }

# install user-defined languages
Get-ChildItem (Join-Path $scriptPath 'userDefineLang\*.xml') | %{
	$target = Join-Path $nppUserPath $_.Name;
	if(Test-Path $target) {
		$backupFile = $target.Replace('.xml', '.bak');
		if(Test-Path $backupFile) { Remove-Item $backupFile -Force }
		Rename-Item $target $backupFile;
	}
	Copy-Item $_.FullName $target;
}
<#
$langXmls = Get-ChildItem (Join-Path $scriptPath 'userDefineLang\*.xml') | %{
    $path = $_.FullName
    $xml = [xml](Get-Content $path)
    if($xml -and $xml.NotepadPlus -and $xml.NotepadPlus.UserLang) {
        Write-Verbose "... loaded Notepad++ user-defined language: $($xml.NotepadPlus.UserLang.name)"
        $xml
    } else {
        Write-Error "Invalid user-defined language file: $path"
    }
}
if($langXmls -and $langXmls.Count -gt 0) {
    # build the user-defined language definition xml
    $userLangXml = $langXmls[0]
    $root = $userLangXml.NotepadPlus
    $langXmls | Select -skip 1 | %{
        $node = $root.OwnerDocument.ImportNode($_.NotepadPlus.UserLang, $true)
        $root.AppendChild($node) | Out-Null
    }
    # and save it, backing up the existing definitions file if it exists
    $path = Join-Path $nppUserPath 'userDefineLang.xml'
    if(Test-Path $path) {
        Write-Verbose '... backing up the current Notepad++ user-defined language definitions file'
        $backupPath = [System.IO.Path]::ChangeExtension($path,'.bak')
        if(Test-Path $backupPath) { Remove-Item -Path $backupPath -Force }
        Rename-Item $path $backupPath -Force
    }
    $userLangXml.Save($path)
    Write-Verbose "... Notepad++ user-defined languages saved to: $path"
} else {
    Write-Verbose '... no valid user-defined language definitions found for Notepad++!'
}
#>

# install configuration/settings
@('config.xml',
  'contextMenu.xml',
  'shortcuts.xml',
  'stylers.xml') | %{
    $source = Join-Path $scriptPath $_
    if(Test-Path $source) {
        $path = Join-Path $nppUserPath $_
        if(Test-Path $path) {
            Write-Verbose "... backing up Notepad++ config file: $_"
            $backupPath = [System.IO.Path]::ChangeExtension($path,'.bak')
            if(Test-Path $backupPath) { Remove-Item -Path $backupPath -Force }
            Rename-Item $path $backupPath -Force
        }
        Copy-Item $source -Destination $path -Force
    } else {
        Write-Verbose "... skipping Notepad++ config file (file not found): $_"
    }
}

<#
# install themes
$nppThemesPath = Join-Path $global:nppPath 'themes'
# TODO add switch to remove existing themes (clean)
Get-ChildItem $scriptPath -include theme.*.xml | %{
    $name = $_.Name.Replace('theme.','')
    Copy-Item $_.FullName -Destination (Join-Path $nppThemesPath $name) -Force
    Write-Verbose "... copied Notepad++ theme: $name"
}
#>
