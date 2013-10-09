# Borrowed from: http://iextendable.com/2012/08/15/install-vscommandprompt-powershell-script-updated/
function Install-VSCommandPrompt($version = "2012") {
    switch ($version) {
        2012 { $toolsVersion = "110" }
        2010 { $toolsVersion = "100" }
        2008 { $toolsVersion = "90"  }
        2005 { $toolsVersion = "80"  }
        default {
            write-host "'$version' is not a recognized version."
            return
        }
    }

    # Set environment variables for Visual Studio Command Prompt
    $variableName = "VS" + $toolsVersion + "COMNTOOLS"
    $vspath = (get-childitem "env:$variableName").Value
    $vsbatchfile = "vsvars32.bat";
    $vsfullpath = [System.IO.Path]::Combine($vspath, $vsbatchfile);

    pushd $vspath
    cmd /c $vsfullpath + "&set" | % {
        if($_ -match '=') {
            $v = $_.split('=')
            set-item -force -path "ENV:\$($v[0])" -value "$($v[1])"
        }
    }
    popd
    $lines = msbuild /version
    $buildVersion = ''
    $frameworkVersion = ''
    if($lines) {
        $frameworkVersion = ". Framework v$(($lines[1].Substring($lines[1].LastIndexOf(' ')).Trim().TrimEnd(']')))"
        $buildVersion = ", Build v$($lines[0].Substring($lines[0].LastIndexOf(' ')).Trim())"
    }
    Write-Host "Visual Studio $version ($variableName) Command Prompt set$frameworkVersion$buildVersion." -f green
}