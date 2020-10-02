function Start-SeInternetExplorerDriver {
    param(
        [string]$StartURL,
        [SeWindowState]$State,
        [System.IO.FileInfo]$DefaultDownloadPath,
        [switch]$PrivateBrowsing,
        [Double]$ImplicitWait,
        [System.Drawing.Size]$Size,
        [System.Drawing.Point]$Position,
        $WebDriverPath,
        $BinaryPath,
        [OpenQA.Selenium.DriverService]$service,
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel
    )

    $IgnoreProtectedModeSettings = Get-OptionsSwitchValue -Switches $Switches -Name  'IgnoreProtectedModeSettings'
    #region IE set-up options
    if ($state -eq [SeWindowState]::Headless -or $PrivateBrowsing) { Write-Warning 'The Internet explorer driver does not support headless or Inprivate operation; these switches are ignored' }

    $InternetExplorer_Options = [OpenQA.Selenium.IE.InternetExplorerOptions]::new()
    $InternetExplorer_Options.IgnoreZoomLevel = $true
    if ($IgnoreProtectedModeSettings) {
        $InternetExplorer_Options.IntroduceInstabilityByIgnoringProtectedModeSettings = $true
    }

    if ($StartURL) { $InternetExplorer_Options.InitialBrowserUrl = $StartURL }
    
    if (-not $PSBoundParameters.ContainsKey('Service')) {
        $ServiceParams = @{}
        if ($WebDriverPath) { $ServiceParams.Add('WebDriverPath', $WebDriverPath) }
        $service = New-SeDriverService -Browser InternetExplorer @ServiceParams
    }
    
    #endregion

    $Driver = [OpenQA.Selenium.IE.InternetExplorerDriver]::new($service, $InternetExplorer_Options)
    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    #region post creation options
    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)

    
    switch ($State) {
        { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); }
        { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() }
        { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() }
    }

    #endregion

    return $Driver
}