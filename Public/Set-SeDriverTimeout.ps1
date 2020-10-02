function Set-SeDriverTimeout {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait',
        [Double]$Timeout        
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        $Driver.Manage().Timeouts().$TimeoutType = [timespan]::FromMilliseconds($Timeout * 1000)
    }
    End {}
}

