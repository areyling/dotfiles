function Get-Weather {
[CmdletBinding(DefaultParameterSetName='Current')]
param(
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ $_.Length -eq 5 })]
    [string] $zip,

    [Parameter(Position=1, Mandatory=$false, ParameterSetName='Current')]
    [ValidateSet('F','C')]
    [string] $unit = 'F',

    [Parameter(ParameterSetName='TenDay')]
    [Alias('t','ten')]
    [switch] $tenDay,

    [Parameter(ParameterSetName='Hourly')]
    [Alias('h')]
    [switch] $hourly
)
<#
.SYNOPSIS Retrieves weather information for an area.
.PARAMETER zip
    ZIP code to retrieve the weather for.
.PARAMETER unit
    Optional units for temperature ('F' for Fahrenheit or 'C' for Celsius). Defaults to 'F'.
.PARAMETER tenDay
    Alternatively launches web browser to 10-day forecast for the specified ZIP code.
.PARAMETER hourly
    Alternatively launches web browser to hourly forecast for the specified ZIP code.
.LINK http://blogs.technet.com/b/heyscriptingguy/archive/2010/11/07/use-powershell-to-retrieve-a-weather-forecast.aspx
.LINK http://poshcode.org/2508
#>

    if(Test-Connection -computer www.google.com -count 1 -quiet) {
        switch ($PSCmdlet.ParameterSetName) {
            'TenDay' { Start-Process "http://www.weather.com/weather/tenday/$($zip)" }
            'Hourly' { Start-Process "http://www.weather.com/weather/hourbyhour/$($zip)" }
            'Current' {
                [string]$url = 'http://weather.yahooapis.com/forecastrss?p=' + $zip + '&u=' + $unit
                [xml]$data = (New-Object System.Net.WebClient).DownloadString($url)
                # $data.rss.channel.item.condition
                if ($data.rss.channel.item.Title -eq "City not found") {
                    Write-Error "Could not find a location for $zip"
                } else {
                    # get forecast
                    New-Object PSObject -Property @{
                        Title = $data.rss.channel.item.Title
                        Condition = $data.rss.channel.item.condition.text
                        Temp = "$($data.rss.channel.item.condition.temp)$Unit"
                        ForecastDate = $data.rss.channel.item.forecast[0].date
                        ForecastCondition = $data.rss.channel.item.forecast[0].text
                        ForecastLow = "$($data.rss.channel.item.forecast[0].low)$unit"
                        ForecastHigh = "$($data.rss.channel.item.forecast[0].high)$unit"
                    }
                }
            }
        }
    }
}
Set-Alias weather Get-Weather -Option AllScope -Scope Global