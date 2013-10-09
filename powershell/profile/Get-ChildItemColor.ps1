function Get-ChildItemColor {
    $fore = $Host.UI.RawUI.ForegroundColor
    Invoke-Expression ("Get-ChildItem $args") | % {
        if($_.GetType().Name -eq 'DirectoryInfo') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.directoriesColor
        } elseif($_.Name -match '\.(zip|tar|gz|rar|bz2|7z)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.archivesColor
        } elseif($_.Name -match '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|sh)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.executablesColor
        } elseif($_.Name -match '\.(cs|asax|aspx|spark|master|vb|c|cpp|h|hpp|ahk)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.codesColor
        } elseif($_.Name -match '\.(cfg|conf|ini|config|settings|pom.xml|properties|gitignore|gitattributes)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.settingsColor
        } elseif($_.Name -match '\.(txt|csv|sql|xml|psd1|ps1xml|markdown|readme|md|mkd|mkdn)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.plainTextColor
        } elseif($_.Name -match '\.(sln|csproj|vbproj|iml)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.projectsColor
        } elseif($_.Name -match '\.(docx|doc|xls|xlsx|pdf|mobi|epub|mpp)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.docsColor
        } elseif($_.Name -match '\.(nsf|dat)$') {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.dataColor
        } elseif($_.Name -match '\.(lnk)$') {
            # TODO check for symlinks as well
            $Host.UI.RawUI.ForegroundColor = $promptTheme.linksColor
        } else {
            $Host.UI.RawUI.ForegroundColor = $promptTheme.defaultColor
        }
        echo $_
    }
    $Host.UI.RawUI.ForegroundColor = $fore
}

Remove-Item alias:ls
Set-Alias ls Get-ChildItemColor -Option AllScope -Scope Global