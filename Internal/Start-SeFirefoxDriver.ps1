function Start-SeFirefoxDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
        $Browser,
        [ValidateURIAttribute()]
        [Parameter(Position = 1)]
        [string]$StartURL,
        [ArgumentCompleter( { [Enum]::GetNames([SeWindowState]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeWindowState]) })]
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [switch]$Quiet,
        [int]$ImplicitWait = 10,
        $WebDriverPath = $env:GeckoWebDriver,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel
        
    )
    process {
        #region firefox set-up options
        $Firefox_Options = [OpenQA.Selenium.Firefox.FirefoxOptions]::new()

        if ($State -eq [SeWindowState]::Headless) {
            $Firefox_Options.AddArguments('-headless')
        }

        if ($DefaultDownloadPath) {
            Write-Verbose "Setting Default Download directory: $DefaultDownloadPath"
            $Firefox_Options.setPreference("browser.download.folderList", 2);
            $Firefox_Options.SetPreference("browser.download.dir", "$DefaultDownloadPath");
        }

        if ($PrivateBrowsing) {
            $Firefox_Options.SetPreference("browser.privatebrowsing.autostart", $true)
        }

        if ($PSBoundParameters.ContainsKey('LogLevel')) {
            Write-Verbose "Setting Firefox LogLevel to $LogLevel"
            $Options.LogLevel = $LogLevel
        }

        if (-not $PSBoundParameters.ContainsKey('Service')) {
            $ServiceParams = @{}
            if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
            if ($Quiet) { $ServiceParams.Add('Quiet', $Quiet) }
            $service = New-SeDriverService -Browser Firefox @ServiceParams
        }


        $Driver = [OpenQA.Selenium.Firefox.FirefoxDriver]::new($service, $Firefox_Options)
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }

        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)

        # [SeWindowState]
        switch ($State) {
            { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); break }
            { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() ; break }
            { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() ; break }
        }
        
        if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }
        #endregion

        Return $Driver
    }
}
