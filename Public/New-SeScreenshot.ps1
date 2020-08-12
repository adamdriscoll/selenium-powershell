function New-SeScreenshot {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver = $Script:SeDriversCurrent ,

        [Parameter(ParameterSetName = 'Base64', Mandatory = $true)]
        [Switch]$AsBase64EncodedString
    )
    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver)

    if ($AsBase64EncodedString) {
        return $Screenshot.AsBase64EncodedString 
    }

    return $Screenshot
}