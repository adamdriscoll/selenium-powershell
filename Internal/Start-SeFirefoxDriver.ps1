function Start-SeFirefoxDriver {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
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
            $service = New-SeDriverService -Browser Firefox @ServiceParams
        }


        $Driver = [OpenQA.Selenium.Firefox.FirefoxDriver]::new($service, $Firefox_Options)
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }

        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)

        if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
        if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }

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
