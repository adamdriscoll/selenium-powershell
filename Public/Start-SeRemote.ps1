function Start-SeRemote {
    <#
        .example
        #you can a remote testing account with testing bot at https://testingbot.com/users/sign_up
        #Set $key and $secret and then ...
        #see also https://crossbrowsertesting.com/freetrial / https://help.crossbrowsertesting.com/selenium-testing/getting-started/c-sharp/
        #and https://www.browserstack.com/automate/c-sharp
        $RemoteDriverURL = [uri]"http://$key`:$secret@hub.testingbot.com/wd/hub"
        #See https://testingbot.com/support/getting-started/csharp.html for values for different browsers/platforms
        $caps = @{
          platform     = 'HIGH-SIERRA'
          version      = '11'
          browserName  = 'safari'
        }
        Start-SeRemote -RemoteAddress $remoteDriverUrl -DesiredCapabilties $caps
    #>
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param(
        [string]$RemoteAddress,
        [hashtable]$DesiredCapabilities,
        [ValidateURIAttribute()]
        [Parameter(Position = 0)]
        [string]$StartURL,
        [switch]$AsDefaultDriver,
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

    if ($AsDefaultDriver) {
        if ($Global:SeDriver) { $Global:SeDriver.Dispose() }
        $Global:SeDriver = $Driver
    }
    else { $Driver }
}