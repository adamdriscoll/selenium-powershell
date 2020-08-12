function Start-SeMSEdgeDriver {
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
        [OpenQA.Selenium.DriverOptions]$Options,
        [String[]]$Switches,
        [OpenQA.Selenium.LogLevel]$LogLevel
    )
    #region Edge set-up options
    if ($Headless) { Write-Warning 'Pre-Chromium Edge does not support headless operation; the Headless switch is ignored' }
    $service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService()
    $options = [OpenQA.Selenium.Edge.EdgeOptions]::new()
    if ($Quiet) { $service.HideCommandPromptWindow = $true }
    if ($PrivateBrowsing) { $options.UseInPrivateBrowsing = $true }
    if ($StartURL) { $options.StartPage = $StartURL }
    #endregion

    if ($PSBoundParameters.ContainsKey('LogLevel')) {
        Write-Warning "LogLevel parameter is not implemented for $($Options.SeParams.Browser)"
    }

    try {
        $Driver = [OpenQA.Selenium.Edge.EdgeDriver]::new($service , $options)
    }
    catch {
        $driverversion = (Get-Item .\assemblies\MicrosoftWebDriver.exe).VersionInfo.ProductVersion
        $WindowsVersion = [System.Environment]::OSVersion.Version.ToString()
        Write-Warning -Message "Edge driver is $driverversion. Windows is $WindowsVersion. If the driver is out-of-date, update it as a Windows feature,`r`nand then delete $PSScriptRoot\assemblies\MicrosoftWebDriver.exe"
        throw $_ ; return
    }
    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    #region post creation options
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)
    if ($Minimized) { $Driver.Manage().Window.Minimize() }
    if ($Maximized) { $Driver.Manage().Window.Maximize() }
    if ($FullScreen) { $Driver.Manage().Window.FullScreen() }
    #endregion

    Return $Driver
}