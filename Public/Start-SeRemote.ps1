function Start-SeRemote {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$RemoteAddress,
        [hashtable]$DesiredCapabilities,
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [Double]$ImplicitWait = 0.3,
        [System.Drawing.Size][SizeTransformAttribute()]$Size,
        [System.Drawing.Point][PointTransformAttribute()]$Position
    )

    $desired = [OpenQA.Selenium.Remote.DesiredCapabilities]::new()
    if (-not $DesiredCapabilities.Name) {
        $desired.SetCapability('name', [datetime]::now.tostring("yyyyMMdd-hhmmss"))
    }
    foreach ($k in $DesiredCapabilities.keys) { $desired.SetCapability($k, $DesiredCapabilities[$k]) }
    $Driver = [OpenQA.Selenium.Remote.RemoteWebDriver]::new($RemoteAddress, $desired)

    if (-not $Driver) { Write-Warning "Web driver was not created"; return }

    if ($PSBoundParameters.ContainsKey('Size')) { $Driver.Manage().Window.Size = $Size }
    if ($PSBoundParameters.ContainsKey('Position')) { $Driver.Manage().Window.Position = $Position }
    $Driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromMilliseconds($ImplicitWait * 1000)
    if ($StartURL) { $Driver.Navigate().GotoUrl($StartURL) }

    return $Driver
}