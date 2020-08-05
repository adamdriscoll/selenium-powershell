function Start-SeInternetExplorer {
    [cmdletbinding(DefaultParameterSetName = 'Default')]
    [Alias('SeInternetExplorer', 'SeIE')]
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [switch]$Quiet,
        [switch]$AsDefaultDriver,
        [parameter(ParameterSetName = 'Maximized', Mandatory = $true)]
        [switch]$Maximized,
        [parameter(ParameterSetName = 'Minimized', Mandatory = $true)]
        [switch]$Minimized,
        [parameter(ParameterSetName = 'Fullscreen', Mandatory = $true)]
        [switch]$FullScreen,
        [Parameter(DontShow)]
        [parameter(ParameterSetName = 'Headless', Mandatory = $true)]
        [switch]$Headless,
        [Parameter(DontShow)]
        [Alias('Incognito')]
        [switch]$PrivateBrowsing,
        [switch]$IgnoreProtectedModeSettings,
        [int]$ImplicitWait = 10,
        $WebDriverDirectory = $env:IEWebDriver
    )
    #region IE set-up options
    if ($Headless -or $PrivateBrowsing) { Write-Warning 'The Internet explorer driver does not support headless or Inprivate operation; these switches are ignored' }

    $InternetExplorer_Options = [OpenQA.Selenium.IE.InternetExplorerOptions]::new()
    $InternetExplorer_Options.IgnoreZoomLevel = $true
    if ($IgnoreProtectedModeSettings) {
        $InternetExplorer_Options.IntroduceInstabilityByIgnoringProtectedModeSettings = $true
    }

    if ($StartURL) { $InternetExplorer_Options.InitialBrowserUrl = $StartURL }
    if ($WebDriverDirectory) { $Service = [OpenQA.Selenium.IE.InternetExplorerDriverService]::CreateDefaultService($WebDriverDirectory) }
    else { $Service = [OpenQA.Selenium.IE.InternetExplorerDriverService]::CreateDefaultService() }
    if ($Quiet) { $Service.HideCommandPromptWindow = $true }
    #endregion

    $Driver = [OpenQA.Selenium.IE.InternetExplorerDriver]::new($service, $InternetExplorer_Options)
    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    #region post creation options
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)
    if ($Minimized) {
        $Driver.Manage().Window.Minimize();
    }
    if ($Maximized) {
        $Driver.Manage().Window.Maximize()
    }
    if ($FullScreen) {
        $Driver.Manage().Window.FullScreen()
    }
    #endregion

    if ($AsDefaultDriver) {
        if ($Global:SeDriver) { $Global:SeDriver.Dispose() }
        $Global:SeDriver = $Driver
    }
    else { $Driver }
}