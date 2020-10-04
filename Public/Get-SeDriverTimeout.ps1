function Get-SeDriverTimeout {
    param(
        [Parameter(Position = 0)]
        [ValidateSet('ImplicitWait', 'PageLoad', 'AsynchronousJavaScript')]
        $TimeoutType = 'ImplicitWait',
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        return $Driver.Manage().Timeouts().$TimeoutType 
    }
    End {}
}

