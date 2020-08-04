function Save-SeScreenshot {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.Screenshot]$Screenshot,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter()]
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png)

    process {
        $Screenshot.SaveAsFile($Path, $ImageFormat)
    }
}