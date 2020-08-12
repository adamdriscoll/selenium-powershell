function New-SeScreenshot {
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(ParameterSetName = 'Path' , Position = 0, Mandatory = $true)]
        $Path,

        [Parameter(ParameterSetName = 'Path', Position = 1)]
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png,

        [Parameter(ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver = $Script:SeDriversCurrent ,

        [Parameter(ParameterSetName = 'Base64', Mandatory = $true)]
        [Switch]$AsBase64EncodedString,
        [Switch]$PassThru
    )
    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver)
    if ($AsBase64EncodedString) {
        return $Screenshot.AsBase64EncodedString 
    }
    elseif ($Path) {
        $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        $Screenshot.SaveAsFile($Path, $ImageFormat) 
    }
    if ($Passthru) { $Screenshot }
}