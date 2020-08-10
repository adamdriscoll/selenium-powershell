
function Start-SeDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [OutputType([OpenQA.Selenium.IWebDriver])]
    param(
        #Common to all browsers
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        [Parameter(ParameterSetName = 'Default')]
        $Browser,
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ArgumentCompleter( { [Enum]::GetNames([SeWindowState]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeWindowState]) })]
        $State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [switch]$Quiet,
        [int]$ImplicitWait = 10,
        $WebDriverPath,
        $BinaryPath,
        [Parameter(ParameterSetName = 'DriverOptions')]
        [OpenQA.Selenium.DriverOptions]$Options,
        [Parameter(ParameterSetName = 'Default')]
        [String[]]$Switches,
        [String[]]$Arguments,
        $ProfilePath,
        [OpenQA.Selenium.LogLevel]$LogLevel,
        [Switch]$PassThru
        # See ParametersToRemove to view parameters that should not be passed to browsers internal implementations.
    )
    process {
        # Exclusive parameters to Start-SeDriver we don't want to pass down to anything else.
        # Still available through the variable directly within this cmdlet
        $ParametersToRemove = @('Arguments', 'Browser', 'PassThru')

        switch ($PSCmdlet.ParameterSetName) {
            'Default' { 
                $PSBoundParameters.Add('Options', (New-SeDriverOptions -Browser $Browser)) 
            }
            'DriverOptions' {
                $Options = $PSBoundParameters.Item('Options') 
                $SelectedBrowser = $Options.SeParams.Browser

                # Start-SeDrivers params overrides whatever is in the options. 
                # Any options parameter not specified by Start-SeDriver get added to the psboundparameters
                foreach ($Key in $Options.SeParams.Keys) {
                    if (! $PSBoundParameters.ContainsKey($Key)) {
                        $PSBoundParameters.Add($Key, $Options.SeParams.Item($Key))
                    }
                }

            }
        }

        if ($PSBoundParameters.ContainsKey('Arguments')) {
            foreach ($Argument in $Arguments) {
                $Options.AddArguments($Argument)
            }
        }

        
     

        #Remove params exclusive to this cmdlet before going further.
        $ParametersToRemove | ForEach-Object { if ($PSBoundParameters.ContainsKey("$_")) { $PSBoundParameters.Remove("$_") } }

        switch ($SelectedBrowser) {
            'Chrome' { $Driver = Start-SeChromeDriver @PSBoundParameters }
            'Edge' { $Driver = Start-EdgeDriver @PSBoundParameters }
            'Firefox' { $Driver = Start-SeFirefoxDriver @PSBoundParameters }
            'InternetExplorer' { $Driver = Start-SeInternetExplorerDriver @PSBoundParameters }
            'MSEdge' { $Driver = Start-SeMSEdgeDriver @PSBoundParameters }
        }

        if ($PassThru) {
            return $Driver
        }
    }
}

