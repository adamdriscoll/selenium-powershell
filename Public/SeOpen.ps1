function SeOpen {
    [CmdletBinding()]
    Param(
        [ValidateSet('Chrome', 'CrEdge', 'FireFox', 'InternetExplorer', 'IE', 'MSEdge', 'NewEdge')]
        $In,
        [ValidateURIAttribute()]
        [Parameter(Mandatory = $False, Position = 1)]
        $URL,
        [hashtable]$Options = @{'Quiet' = $true },
        [int]$SleepSeconds
    )
    #Allow the browser to specified in an Environment variable if not passed as a parameter
    if ($env:DefaultBrowser -and -not $PSBoundParameters.ContainsKey('In')) {
        $In = $env:DefaultBrowser
    }
    #It may have been passed as a parameter, in an environment variable, or a parameter default, but if not, bail out
    if (-not $In) { throw 'No Browser was selected' }
    $StartParams = @{ }
    $StartParams += $Options
    $StartParams['AsDefaultDriver'] = $true
    $StartParams['Verbose'] = $false
    $StartParams['ErrorAction'] = 'Stop'
    $StartParams['Quiet'] = $true
    if ($url) {
        $StartParams['StartUrl'] = $url
    }

    switch -regex ($In) {
        'Chrome' { Start-SeChrome @StartParams; continue }
        'FireFox' { Start-SeFirefox @StartParams; continue }
        'MSEdge' { Start-SeEdge @StartParams; continue }
        'Edge$' { Start-SeNewEdge @StartParams; continue }
        '^I' { Start-SeInternetExplorer @StartParams; continue }
    }
    Write-Verbose -Message "Opened $($Script:SeDriversCurrent.Capabilities.browsername) $($Script:SeDriversCurrent.Capabilities.ToDictionary().browserVersion)"
    if ($SleepSeconds) { Start-Sleep -Seconds $SleepSeconds }
}