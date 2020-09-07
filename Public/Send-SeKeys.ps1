function Send-SeKeys {
    param(
        [Parameter( Position = 0, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [Parameter(Mandatory = $true, Position = 1)]
        [AllowEmptyString()]
        [string]$Keys,
        [switch]$ClearFirst,
        $SleepSeconds = 0 ,
        [switch]$Submit,
        [switch]$PassThru
    )
    begin {
        foreach ($Key in $Script:SeKeys.Name) {
            $Keys = $Keys -replace "{{$Key}}", [OpenQA.Selenium.Keys]::$Key
        }
    }
    process {
        if ($ClearFirst) { $Element.Clear() }

        $Element.SendKeys($Keys)

        if ($Submit) { $Element.Submit() }
        if ($SleepSeconds) { Start-Sleep -Seconds $SleepSeconds }
        if ($PassThru) { $Element }
    }
}
