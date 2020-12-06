function New-SeDriverOptions {
    [cmdletbinding()]
    [OutputType(
        [OpenQA.Selenium.Chrome.ChromeOptions],
        [OpenQA.Selenium.Edge.EdgeOptions],
        [OpenQA.Selenium.Firefox.FirefoxOptions],
        [OpenQA.Selenium.IE.InternetExplorerOptions]
    )]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        $Browser,
        [StringUrlTransformAttribute()]
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ArgumentCompleter( { [Enum]::GetNames([SeWindowState]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeWindowState]) })]
        $State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait = 0.3,
        [System.Drawing.Size][SizeTransformAttribute()]$Size,
        [System.Drawing.Point][PointTransformAttribute()]$Position,
        $WebDriverPath,
        $BinaryPath,
        [String[]]$Switches,
        [String[]]$Arguments,
        $ProfilePath,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [SeDriverUserAgentTransformAttribute()]
        [ValidateNotNull()]
        [ArgumentCompleter( [SeDriverUserAgentCompleter])]
        [String]$UserAgent
    )
    if ($PSBoundParameters.ContainsKey('UserAgent')) { Test-SeDriverUserAgent -Browser $Browser -ErrorAction Stop }
    #  [Enum]::GetNames([sebrowsers])
    $output = $null
    switch ($Browser) {
        Chrome { $Output = [OpenQA.Selenium.Chrome.ChromeOptions]::new() }
        Edge { 
               $OptionSettings = @{ browserName = '' }
           
            if ($WebDriverPath -and -not (Test-Path -Path (Join-Path -Path $WebDriverPath -ChildPath 'msedgedriver.exe'))) {
                throw "Could not find msedgedriver.exe in $WebDriverPath"; return
            }
            elseif ($WebDriverPath -and (Test-Path (Join-Path -Path $WebDriverPath -ChildPath 'msedge.exe'))) {
                Write-Verbose -Message "Using browser from $WebDriverPath"
                $optionsettings['BinaryLocation'] = Join-Path -Path $WebDriverPath -ChildPath 'msedge.exe'
            }
            elseif ($BinaryPath) {
                $optionsettings['BinaryLocation'] = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BinaryPath)
                Write-Verbose -Message "Will request $($OptionSettings['BinaryLocation']) as the browser"
            }
            #BrowserName is Read-only so we use that method to create the new object
            $Output = New-Object -TypeName OpenQA.Selenium.Chrome.ChromeOptions -Property $OptionSettings
            
        }
        Firefox { $Output = [OpenQA.Selenium.Firefox.FirefoxOptions]::new() }
        InternetExplorer { $Output = [OpenQA.Selenium.IE.InternetExplorerOptions]::new() }
        MSEdge { $Output = [OpenQA.Selenium.Edge.EdgeOptions]::new() }
    }

    #Add members to be treated by Internal Start cmdlet since Start-SeDriver won't allow their use with Options parameter set.
    Add-Member -InputObject $output -MemberType NoteProperty -Name 'SeParams' -Value $PSBoundParameters
    

    return $output
}