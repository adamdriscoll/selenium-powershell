function Start-SeInternetExplorerDriver {
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBrowsers]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBrowsers]) })]
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
        if ($Quiet) { $ServiceParams.Add('Quiet', $Quiet) }
        $service = New-SeDriverService -Browser InternetExplorer @ServiceParams
    }
    
    #endregion

    $Driver = [OpenQA.Selenium.IE.InternetExplorerDriver]::new($service, $InternetExplorer_Options)
    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    #region post creation options
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)

    
    switch ($State) {
        { $_ -eq [SeWindowState]::Minimized } { $Driver.Manage().Window.Minimize(); }
        { $_ -eq [SeWindowState]::Maximized } { $Driver.Manage().Window.Maximize() }
        { $_ -eq [SeWindowState]::Fullscreen } { $Driver.Manage().Window.FullScreen() }
    }

    #endregion

    return $Driver
}