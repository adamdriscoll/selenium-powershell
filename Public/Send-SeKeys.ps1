function Send-SeKeys {
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true, Position = 1)]
        [AllowEmptyString()]
        [string]$Keys,
        [switch]$PassThru
    )
    foreach ($Key in $Script:SeKeys.Name) {
        $Keys = $Keys -replace "{{$Key}}", [OpenQA.Selenium.Keys]::$Key
    }
    $Element.SendKeys($Keys)
    if ($PassThru) { $Element }
}


$Textinfo