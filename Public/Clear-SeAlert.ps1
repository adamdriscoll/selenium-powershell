function Clear-SeAlert {
    param (
        [parameter(ParameterSetName = 'Alert', Position = 0, ValueFromPipeline = $true)]
        $Alert,
        [ValidateIsWebDriverAttribute()]
        $Driver = $Script:SeDriversCurrent,
        [ValidateSet('Accept', 'Dismiss')]
        $Action = 'Dismiss',
        [switch]$PassThru
    )
    if ($Driver) {
        try { 
            $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds 10))
            $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::AlertIsPresent()
            $WebDriverWait.Until($Condition)
            $Alert = $Driver.SwitchTo().alert() 
        }
        catch { Write-Warning 'No alert was displayed'; return }
    }
    if ($Alert) { $alert.$action() }
    if ($PassThru) { $Alert }
}

