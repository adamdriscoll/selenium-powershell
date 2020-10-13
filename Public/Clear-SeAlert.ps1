function Clear-SeAlert {
    [CmdletBinding()]
    param (
        [ValidateSet('Accept', 'Dismiss')]
        $Action = 'Dismiss',
        [parameter(ParameterSetName = 'Alert', ValueFromPipeline = $true)]
        $Alert,
        [switch]$PassThru
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
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

