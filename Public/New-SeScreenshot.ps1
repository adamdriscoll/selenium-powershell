function New-SeScreenshot {
    [Alias('SeScreenshot')]
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(ParameterSetName = 'Path' , Position = 0, Mandatory = $true)]
        [Parameter(ParameterSetName = 'PassThru', Position = 0)]
        $Path,

        [Parameter(ParameterSetName = 'Path', Position = 1)]
        [Parameter(ParameterSetName = 'PassThru', Position = 1)]
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png,

        [Parameter(ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Script:SeDriversCurrent ,

        [Parameter(ParameterSetName = 'Base64', Mandatory = $true)]
        [Switch]$AsBase64EncodedString,

        [Parameter(ParameterSetName = 'PassThru', Mandatory = $true)]
        [Alias('PT')]
        [Switch]$PassThru
    )
    $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Target)
    if ($AsBase64EncodedString) { $Screenshot.AsBase64EncodedString }
    elseif ($Path) {
        $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
        $Screenshot.SaveAsFile($Path, $ImageFormat) 
    }
    if ($Passthru) { $Screenshot }
}