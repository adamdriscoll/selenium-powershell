function Send-SeClick {
    [alias('SeClick')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Alias('JS')]
        [Switch]$JavaScriptClick,
        $SleepSeconds = 0 ,
        [Parameter(DontShow)]
        $Driver,
        [Alias('PT')]
        [switch]$PassThru
    )
    Process {
        if ($JavaScriptClick) { $Element.WrappedDriver.ExecuteScript("arguments[0].click()", $Element) }
        else { $Element.Click() }
        if ($SleepSeconds) { Start-Sleep -Seconds $SleepSeconds }
        if ($PassThru) { $Element }
    }
}