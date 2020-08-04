function Invoke-SeScreenshot {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Global:SeDriver,

        [Parameter(Mandatory = $false)]
        [Switch]$AsBase64EncodedString
    )
    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Target)
    if ($AsBase64EncodedString) {
        $Screenshot.AsBase64EncodedString
    }
    else {
        $Screenshot
    }
}