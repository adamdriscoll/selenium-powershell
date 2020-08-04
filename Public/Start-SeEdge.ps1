function Start-SeEdge {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    [Alias('MSEdge', 'LegacyEdge', 'Start-SeLegacyEdge')]
    param(
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [parameter(ParameterSetName = 'Minimized', Mandatory = $true)]
        [switch]$Maximized,
        [parameter(ParameterSetName = 'Maximized', Mandatory = $true)]
        [switch]$Minimized,
        [parameter(ParameterSetName = 'Fullscreen', Mandatory = $true)]
        [switch]$FullScreen,
        [Alias('Incognito')]
        [switch]$PrivateBrowsing,
        [switch]$Quiet,
        [switch]$AsDefaultDriver,
        [Parameter(DontShow)]
        [switch]$Headless,
        [int]$ImplicitWait = 10
    )
    #region Edge set-up options
    if ($Headless) { Write-Warning 'Pre-Chromium Edge does not support headless operation; the Headless switch is ignored' }
    $service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService()
    $options = [OpenQA.Selenium.Edge.EdgeOptions]::new()
    if ($Quiet) { $service.HideCommandPromptWindow = $true }
    if ($PrivateBrowsing) { $options.UseInPrivateBrowsing = $true }
    if ($StartURL) { $options.StartPage = $StartURL }
    #endregion

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

    if ($AsDefaultDriver) {
        if ($Global:SeDriver) { $Global:SeDriver.Dispose() }
        $Global:SeDriver = $Driver
    }
    else { $Driver }
}