function New-SeScreenshot {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(ParameterSetName = 'Base64', Mandatory = $true)]
        [Switch]$AsBase64EncodedString,
        [Parameter(ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver
    )
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver)

    if ($AsBase64EncodedString) {
        return $Screenshot.AsBase64EncodedString 
    }

    return $Screenshot
}