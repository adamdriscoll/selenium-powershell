function Clear-SeAlert {
    param (
        [parameter(ParameterSetName = 'Alert', Position = 0, ValueFromPipeline = $true)]
        $Alert,
        [ValidateIsWebDriverAttribute()]
        $Driver,
        [ValidateSet('Accept', 'Dismiss')]
        $Action = 'Dismiss',
        [switch]$PassThru
    )
    Begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        $ImpTimeout = 0
    }
    Process {
        if ($Driver) {
            try { 
                $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver
                $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds 10))
                $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::AlertIsPresent()
                $WebDriverWait.Until($Condition)
                $Alert = $Driver.SwitchTo().alert() 
            }
            catch { 
                Write-Warning 'No alert was displayed'
                return 
            }
            Finally {
                Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
            }
        }
        if ($Alert) { $alert.$action() }
        if ($PassThru) { $Alert }
    }
    End {}
}

