function Start-SeFirefox {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [Alias('SeFirefox')]
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [array]$Arguments,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [alias('Incognito')]
        [switch]$PrivateBrowsing,
        [parameter(ParameterSetName = 'Headless', Mandatory = $true)]
        [switch]$Headless,
        [parameter(ParameterSetName = 'Minimized', Mandatory = $true)]
        [switch]$Maximized,
        [parameter(ParameterSetName = 'Maximized', Mandatory = $true)]
        [switch]$Minimized,
        [parameter(ParameterSetName = 'Fullscreen', Mandatory = $true)]
        [switch]$Fullscreen,
        [switch]$SuppressLogging,
        [switch]$Quiet,
        [switch]$AsDefaultDriver,
        [int]$ImplicitWait = 10,
        $WebDriverDirectory = $env:GeckoWebDriver
    )
    process {
        #region firefox set-up options
        $Firefox_Options = [OpenQA.Selenium.Firefox.FirefoxOptions]::new()

        if ($Headless) {
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

        if ($Arguments) {
            foreach ($Argument in $Arguments) {
                $Firefox_Options.AddArguments($Argument)
            }
        }

        if ($SuppressLogging) {
            # Sets GeckoDriver log level to Fatal.
            $Firefox_Options.LogLevel = 6
        }

        if ($WebDriverDirectory) { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($WebDriverDirectory) }
        elseif ($AssembliesPath) { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($AssembliesPath) }
        else { $service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService() }
        if ($Quiet) { $service.HideCommandPromptWindow = $true }
        #endregion

        $Driver = [OpenQA.Selenium.Firefox.FirefoxDriver]::new($service, $Firefox_Options)
        if (-not $Driver) { Write-Warning "Web driver was not created"; return }

        #region post creation options
        $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)
        if ($Minimized) { $Driver.Manage().Window.Minimize() }
        if ($Maximized) { $Driver.Manage().Window.Maximize() }
        if ($Fullscreen) { $Driver.Manage().Window.FullScreen() }
        if ($StartURL) { $Driver.Navigate().GoToUrl($StartURL) }
        #endregion

        if ($AsDefaultDriver) {
            if ($Global:SeDriver) { $Global:SeDriver.Dispose() }
            $Global:SeDriver = $Driver
        }
        else { $Driver }
    }
}