function Send-SeClick {
    [alias('SeClick')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Switch]$JavaScript,
        $SleepSeconds = 0 ,
        $Driver,
        [switch]$PassThru
    )
    Process {
        if ($JavaScript) { $Element.WrappedDriver.ExecuteScript("arguments[0].click()", $Element) }
        else { $Element.Click() }
        if ($SleepSeconds) { Start-Sleep -Seconds $SleepSeconds }
        if ($PassThru) { $Element }
    }
}