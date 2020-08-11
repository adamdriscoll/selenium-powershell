function Start-SeRemote {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$RemoteAddress,
        [hashtable]$DesiredCapabilities,
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [int]$ImplicitWait = 10
    )

    $desired = [OpenQA.Selenium.Remote.DesiredCapabilities]::new()
    if (-not $DesiredCapabilities.Name) {
        $desired.SetCapability('name', [datetime]::now.tostring("yyyyMMdd-hhmmss"))
    }
    foreach ($k in $DesiredCapabilities.keys) { $desired.SetCapability($k, $DesiredCapabilities[$k]) }
    $Driver = [OpenQA.Selenium.Remote.RemoteWebDriver]::new($RemoteAddress, $desired)

    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds($ImplicitWait)
    if ($StartURL) { $Driver.Navigate().GotoUrl($StartURL) }

    return $Driver
}